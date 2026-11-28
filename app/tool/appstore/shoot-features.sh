#!/usr/bin/env bash
# Takes additional feature-specific screenshots for the website tour:
#   6-batch:     Regions sheet switched to "All 5 images"
#   7-export:    Single-image Export sheet (Copy image, Share, Save to Photos)
#   8-selfcheck: Real Export self-check sheet triggered with unmasked regions
# Usage: shoot-features.sh <udid> <name> [screen]
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
app=$(cd "$here/../.." && pwd)
dev=$1 name=$2 screen=${3:-portrait}
id=com.lollipopkit.unseen

[[ -f $here/out/en-chat.png ]] || "$here/render.sh" "$here/out" -
xcrun simctl boot "$dev" 2>/dev/null || true
xcrun simctl install "$dev" "$app/build/ios/iphonesimulator/Runner.app"
xcrun simctl status_bar "$dev" override --time 9:41 --batteryState charged \
  --batteryLevel 100 --cellularBars 4 --wifiBars 3
xcrun simctl ui "$dev" appearance light

label() { python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))[sys.argv[2]])' \
  "$app/lib/l10n/app_$1.arb" "$2"; }

wait_for() {
  for _ in $(seq 120); do
    axe describe-ui --udid "$dev" 2>/dev/null | grep -qF "$1" && return
    sleep 0.5
  done
  echo "timed out waiting for $1" >&2
  return 1
}

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

for l in en zh; do
  lang=$([[ $l == zh ]] && echo zh-Hans || echo en)
  loc=$([[ $l == zh ]] && echo zh_CN || echo en_US)
  mkdir -p "$here/out/shots/$l"
  out=$here/out/shots/$l/$name$([[ $screen == portrait ]] || echo "-$screen")

  # 1) 6-batch: 5 images -> Regions -> All 5 images
  rm -rf "$container/tmp/launch_files"
  mkdir -p "$container/tmp/launch_files"
  cp "$here/out/$l"-*.png "$container/tmp/launch_files/"
  xcrun simctl launch --terminate-running-process "$dev" $id \
    -AppleLanguages "($lang)" -AppleLocale "$loc" >/dev/null
  if axe tap --label Done --wait-timeout 4 --udid "$dev" >/dev/null 2>&1; then :; fi
  wait_for "$l-chat.png"
  posture "$screen"
  sleep 1.5
  axe tap --agent --label-contains "$l-bank.png" --udid "$dev" >/dev/null; sleep 1
  axe tap --label "$(label "$l" regionsTooltip)" --udid "$dev" >/dev/null; sleep 1
  all_lbl=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["allImagesCount"].replace("{count}", "5"))' "$app/lib/l10n/app_$l.arb")
  axe tap --label "$all_lbl" --udid "$dev" >/dev/null; sleep 1.2
  shot 6-batch

  # 2) 7-export & 8-selfcheck: single image so Copy image + Share + Save to Photos all appear
  rm -rf "$container/tmp/launch_files"
  mkdir -p "$container/tmp/launch_files"
  cp "$here/out/$l-chat.png" "$container/tmp/launch_files/"
  xcrun simctl launch --terminate-running-process "$dev" $id \
    -AppleLanguages "($lang)" -AppleLocale "$loc" >/dev/null
  if axe tap --label Done --wait-timeout 4 --udid "$dev" >/dev/null 2>&1; then :; fi
  wait_for "$(label "$l" export)"
  # Wait for detection to finish so Export is enabled
  for _ in $(seq 60); do
    axe describe-ui --udid "$dev" 2>/dev/null | grep -qF "$(label "$l" peekOriginal)" && break
    sleep 0.5
  done
  sleep 2
  posture "$screen"
  sleep 1.5

  # 7-export: open Export sheet
  axe tap --label "$(label "$l" export)" --udid "$dev" >/dev/null; sleep 1.5
  shot 7-export
  dismiss

  # 8-selfcheck: deselect all regions -> Export -> Copy image -> Export self-check pops up
  axe tap --label "$(label "$l" regionsTooltip)" --udid "$dev" >/dev/null; sleep 1.2
  axe tap --label "$(label "$l" selectNone)" --udid "$dev" >/dev/null; sleep 1
  dismiss
  axe tap --label "$(label "$l" export)" --udid "$dev" >/dev/null; sleep 1.2
  axe tap --label "$(label "$l" copyImage)" --udid "$dev" >/dev/null
  wait_for "$(label "$l" exportAnyway)"
  sleep 1.2
  shot 8-selfcheck
done
