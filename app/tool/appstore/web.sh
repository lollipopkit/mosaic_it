#!/usr/bin/env bash
# Copies the screenshots the website and the READMEs show from shoot.sh's
# output to website/public/screenshots/<locale>/ as WebP. Needs uv.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
dst=$here/../../../website/public/screenshots
parent=$(dirname "$dst")
mkdir -p "$parent"
tmp=$(mktemp -d "$parent/.screenshots.tmp.XXXXXX")
trap 'rm -rf "$tmp"' EXIT
uv run -q --with pillow python -I - "$here/out/shots" "$tmp" <<'EOF'
import pathlib, sys
from PIL import Image

src, dst = map(pathlib.Path, sys.argv[1:])
devices = ('iphone18pro', 'iphoneduo-inner-landscape')
scenes = ('1-chat', '2-bank', '3-regions', '4-fill', '5-mail')
for locale in ('en', 'zh'):
    (dst / locale).mkdir(parents=True)
    for device in devices:
        for scene in scenes:
            name = f'{device}-{scene}'
            im = Image.open(src / locale / f'{name}.png').convert('RGB')
            im.thumbnail((1200, 1200))
            im.save(dst / locale / f'{name}.webp', 'WEBP', quality=80, method=6)
EOF
chmod 755 "$tmp"
rm -rf "$dst"
mv "$tmp" "$dst"
du -sh "$dst"
count=$(find "$dst" -type f -name '*.webp' | wc -l | tr -d ' ')
echo "Exported $count WebP screenshots"
