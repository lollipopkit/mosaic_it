//! `models/manifest.toml`: which model files make up each release, pinned by
//! BLAKE3. Weights are not committed; the manifest is how a downloaded or
//! copied model is checked before use.
//!
//! The app finds newer releases in the same file as published
//! ([`sign`]: its Ed25519 signature on the first line, so a download is one
//! consistent object).

use std::path::{Path, PathBuf};

use ed25519_dalek::{Signature, Signer, SigningKey, Verifier, VerifyingKey};
use semver::Version;
use serde::{Deserialize, Serialize};

use crate::{Error, ModelMeta, Result};

/// What this build can run: see [`ModelEntry::format`].
pub const FORMAT: u32 = 1;

/// Verifies the published manifest (hex Ed25519). The secret key signs it in
/// `models/publish.sh`.
pub const PUBLIC_KEY: &str = "2b435bc66679138ea76caebab594aa0e289782a47c431f0f08189ec6342a9ceb";

fn one() -> u32 {
    1
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Manifest {
    #[serde(rename = "model", default)]
    pub models: Vec<ModelEntry>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ModelEntry {
    pub name: String,
    pub version: String,
    /// `tiled` (fixed input, for mobile accelerators) or `dynamic` (CPU).
    pub variant: String,
    /// ONNX file name; its sidecar is `<file>.json`.
    pub file: String,
    pub blake3: String,
    /// The sidecar holds the classes and the calibration, so it is pinned too.
    pub sidecar_blake3: String,
    /// Directory URL the model and its sidecar are published under; empty
    /// until they are.
    #[serde(default)]
    pub url: String,
    /// Raised when a release needs a newer app (classes it has no labels
    /// for, sidecar fields it does not read): apps skip entries above their
    /// [`FORMAT`].
    #[serde(default = "one")]
    pub format: u32,
}

fn err(p: &Path, e: impl std::fmt::Display) -> Error {
    Error::Meta(format!("{}: {e}", p.display()))
}

/// Hex BLAKE3 of a file.
pub fn blake3_file(p: &Path) -> Result<String> {
    let f = std::fs::File::open(p).map_err(|e| err(p, e))?;
    let mut h = blake3::Hasher::new();
    h.update_reader(f).map_err(|e| err(p, e))?;
    Ok(h.finalize().to_hex().to_string())
}

fn key<const N: usize>(what: &str, hex: &str) -> Result<[u8; N]> {
    let mut out = [0; N];
    hex::decode_to_slice(hex.trim(), &mut out).map_err(|e| Error::Meta(format!("{what}: {e}")))?;
    Ok(out)
}

/// `manifest` as published: its hex Ed25519 signature by the hex `secret`
/// key, a newline, then the manifest. Also returns the hex public key.
pub fn sign(manifest: &[u8], secret: &str) -> Result<(Vec<u8>, String)> {
    let k = SigningKey::from_bytes(&key("signing key", secret)?);
    let mut out = hex::encode(k.sign(manifest).to_bytes()).into_bytes();
    out.push(b'\n');
    out.extend_from_slice(manifest);
    Ok((out, hex::encode(k.verifying_key().to_bytes())))
}

impl Manifest {
    pub fn load(p: &Path) -> Result<Self> {
        let s = std::fs::read_to_string(p).map_err(|e| err(p, e))?;
        toml::from_str(&s).map_err(|e| err(p, e))
    }

    /// A downloaded manifest ([`sign`]'s output), accepted only if signed by
    /// `public_key` (hex; the app passes [`PUBLIC_KEY`]).
    pub fn signed(published: &[u8], public_key: &str) -> Result<Self> {
        let bad = |e: ed25519_dalek::SignatureError| Error::Meta(format!("manifest signature: {e}"));
        let split = published.iter().position(|&b| b == b'\n').unwrap_or(published.len());
        let (signature, manifest) = (&published[..split], published.get(split + 1..).unwrap_or_default());
        let signature = std::str::from_utf8(signature).map_err(|e| Error::Meta(format!("manifest signature: {e}")))?;
        VerifyingKey::from_bytes(&key("manifest key", public_key)?)
            .map_err(bad)?
            .verify(manifest, &Signature::from_bytes(&key("manifest signature", signature)?))
            .map_err(bad)?;
        let s = std::str::from_utf8(manifest).map_err(|e| Error::Meta(format!("manifest: {e}")))?;
        toml::from_str(s).map_err(|e| Error::Meta(format!("manifest: {e}")))
    }

    /// The newest published `variant` release this build can run, if it is
    /// newer than the model at `installed`. A model that is not a listed
    /// `variant` release is the user's own choice and is never replaced.
    pub fn update(&self, variant: &str, installed: Option<&Path>) -> Result<Option<&ModelEntry>> {
        let current = match installed.map(|p| self.verify(p)) {
            Some(Ok(e)) if e.variant == variant => Version::parse(&e.version).ok(),
            Some(_) => return Ok(None),
            None => None,
        };
        let newest = self
            .models
            .iter()
            .filter(|m| m.variant == variant && !m.url.is_empty() && m.format <= FORMAT)
            .filter_map(|m| Some((Version::parse(&m.version).ok()?, m)))
            .max_by(|a, b| a.0.cmp(&b.0));
        Ok(newest
            .filter(|(v, _)| current.as_ref().is_none_or(|c| v > c))
            .map(|(_, m)| m))
    }

    /// Checks a model and its sidecar against the manifest. Releases share
    /// file names across versions, so the model's hash picks the entry.
    pub fn verify(&self, model: &Path) -> Result<&ModelEntry> {
        let name = model.file_name().and_then(|n| n.to_str()).unwrap_or_default();
        let listed: Vec<&ModelEntry> = self.models.iter().filter(|m| m.file == name).collect();
        if listed.is_empty() {
            return Err(err(model, "not listed in the manifest"));
        }
        let got = blake3_file(model)?;
        let same: Vec<&&ModelEntry> = listed.iter().filter(|m| m.blake3 == got).collect();
        if same.is_empty() {
            let versions: Vec<&str> = listed.iter().map(|m| m.version.as_str()).collect();
            return Err(err(
                model,
                format!("blake3 {got} matches no listed version ({})", versions.join(", ")),
            ));
        }
        // Versions can share weights and differ only in calibration.
        let sidecar = ModelMeta::sidecar(model);
        let got = blake3_file(&sidecar)?;
        let e = same.iter().find(|m| m.sidecar_blake3 == got).ok_or_else(|| {
            let versions: Vec<&str> = same.iter().map(|m| m.version.as_str()).collect();
            err(
                &sidecar,
                format!(
                    "blake3 {got} matches the sidecar of no version with these weights ({})",
                    versions.join(", ")
                ),
            )
        })?;
        Ok(e)
    }
}

impl ModelEntry {
    /// An entry describing the files as they are now.
    pub fn describe(model: &Path, name: &str, version: &str, variant: &str) -> Result<Self> {
        Ok(Self {
            name: name.into(),
            version: version.into(),
            variant: variant.into(),
            file: model
                .file_name()
                .and_then(|n| n.to_str())
                .ok_or_else(|| err(model, "no file name"))?
                .into(),
            blake3: blake3_file(model)?,
            sidecar_blake3: blake3_file(&ModelMeta::sidecar(model))?,
            url: String::new(),
            format: FORMAT,
        })
    }

    /// Where the model is published.
    pub fn model_url(&self) -> String {
        format!("{}/{}", self.url.trim_end_matches('/'), self.file)
    }

    /// Where the sidecar is published.
    pub fn sidecar_url(&self) -> String {
        format!("{}.json", self.model_url())
    }

    /// As a `[[model]]` table to paste into the manifest.
    pub fn to_toml(&self) -> Result<String> {
        let m = Manifest {
            models: vec![self.clone()],
        };
        toml::to_string(&m).map_err(|e| Error::Meta(e.to_string()))
    }
}

/// Default manifest location relative to the repository root.
pub fn default_manifest() -> PathBuf {
    PathBuf::from("models/manifest.toml")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn verify_accepts_listed_files_and_rejects_changes() {
        let dir = std::env::temp_dir().join(format!("unseen-manifest-{}", std::process::id()));
        std::fs::create_dir_all(&dir).unwrap();
        let model = dir.join("m.onnx");
        std::fs::write(&model, b"weights").unwrap();
        std::fs::write(ModelMeta::sidecar(&model), b"{}").unwrap();
        let entry = ModelEntry::describe(&model, "m", "1", "tiled").unwrap();
        let manifest: Manifest = toml::from_str(&entry.to_toml().unwrap()).unwrap();
        assert!(manifest.verify(&model).is_ok());
        // A recalibrated sidecar no longer matches.
        std::fs::write(ModelMeta::sidecar(&model), b"{\"calibration\":1}").unwrap();
        assert!(manifest.verify(&model).is_err());
        assert!(manifest.verify(&dir.join("other.onnx")).is_err());
        std::fs::remove_dir_all(&dir).unwrap();
    }

    #[test]
    fn signed_manifest_offers_only_newer_runnable_releases() {
        let dir = std::env::temp_dir().join(format!("unseen-manifest-u-{}", std::process::id()));
        std::fs::create_dir_all(&dir).unwrap();
        let model = dir.join("m.onnx");
        let mut text = String::new();
        // 3.0.0 needs a newer app, 0.9.0 is not published.
        for (v, url, format) in [
            ("1.0.0", "https://x/1", 1),
            ("2.0.0", "https://x/2/", 1),
            ("3.0.0", "https://x/3", 2),
            ("0.9.0", "", 1),
        ] {
            std::fs::write(&model, v).unwrap();
            std::fs::write(ModelMeta::sidecar(&model), v).unwrap();
            let mut e = ModelEntry::describe(&model, "m", v, "tiled").unwrap();
            e.url = url.into();
            e.format = format;
            text += &e.to_toml().unwrap();
        }
        let secret = "11".repeat(32);
        let (published, public) = sign(text.as_bytes(), &secret).unwrap();
        let m = Manifest::signed(&published, &public).unwrap();
        assert!(Manifest::signed(&[&published[..], b" "].concat(), &public).is_err());
        assert!(Manifest::signed(&published, &"22".repeat(32)).is_err());
        assert!(Manifest::signed(text.as_bytes(), &public).is_err());

        let newest = m.update("tiled", None).unwrap().unwrap();
        assert_eq!(
            (newest.version.as_str(), newest.model_url().as_str()),
            ("2.0.0", "https://x/2/m.onnx")
        );
        assert_eq!(newest.sidecar_url(), "https://x/2/m.onnx.json");
        assert!(m.update("dynamic", None).unwrap().is_none());
        // Installed 0.9.0 is older; 2.0.0 is current; unknown files are the user's.
        assert_eq!(m.update("tiled", Some(&model)).unwrap().unwrap().version, "2.0.0");
        for (content, offered) in [("2.0.0", false), ("1.0.0", true), ("mine", false)] {
            std::fs::write(&model, content).unwrap();
            std::fs::write(ModelMeta::sidecar(&model), content).unwrap();
            assert_eq!(m.update("tiled", Some(&model)).unwrap().is_some(), offered, "{content}");
        }
        // A release of another variant was imported on purpose.
        assert!(m.update("dynamic", Some(&model)).unwrap().is_none());
        std::fs::remove_dir_all(&dir).unwrap();
    }

    #[test]
    fn verify_picks_the_version_by_hash() {
        let dir = std::env::temp_dir().join(format!("unseen-manifest-v-{}", std::process::id()));
        std::fs::create_dir_all(&dir).unwrap();
        let model = dir.join("m.onnx");
        let mut text = String::new();
        for (v, w) in [("1", "old"), ("2", "new")] {
            std::fs::write(&model, w).unwrap();
            std::fs::write(ModelMeta::sidecar(&model), v).unwrap();
            text += &ModelEntry::describe(&model, "m", v, "tiled")
                .unwrap()
                .to_toml()
                .unwrap();
        }
        let manifest: Manifest = toml::from_str(&text).unwrap();
        assert_eq!(manifest.verify(&model).unwrap().version, "2");
        std::fs::write(&model, "old").unwrap();
        std::fs::write(ModelMeta::sidecar(&model), "1").unwrap();
        assert_eq!(manifest.verify(&model).unwrap().version, "1");
        // Version 1 weights with version 2's sidecar.
        std::fs::write(ModelMeta::sidecar(&model), "2").unwrap();
        assert!(manifest.verify(&model).is_err());
        std::fs::remove_dir_all(&dir).unwrap();
    }

    #[test]
    fn verify_tells_recalibrations_of_one_model_apart() {
        let dir = std::env::temp_dir().join(format!("unseen-manifest-c-{}", std::process::id()));
        std::fs::create_dir_all(&dir).unwrap();
        let model = dir.join("m.onnx");
        std::fs::write(&model, "weights").unwrap();
        let mut text = String::new();
        for v in ["1", "2"] {
            std::fs::write(ModelMeta::sidecar(&model), v).unwrap();
            text += &ModelEntry::describe(&model, "m", v, "tiled")
                .unwrap()
                .to_toml()
                .unwrap();
        }
        let manifest: Manifest = toml::from_str(&text).unwrap();
        assert_eq!(manifest.verify(&model).unwrap().version, "2");
        std::fs::write(ModelMeta::sidecar(&model), "1").unwrap();
        assert_eq!(manifest.verify(&model).unwrap().version, "1");
        std::fs::remove_dir_all(&dir).unwrap();
    }
}
