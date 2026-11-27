#!/usr/bin/env bash
# Runs a command with the Android release keystore from 1Password (`Dev/unseen-android-keystore`):
# writes the keystore to a temporary file in $UNSEEN_KEYSTORE (cleaned up on exit/signal),
# reads UNSEEN_KEY_ALIAS, and injects UNSEEN_KEYSTORE_PASSWORD and UNSEEN_KEY_PASSWORD via `op run`.
#
#   tool/android-signing.sh flutter build apk --release
set -euo pipefail

[ "$#" -gt 0 ] || { echo "usage: $0 <command> [args...]" >&2; exit 2; }

item="op://Dev/unseen-android-keystore"
umask 077
dir="$(mktemp -d)"
cleanup() { rm -rf -- "${dir:?}"; }
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
trap 'exit 129' HUP

op read --out-file "$dir/unseen.p12" --file-mode 0600 "$item/keystore" >/dev/null
[ -s "$dir/unseen.p12" ] || { echo "failed to read Android keystore from 1Password" >&2; exit 1; }

export UNSEEN_KEYSTORE="$dir/unseen.p12"
export UNSEEN_KEY_ALIAS="$(op read --no-newline "$item/alias")"
export UNSEEN_KEYSTORE_PASSWORD="$item/password"
export UNSEEN_KEY_PASSWORD="$item/keyPassword"
export GRADLE_OPTS="${GRADLE_OPTS:+$GRADLE_OPTS }-Dorg.gradle.daemon=false"
op run -- "$@"
