#!/usr/bin/env bash
# Renders screens.html to 1320x2868 PNGs and adds them to a booted simulator's Photos.
# Usage: render.sh [out_dir] [device]   (device defaults to "booted"; "-" skips import)
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
out=${1:-$here/out}
dev=${2:-booted}
chrome=${CHROME:-"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"}
mkdir -p "$out"
base_url=$(python3 -c 'import pathlib, sys; print(pathlib.Path(sys.argv[1]).resolve().as_uri())' "$here/screens.html")
generated=()
for l in en zh; do
  for s in chat bank parcel boarding mail; do
    file="$out/$l-$s.png"
    "$chrome" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=3 \
      --window-size=440,956 --screenshot="$file" "$base_url?s=$s&l=$l" 2>/dev/null
    generated+=("$file")
  done
done
[[ $dev == - ]] || xcrun simctl addmedia "$dev" "${generated[@]}"
