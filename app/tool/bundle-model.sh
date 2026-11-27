#!/usr/bin/env bash
# Stages the pinned detector model and its .json sidecar for <variant> (`tiled`
# or `litert`) from models/manifest.toml into <dest_dir> during app builds so
# the compiled app runs 100% offline without committing binary weights to git.
#
# Usage:
#   app/tool/bundle-model.sh <tiled|litert> <dest_dir>
#
# Resolution order (offline-first):
#   1. $UNSEEN_MODEL_DIR/<file> (and .json) if set and hash-verified
#   2. Cached download in app/.dart_tool/unseen-models/<version>/
#   3. Download from the manifest's `url` (build-time only; verified by BLAKE3)
set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:${HOME}/.cargo/bin:${PATH}"

variant=${1:?usage: bundle-model.sh <tiled|litert> <dest_dir>}
dest=${2:?usage: bundle-model.sh <tiled|litert> <dest_dir>}

app_dir=$(cd -- "$(dirname "$0")/.." && pwd)
repo_dir=$(cd -- "$app_dir/.." && pwd)
manifest="$repo_dir/models/manifest.toml"
cache_root="$app_dir/.dart_tool/unseen-models"

# Pick the highest SemVer published entry in MIN_FORMAT..=FORMAT (2..=3) for <variant>.
entry=$(awk -v want="$variant" '
  /^\[\[model\]\]/ { flush(); next }
  /^version[[:space:]]*=/        { v = unquote($0) }
  /^variant[[:space:]]*=/        { var = unquote($0) }
  /^file[[:space:]]*=/           { f = unquote($0) }
  /^blake3[[:space:]]*=/         { b3 = unquote($0) }
  /^sidecar_blake3[[:space:]]*=/ { sb3 = unquote($0) }
  /^url[[:space:]]*=/            { u = unquote($0) }
  /^format[[:space:]]*=/         { fmt = $0; sub(/^[^=]*=[[:space:]]*/, "", fmt); sub(/[[:space:]]*$/, "", fmt) }
  END { flush(); if (best != "") print best }
  function unquote(s) { sub(/^[^"]*"/, "", s); sub(/".*$/, "", s); return s }
  function newer(a, b,    pa, pb, i) {
    if (b == "") return 1
    split(a, pa, "."); split(b, pb, ".")
    for (i = 1; i <= 3; i++) {
      if (pa[i] + 0 > pb[i] + 0) return 1
      if (pa[i] + 0 < pb[i] + 0) return 0
    }
    return 0
  }
  function flush() {
    if (fmt == "") fmt = 1
    if (var == want && u != "" && fmt + 0 >= 2 && fmt + 0 <= 3 && newer(v, best_v)) {
      best_v = v
      best = v "\t" f "\t" b3 "\t" sb3 "\t" u
    }
    v = var = f = b3 = sb3 = u = fmt = ""
  }
' "$manifest")
[ -n "$entry" ] || { echo "bundle-model: no runnable $variant release in $manifest" >&2; exit 1; }
IFS=$'\t' read -r version file blake3 sidecar_blake3 url <<< "$entry"

stamp_content=$(printf '%s\n%s\n%s\n%s\n' "$version" "$file" "$blake3" "$sidecar_blake3")

hash_of() {
  local p=$1
  if command -v b3sum >/dev/null 2>&1; then
    b3sum --no-names "$p"
  elif command -v python3 >/dev/null 2>&1 && python3 -c "import blake3" 2>/dev/null; then
    python3 -c "import blake3, pathlib, sys; print(blake3.blake3(pathlib.Path(sys.argv[1]).read_bytes()).hexdigest())" "$p"
  else
    return 1
  fi
}

verify_pair() {
  local m=$1
  [ -f "$m" ] && [ -f "$m.json" ] || return 1
  local got_m got_s
  if got_m=$(hash_of "$m") && got_s=$(hash_of "$m.json"); then
    [ "$got_m" = "$blake3" ] && [ "$got_s" = "$sidecar_blake3" ]
    return $?
  fi
  # Fallback to unseen-cli verify, requiring exact version and variant match.
  local cli="$repo_dir/target/release/unseen" out
  if [ -x "$cli" ]; then
    out=$("$cli" models verify --manifest "$manifest" "$m" 2>&1) || return 1
  else
    out=$(cargo run --manifest-path "$repo_dir/Cargo.toml" -q --release -p unseen-cli -- \
      models verify --manifest "$manifest" "$m" 2>&1) || return 1
  fi
  grep -qF "(unseen-det $version $variant)" <<< "$out"
}

tmp_dir=""
cleanup() {
  if [ -n "$tmp_dir" ]; then
    rm -rf "$tmp_dir"
  fi
}
trap cleanup EXIT

mkdir -p "$dest"
if [ -f "$dest/bundled.stamp" ] && [ "$(cat "$dest/bundled.stamp")" = "$stamp_content" ] && verify_pair "$dest/$file"; then
  exit 0
fi

src_model=""
if [ -n "${UNSEEN_MODEL_DIR:-}" ] && verify_pair "$UNSEEN_MODEL_DIR/$file"; then
  src_model="$UNSEEN_MODEL_DIR/$file"
else
  cache_dir="$cache_root/$version"
  mkdir -p "$cache_dir"
  if ! verify_pair "$cache_dir/$file"; then
    tmp_dir=$(mktemp -d "$cache_dir/.dl.XXXXXX")
    base="${url%/}"
    echo "bundle-model: downloading unseen-det $version ($variant) from $base" >&2
    curl -fsSL "$base/$file" -o "$tmp_dir/$file"
    curl -fsSL "$base/$file.json" -o "$tmp_dir/$file.json"
    verify_pair "$tmp_dir/$file" || {
      echo "bundle-model: BLAKE3 mismatch for $version ($variant)" >&2
      exit 1
    }
    mv -f "$tmp_dir/$file" "$cache_dir/$file"
    mv -f "$tmp_dir/$file.json" "$cache_dir/$file.json"
    rm -rf "$tmp_dir"
    tmp_dir=""
  fi
  src_model="$cache_dir/$file"
fi

# Stage atomically into dest and write bundled.stamp last.
rm -f "$dest/bundled.stamp" "$dest"/*.onnx "$dest"/*.onnx.json "$dest"/*.tflite "$dest"/*.tflite.json
tmp_dir=$(mktemp -d "$dest/.stage.XXXXXX")
cp "$src_model" "$tmp_dir/$file"
cp "$src_model.json" "$tmp_dir/$file.json"
printf '%s\n' "$stamp_content" > "$tmp_dir/bundled.stamp"
mv -f "$tmp_dir/$file" "$dest/$file"
mv -f "$tmp_dir/$file.json" "$dest/$file.json"
mv -f "$tmp_dir/bundled.stamp" "$dest/bundled.stamp"
rm -rf "$tmp_dir"
tmp_dir=""
echo "bundle-model: staged $version ($variant) -> $dest/$file" >&2
