#!/usr/bin/env bash
# Copies the screenshots the website and the READMEs show from shoot.sh's
# output to website/public/screenshots/<locale>/ as WebP. Needs uv.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
dst=$here/../../../website/public/screenshots
tmp=$(mktemp -d "${TMPDIR:-/tmp}/mosaic-web-shots.XXXXXX")
trap 'rm -rf "$tmp"' EXIT
uv run -q --with pillow python -I - "$here/out/shots" "$tmp" <<'EOF'
import pathlib, sys
from PIL import Image
src, dst = map(pathlib.Path, sys.argv[1:])
shown = [
    'iphone18pro-1-chat', 'iphone18pro-4-fill', 'iphone18pro-3-regions',
    'iphoneduo-inner-landscape-1-chat', 'iphoneduo-outer-portrait-2-bank',
]
for locale in ('en', 'zh'):
    (dst / locale).mkdir(parents=True)
    for name in shown:
        im = Image.open(src / locale / f'{name}.png').convert('RGB')
        im.thumbnail((1200, 1200))
        im.save(dst / locale / f'{name}.webp', 'WEBP', quality=80, method=6)
EOF
rm -rf "$dst"
mv "$tmp" "$dst"
du -sh "$dst"
