#!/usr/bin/env bash
# Copies the screenshots the website and the READMEs show from shoot.sh,
# shoot-features.sh, and render-cli.sh into website/public/screenshots/ as WebP.
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
scenes = ('1-chat', '2-bank', '4-fill', '6-batch', '7-export', '8-selfcheck')
for locale in ('en', 'zh'):
    (dst / locale).mkdir(parents=True)
    for device in devices:
        for scene in scenes:
            name = f'{device}-{scene}'
            im = Image.open(src / locale / f'{name}.png').convert('RGB')
            im.thumbnail((1200, 1200))
            im.save(dst / locale / f'{name}.webp', 'WEBP', quality=80, method=6)

cli = Image.open(src / 'cli.png').convert('RGB')
cli.thumbnail((1200, 1200))
cli.save(dst / 'cli.webp', 'WEBP', quality=85, method=6)
EOF
chmod 755 "$tmp"
rm -rf "$dst"
mv "$tmp" "$dst"
du -sh "$dst"
count=$(find "$dst" -type f -name '*.webp' | wc -l | tr -d ' ')
echo "Exported $count WebP screenshots"
