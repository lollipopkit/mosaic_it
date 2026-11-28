#!/usr/bin/env bash
# Takes store/website screenshots of the debug app with the fake images from
# render.sh. Needs axe (brew install cameroncooke/axe/axe) and a debug build:
#   flutter build ios --simulator --debug --dart-define=SCREENSHOTS=true
# Usage: shoot.sh <udid> <name> [screen...]
#   screen: [inner-|outer-]portrait|landscape, default portrait. inner/outer
#   pick the iPhone Duo's screen; only the Duo and real devices rotate.
# Output: out/shots/<locale>/<name>[-<screen>]-<n>-<scene>.png
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
app=$(cd "$here/../.." && pwd)
dev=$1 name=$2
shift 2
screens=("${@:-portrait}")
id=com.lollipopkit.unseen

[[ -f $here/out/en-chat.png ]] || "$here/render.sh" "$here/out" -
xcrun simctl boot "$dev" 2>/dev/null || true
xcrun simctl install "$dev" "$app/build/ios/iphonesimulator/Runner.app"
xcrun simctl status_bar "$dev" override --time 9:41 --batteryState charged \
  --batteryLevel 100 --cellularBars 4 --wifiBars 3
xcrun simctl ui "$dev" appearance light

label() { python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))[sys.argv[2]])' \
  "$app/lib/l10n/app_$1.arb" "$2"; }

# Waits until an element with this label is on screen.
wait_for() {
  for _ in $(seq 120); do
    axe describe-ui --udid "$dev" 2>/dev/null | grep -qF "$1" && return
    sleep 0.5
  done
  echo "timed out waiting for $1" >&2
  return 1
}

# Moves the Duo hinge and rotates until the active screen has the orientation.
posture() {
  case $1 in
    inner-*) axe hinge set 180 --udid "$dev" >/dev/null ;;
    outer-*) axe hinge set closed --udid "$dev" >/dev/null ;;
  esac
  for _ in 1 2 3 4; do
    axe displays --udid "$dev" | grep -q "Active.*${1##*-}" && return
    axe rotate right --udid "$dev" >/dev/null 2>&1 || sleep 1
  done
  echo "cannot reach $1" >&2
  return 1
}

# Thumbnails are labelled with the file name and their box count; scroll the
# strip if the target thumbnail is off-screen (e.g. short landscape screens).
thumb() {
  local target="$l-$1.png"
  for _ in 1 2 3 4; do
    axe tap --agent --label-contains "$target" --udid "$dev" >/dev/null 2>&1 && return
    local coords
    coords=$(axe describe-ui --udid "$dev" 2>/dev/null | python3 -c '
import json, sys
def find(n):
    if isinstance(n, dict):
        lbl = n.get("AXLabel") or ""
        f = n.get("frame")
        if ".png" in lbl and isinstance(f, dict):
            yield f
        for v in n.values(): yield from find(v)
    elif isinstance(n, list):
        for v in n: yield from find(v)
frames = list(find(json.load(sys.stdin)))
if not frames: sys.exit(0)
x0 = min(f["x"] for f in frames); x1 = max(f["x"] + f["width"] for f in frames)
y0 = min(f["y"] for f in frames); y1 = max(f["y"] + f["height"] for f in frames)
if x1 - x0 > y1 - y0:
    cy = round((y0 + y1) / 2)
    print(round(x1 - 20), cy, round(x0 + 20), cy)
else:
    cx = round((x0 + x1) / 2)
    print(cx, round(y1 - 20), cx, round(y0 + 20))
')
    [[ -n $coords ]] || break
    read -r sx sy ex ey <<< "$coords"
    axe swipe --start-x "$sx" --start-y "$sy" --end-x "$ex" --end-y "$ey" \
      --duration 0.3 --udid "$dev" >/dev/null 2>&1 || true
    sleep 0.6
  done
  axe tap --agent --label-contains "$target" --udid "$dev" >/dev/null
}
# Opens the fill sheet and picks a style; the sheet stays open.
fill() {
  axe tap --label "$(label "$l" fillStyle)" --udid "$dev" >/dev/null; sleep 1
  axe tap --label "$(label "$l" "$1")" --udid "$dev" >/dev/null; sleep 1.5
}
shot() { axe screenshot --udid "$dev" --output "$out-$1.png" >/dev/null 2>&1; }
dismiss() { axe tap -x 200 -y 60 --udid "$dev" >/dev/null 2>&1; sleep 1; }

container=$(xcrun simctl get_app_container "$dev" $id data)
cleanup() {
  if [[ -n ${container:-} ]]; then
    rm -rf "$container/tmp/launch_files"
  fi
  xcrun simctl status_bar "$dev" clear >/dev/null 2>&1 || true
}
trap cleanup EXIT
for screen in "${screens[@]}"; do
  for l in en zh; do
    lang=$([[ $l == zh ]] && echo zh-Hans || echo en)
    mkdir -p "$here/out/shots/$l"
    out=$here/out/shots/$l/$name$([[ $screen == portrait ]] || echo "-$screen")
    rm -rf "$container/tmp/launch_files"
    mkdir -p "$container/tmp/launch_files"
    cp "$here/out/$l"-*.png "$container/tmp/launch_files/"
    xcrun simctl launch --terminate-running-process "$dev" $id \
      -AppleLanguages "($lang)" -AppleLocale "$([[ $l == zh ]] && echo zh_CN || echo en_US)" >/dev/null
    # First launch shows the intro.
    if axe tap --label Done --wait-timeout 4 --udid "$dev" >/dev/null 2>&1; then :; fi
    wait_for "$l-chat.png"
    posture "$screen"
    sleep 2
    thumb chat >/dev/null; sleep 1.5; shot 1-chat
    thumb bank >/dev/null; sleep 1.5; shot 2-bank
    thumb boarding >/dev/null; sleep 1.5
    axe tap --label "$(label "$l" regionsTooltip)" --udid "$dev" >/dev/null; sleep 1.5; shot 3-regions
    dismiss
    thumb parcel >/dev/null; sleep 1.5
    fill fillNoise; shot 4-fill
    dismiss
    thumb mail >/dev/null; sleep 1.5; shot 5-mail
    fill fillSolid
    dismiss
  done
done
