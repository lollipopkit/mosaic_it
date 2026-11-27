#!/usr/bin/env bash
# Package a built Flutter Linux release bundle into an AppImage using pinned
# appimagetool (1.9.1) and type2-runtime (20251108), both SHA256-verified.
#
# Usage:
#   app/tool/package-linux-appimage.sh \
#     --bundle app/build/linux/x64/release/bundle \
#     --output dist/MosaicIt_v1.0.9_amd64.AppImage
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

APP_ID="com.lollipopkit.unseen"
BINARY_NAME="mosaicit"
BUNDLE_DIR=""
OUTPUT=""
CACHE_DIR="${RUNNER_TEMP:-${XDG_CACHE_HOME:-$HOME/.cache}}/appimage-tools"

APPIMAGETOOL_VERSION="1.9.1"
APPIMAGETOOL_URL="https://github.com/AppImage/appimagetool/releases/download/${APPIMAGETOOL_VERSION}/appimagetool-x86_64.AppImage"
APPIMAGETOOL_SHA256="ed4ce84f0d9caff66f50bcca6ff6f35aae54ce8135408b3fa33abfc3cb384eb0"

RUNTIME_VERSION="20251108"
RUNTIME_URL="https://github.com/AppImage/type2-runtime/releases/download/${RUNTIME_VERSION}/runtime-x86_64"
RUNTIME_SHA256="2fca8b443c92510f1483a883f60061ad09b46b978b2631c807cd873a47ec260d"

usage() {
  cat >&2 <<'EOF'
Usage: package-linux-appimage.sh --bundle <dir> --output <file.AppImage>
EOF
  exit 2
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --bundle) [[ $# -ge 2 ]] || usage; BUNDLE_DIR="$2"; shift 2 ;;
    --output) [[ $# -ge 2 ]] || usage; OUTPUT="$2"; shift 2 ;;
    -h|--help) usage ;;
    *) echo "unknown option: $1" >&2; usage ;;
  esac
done

[[ -n "$BUNDLE_DIR" && -n "$OUTPUT" ]] || usage
if [[ "$(uname -s)" != "Linux" || "$(uname -m)" != "x86_64" ]]; then
  echo "::error::package-linux-appimage.sh targets Linux x86_64 (found $(uname -s) $(uname -m))" >&2
  exit 1
fi

BUNDLE_DIR="$(cd "$BUNDLE_DIR" && pwd)"
mkdir -p "$(dirname "$OUTPUT")" "$CACHE_DIR"
OUTPUT="$(cd "$(dirname "$OUTPUT")" && pwd)/$(basename "$OUTPUT")"

for required in \
  "$BUNDLE_DIR/$BINARY_NAME" \
  "$BUNDLE_DIR/lib/libflutter_linux_gtk.so" \
  "$BUNDLE_DIR/lib/libunseen_ffi.so" \
  "$BUNDLE_DIR/models/unseen-det-tile.onnx" \
  "$BUNDLE_DIR/models/unseen-det-tile.onnx.json" \
  "$BUNDLE_DIR/data/icudtl.dat"; do
  [[ -e "$required" ]] || { echo "::error::missing expected bundle file: $required" >&2; exit 1; }
done
if [[ ! -x "$BUNDLE_DIR/$BINARY_NAME" ]]; then
  echo "::error::bundle binary is not executable: $BUNDLE_DIR/$BINARY_NAME" >&2
  exit 1
fi

tool="$CACHE_DIR/appimagetool-${APPIMAGETOOL_VERSION}-x86_64.AppImage"
if [[ ! -x "$tool" ]]; then
  curl -fsSL -o "$tool.tmp" "$APPIMAGETOOL_URL"
  echo "${APPIMAGETOOL_SHA256}  $tool.tmp" | sha256sum -c -
  chmod 755 "$tool.tmp"
  mv "$tool.tmp" "$tool"
else
  echo "${APPIMAGETOOL_SHA256}  $tool" | sha256sum -c -
fi

runtime="$CACHE_DIR/runtime-${RUNTIME_VERSION}-x86_64"
if [[ ! -f "$runtime" ]]; then
  curl -fsSL -o "$runtime.tmp" "$RUNTIME_URL"
  echo "${RUNTIME_SHA256}  $runtime.tmp" | sha256sum -c -
  mv "$runtime.tmp" "$runtime"
else
  echo "${RUNTIME_SHA256}  $runtime" | sha256sum -c -
fi

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
appdir="$work/MosaicIt.AppDir"
mkdir -p "$appdir/bundle"

cp -a "$BUNDLE_DIR/." "$appdir/bundle/"
install -m 644 "$APP_DIR/linux/packaging/${APP_ID}.desktop" "$appdir/${APP_ID}.desktop"
install -m 644 "$APP_DIR/assets/app_icon.png" "$appdir/${APP_ID}.png"
ln -s "${APP_ID}.png" "$appdir/.DirIcon"

cat > "$appdir/AppRun" <<EOF
#!/bin/sh
HERE="\$(dirname "\$(readlink -f "\$0")")"
exec "\$HERE/bundle/${BINARY_NAME}" "\$@"
EOF
chmod 755 "$appdir/AppRun"

APPIMAGE_EXTRACT_AND_RUN=1 ARCH=x86_64 \
  "$tool" --runtime-file "$runtime" "$appdir" "$OUTPUT"
chmod 755 "$OUTPUT"
echo "created: $OUTPUT"
ls -lh "$OUTPUT"
