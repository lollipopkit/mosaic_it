#!/usr/bin/env bash
# Runs the real `unseen` CLI against the fake chat screenshot and renders its
# actual terminal output to a 1200x844 PNG for the website's CLI feature tour.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
repo=$(cd "$here/../../.." && pwd)
bin=${UNSEEN_BIN:-$repo/target/release/unseen}
model=${UNSEEN_MODEL:-$repo/app/build/macos/Build/Products/Release/MosaicIt.app/Contents/Resources/models/unseen-det-tile.onnx}
chrome=${CHROME:-"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"}
out="$here/out/shots/cli.png"
mkdir -p "$(dirname "$out")"

tmp=$(mktemp -d "${TMPDIR:-/tmp}/unseen-cli-shot.XXXXXX")
trap 'rm -rf "$tmp"' EXIT

# Copy model + sidecar + fake screenshot into temp workdir so paths stay clean.
ln -s "$repo/models" "$tmp/models"
ln -s "$model" "$tmp/unseen-det-tile.onnx"
ln -s "$model.json" "$tmp/unseen-det-tile.onnx.json"
cp "$here/out/en-chat.png" "$tmp/chat.png"

verify_out=$(cd "$tmp" && "$bin" models verify unseen-det-tile.onnx 2>&1)
detect_err=$(mktemp "$tmp/detect.err.XXXXXX")
detect_json=$(cd "$tmp" && "$bin" detect --model unseen-det-tile.onnx chat.png 2>"$detect_err")
detect_summary=$(cat "$detect_err")
redact_out=$(cd "$tmp" && "$bin" redact --model unseen-det-tile.onnx --style noise chat.png chat-redacted.png 2>&1)

python3 - "$verify_out" "$detect_summary" "$detect_json" "$redact_out" "$tmp/term.html" <<'PY'
import html, json, pathlib, sys

verify_out, detect_summary, detect_json, redact_out, html_path = sys.argv[1:]
dets = json.loads(detect_json)[:3]
formatted = []
for d in dets:
    bbox = [round(v, 1) for v in d["bbox"]]
    formatted.append(
        '  { '
        f'<span class="k">"class"</span>: <span class="s">"{html.escape(d["class"])}"</span>, '
        f'<span class="k">"score"</span>: <span class="n">{d["score"]:.3f}</span>, '
        f'<span class="k">"bbox"</span>: <span class="n">{bbox}</span>, '
        f'<span class="k">"selection"</span>: <span class="s">"{html.escape(d["selection"])}"</span>'
        ' }'
    )
json_block = "[\n" + ",\n".join(formatted) + ",\n  <span class=\"dim\">...</span>\n]"

doc = f"""<!doctype html>
<html><head><meta charset="utf-8"><style>
* {{ box-sizing: border-box; margin: 0; padding: 0; }}
body {{
  width: 1200px; height: 844px; overflow: hidden;
  background: #141013;
  color: #f4eef2;
  font-family: 'JetBrains Mono', 'SF Mono', Menlo, monospace;
  display: flex; flex-direction: column;
}}
.bar {{
  height: 52px; padding: 0 22px;
  background: #1c161b; border-bottom: 1px solid #2c232a;
  display: flex; align-items: center; gap: 10px;
}}
.dot {{ width: 13px; height: 13px; border-radius: 50%; }}
.r {{ background: #ff5f57; }} .y {{ background: #febc2e; }} .g {{ background: #28c840; }}
.title {{
  margin-left: auto; margin-right: auto; padding-right: 54px;
  font-size: 15px; color: #9c9099; letter-spacing: 0.02em;
}}
pre {{
  flex: 1; padding: 36px 34px;
  font-size: 16.5px; line-height: 1.72;
  white-space: pre-wrap; word-break: break-word;
}}
.p {{ color: #e8609c; font-weight: 700; }}
.cmd {{ color: #ffffff; font-weight: 600; }}
.flag {{ color: #c7b8c3; }}
.ok {{ color: #4ade80; }}
.meta {{ color: #a89da5; }}
.k {{ color: #f472b6; }}
.s {{ color: #93c5fd; }}
.n {{ color: #fcd34d; }}
.dim {{ color: #766c74; }}
</style></head><body>
<div class="bar">
  <span class="dot r"></span><span class="dot y"></span><span class="dot g"></span>
  <span class="title">unseen — zsh</span>
</div>
<pre><span class="p">$</span> <span class="cmd">unseen models verify</span> <span class="flag">unseen-det-tile.onnx</span>
<span class="ok">{html.escape(verify_out.strip())}</span>

<span class="p">$</span> <span class="cmd">unseen detect</span> <span class="flag">--model unseen-det-tile.onnx chat.png</span>
<span class="meta">{html.escape(detect_summary.strip())}</span>
{json_block}

<span class="p">$</span> <span class="cmd">unseen redact</span> <span class="flag">--model unseen-det-tile.onnx --style noise chat.png chat-redacted.png</span>
<span class="ok">{html.escape(redact_out.strip())}</span></pre>
</body></html>
"""
pathlib.Path(html_path).write_text(doc)
PY

url=$(python3 -c 'import pathlib,sys; print(pathlib.Path(sys.argv[1]).resolve().as_uri())' "$tmp/term.html")
"$chrome" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=2 \
  --window-size=1200,844 --screenshot="$out" "$url" 2>/dev/null
ls -lh "$out"
