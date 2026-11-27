#!/usr/bin/env bash
# Package a built Flutter Linux release bundle into:
#   - <APP_NAME>_v<VERSION>_amd64.deb
#   - <APP_NAME>_v<VERSION>_x86_64.rpm
#   - <APP_NAME>_v<VERSION>_linux_amd64.tar.gz (portable bundle + freedesktop metadata)
#
# Usage:
#   app/tool/package-linux-native.sh \
#     --bundle app/build/linux/x64/release/bundle \
#     --version 1.0.9 \
#     --out dist \
#     [--app-name MosaicIt] \
#     [--release-date YYYY-MM-DD] \
#     [--skip-nfpm]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$APP_DIR/.." && pwd)"

APP_ID="com.lollipopkit.unseen"
APP_NAME="MosaicIt"
BINARY_NAME="mosaicit"
BUNDLE_DIR=""
VERSION=""
OUT_DIR=""
RELEASE_DATE="$(date -u +%Y-%m-%d)"
SKIP_NFPM=false

usage() {
  cat >&2 <<'EOF'
Usage: package-linux-native.sh --bundle <dir> --version <X.Y.Z> --out <dir> [options]

Options:
  --bundle <dir>         Path to build/linux/x64/release/bundle
  --version <X.Y.Z>      Package version without leading "v" (e.g. 1.0.9)
  --out <dir>            Output directory for .deb, .rpm, and .tar.gz
  --app-name <name>      Artifact name prefix (default: MosaicIt)
  --release-date <date>  Release date YYYY-MM-DD for AppStream metainfo (default: today UTC)
  --skip-nfpm            Only validate metadata and build the .tar.gz archive
EOF
  exit 2
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --bundle) [[ $# -ge 2 ]] || usage; BUNDLE_DIR="$2"; shift 2 ;;
    --version) [[ $# -ge 2 ]] || usage; VERSION="$2"; shift 2 ;;
    --out) [[ $# -ge 2 ]] || usage; OUT_DIR="$2"; shift 2 ;;
    --app-name) [[ $# -ge 2 ]] || usage; APP_NAME="$2"; shift 2 ;;
    --release-date) [[ $# -ge 2 ]] || usage; RELEASE_DATE="$2"; shift 2 ;;
    --skip-nfpm) SKIP_NFPM=true; shift ;;
    -h|--help) usage ;;
    *) echo "unknown option: $1" >&2; usage ;;
  esac
done

[[ -n "$BUNDLE_DIR" && -n "$VERSION" && -n "$OUT_DIR" ]] || usage
[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || {
  echo "::error::invalid version '$VERSION' (expected X.Y.Z without leading v)" >&2
  exit 1
}
[[ "$RELEASE_DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || {
  echo "::error::invalid release date '$RELEASE_DATE' (expected YYYY-MM-DD)" >&2
  exit 1
}

BUNDLE_DIR="$(cd "$BUNDLE_DIR" && pwd)"
mkdir -p "$OUT_DIR"
OUT_DIR="$(cd "$OUT_DIR" && pwd)"

for required in \
  "$BUNDLE_DIR/$BINARY_NAME" \
  "$BUNDLE_DIR/lib/libflutter_linux_gtk.so" \
  "$BUNDLE_DIR/lib/libunseen_ffi.so" \
  "$BUNDLE_DIR/models/unseen-det-tile.onnx" \
  "$BUNDLE_DIR/models/unseen-det-tile.onnx.json" \
  "$BUNDLE_DIR/data/icudtl.dat"; do
  if [[ ! -e "$required" ]]; then
    echo "::error::missing expected bundle file: $required" >&2
    exit 1
  fi
done
if [[ ! -x "$BUNDLE_DIR/$BINARY_NAME" ]]; then
  echo "::error::bundle binary is not executable: $BUNDLE_DIR/$BINARY_NAME" >&2
  exit 1
fi

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

DESKTOP_SRC="$APP_DIR/linux/packaging/${APP_ID}.desktop"
METAINFO_SRC="$APP_DIR/linux/packaging/${APP_ID}.metainfo.xml"
ICON_SRC="$APP_DIR/assets/app_icon.png"
LICENSE_SRC="$REPO_ROOT/LICENSE"
STAGED_METAINFO="$WORK_DIR/${APP_ID}.metainfo.xml"

python3 - "$METAINFO_SRC" "$STAGED_METAINFO" "$VERSION" "$RELEASE_DATE" <<'PY'
import sys
import xml.etree.ElementTree as ET

src, dst, version, rel_date = sys.argv[1:5]
tree = ET.parse(src)
root = tree.getroot()
releases = root.find("releases")
if releases is None:
    releases = ET.SubElement(root, "releases")

existing = {el.get("version") for el in releases.findall("release")}
if version not in existing:
    rel = ET.Element("release", {"version": version, "date": rel_date, "type": "stable"})
    url = ET.SubElement(rel, "url", {"type": "details"})
    url.text = f"https://github.com/lollipopkit/mosaic_it/releases/tag/v{version}"
    releases.append(rel)

def ver_key(el: ET.Element) -> tuple[int, ...]:
    raw = (el.get("version") or "0").lstrip("v")
    return tuple(int(p) if p.isdigit() else 0 for p in raw.split("."))

sorted_rels = sorted(releases.findall("release"), key=ver_key, reverse=True)
for el in list(releases):
    releases.remove(el)
for el in sorted_rels:
    releases.append(el)

ET.indent(tree, space="  ")
tree.write(dst, encoding="utf-8", xml_declaration=True)
with open(dst, "ab") as f:
    f.write(b"\n")
PY

if command -v desktop-file-validate >/dev/null 2>&1; then
  desktop-file-validate "$DESKTOP_SRC"
fi

if command -v appstreamcli >/dev/null 2>&1; then
  appstreamcli validate --no-net "$STAGED_METAINFO"
fi

TAR_ROOT_NAME="${APP_NAME}_v${VERSION}_linux_amd64"
TAR_STAGE="$WORK_DIR/$TAR_ROOT_NAME"
mkdir -p \
  "$TAR_STAGE/bundle" \
  "$TAR_STAGE/share/applications" \
  "$TAR_STAGE/share/metainfo" \
  "$TAR_STAGE/share/icons/hicolor/512x512/apps" \
  "$TAR_STAGE/share/licenses/${APP_ID}"

cp -a "$BUNDLE_DIR/." "$TAR_STAGE/bundle/"
install -m 644 "$DESKTOP_SRC" "$TAR_STAGE/share/applications/${APP_ID}.desktop"
install -m 644 "$STAGED_METAINFO" "$TAR_STAGE/share/metainfo/${APP_ID}.metainfo.xml"
install -m 644 "$ICON_SRC" "$TAR_STAGE/share/icons/hicolor/512x512/apps/${APP_ID}.png"
install -m 644 "$LICENSE_SRC" "$TAR_STAGE/share/licenses/${APP_ID}/LICENSE"

TAR_PATH="$OUT_DIR/${TAR_ROOT_NAME}.tar.gz"
COPYFILE_DISABLE=1 tar -C "$WORK_DIR" -czf "$TAR_PATH" "$TAR_ROOT_NAME"

tar_listing="$(tar -tzf "$TAR_PATH")"
for entry in \
  "${TAR_ROOT_NAME}/bundle/${BINARY_NAME}" \
  "${TAR_ROOT_NAME}/bundle/models/unseen-det-tile.onnx" \
  "${TAR_ROOT_NAME}/share/applications/${APP_ID}.desktop" \
  "${TAR_ROOT_NAME}/share/metainfo/${APP_ID}.metainfo.xml" \
  "${TAR_ROOT_NAME}/share/icons/hicolor/512x512/apps/${APP_ID}.png" \
  "${TAR_ROOT_NAME}/share/licenses/${APP_ID}/LICENSE"; do
  grep -Fxq "$entry" <<< "$tar_listing" || {
    echo "::error::tarball missing expected entry: $entry" >&2
    exit 1
  }
done

if [[ "$SKIP_NFPM" == true ]]; then
  echo "created: $TAR_PATH"
  exit 0
fi

command -v nfpm >/dev/null 2>&1 || {
  echo "::error::nfpm not found in PATH" >&2
  exit 1
}

DEB_PATH="$OUT_DIR/${APP_NAME}_v${VERSION}_amd64.deb"
RPM_PATH="$OUT_DIR/${APP_NAME}_v${VERSION}_x86_64.rpm"
RENDERED_NFPM="$WORK_DIR/nfpm.yaml"

python3 - "$APP_DIR/linux/packaging/nfpm.yaml" "$RENDERED_NFPM" "$VERSION" "$BUNDLE_DIR" "$STAGED_METAINFO" "$BINARY_NAME" <<'PY'
import json
import sys

src, dst, version, bundle_dir, metainfo, binary_name = sys.argv[1:7]
with open(src, encoding="utf-8") as f:
    content = f.read()

replacements = {
    '"${VERSION}"': json.dumps(version),
    '"${BUNDLE_DIR}/"': json.dumps(bundle_dir.rstrip("/") + "/"),
    '"${METAINFO_FILE}"': json.dumps(metainfo),
    '"/opt/mosaicit/${BINARY_NAME}"': json.dumps(f"/opt/mosaicit/{binary_name}"),
}
for placeholder, value in replacements.items():
    if placeholder not in content:
        sys.exit(f"missing placeholder {placeholder} in {src}")
    content = content.replace(placeholder, value)

with open(dst, "w", encoding="utf-8") as f:
    f.write(content)
PY

(
  cd "$REPO_ROOT"
  nfpm package --config "$RENDERED_NFPM" --packager deb --target "$DEB_PATH"
  nfpm package --config "$RENDERED_NFPM" --packager rpm --target "$RPM_PATH"
)

if command -v dpkg-deb >/dev/null 2>&1; then
  deb_contents="$(dpkg-deb --contents "$DEB_PATH")"
  for required_path in \
    "./opt/mosaicit/${BINARY_NAME}" \
    "./opt/mosaicit/models/unseen-det-tile.onnx" \
    "./usr/bin/mosaicit" \
    "./usr/share/applications/${APP_ID}.desktop" \
    "./usr/share/metainfo/${APP_ID}.metainfo.xml" \
    "./usr/share/icons/hicolor/512x512/apps/${APP_ID}.png"; do
    grep -Fq "$required_path" <<< "$deb_contents" || {
      echo "::error::deb missing expected path: $required_path" >&2
      exit 1
    }
  done
fi

echo "created:"
ls -lh "$TAR_PATH" "$DEB_PATH" "$RPM_PATH"
