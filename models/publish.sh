#!/usr/bin/env bash
# Publishes a release for the app to download: its tiled model and sidecar to
# the entry's `url`, then models/manifest.toml, signed, as `manifest.signed`.
#   op run --env-file models/publish.env -- models/publish.sh <version> <dir with unseen-det-tile.onnx and its .json>
# Model weights and manifests live under models/<project>/ of the bucket
# `public` (https://pub.lolli.tech); nothing private goes there.
set -euo pipefail
cd "$(dirname "$0")/.."
version=${1:?usage: models/publish.sh <version> <model dir>}
src=${2:?usage: models/publish.sh <version> <model dir>}
: "${CLOUDFLARE_API_TOKEN:?}" "${CLOUDFLARE_ACCOUNT_ID:?}" "${UNSEEN_MANIFEST_KEY:?}"
f=unseen-det-tile.onnx
base=https://pub.lolli.tech/models/unseen
unseen() { cargo run -q --release -p unseen-cli -- "$@"; }

# The files are the listed release, and the manifest sends apps to this path.
unseen models verify "$src/$f" 2>&1 | grep -qF "(unseen-det $version tiled)" ||
  { echo "$src/$f is not unseen-det $version" >&2; exit 1; }
grep -qxF "url = \"$base/$version\"" models/manifest.toml ||
  { echo "manifest.toml has no entry with url $base/$version" >&2; exit 1; }
# Every app installs what this file lists.
git diff --quiet HEAD -- models/manifest.toml ||
  { echo "commit models/manifest.toml first" >&2; exit 1; }

# put <key> <file> <cache-control>; the token goes through stdin, not argv.
put() {
  printf 'header = "Authorization: Bearer %s"\n' "$CLOUDFLARE_API_TOKEN" |
    curl -fsS -K - -o /dev/null -X PUT -H "Cache-Control: $3" -H "Content-Type: application/octet-stream" --data-binary "@$2" \
      "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/r2/buckets/public/objects/models/unseen/$1"
  echo "put models/unseen/$1" >&2
}

# A version's files never change; the manifest does.
put "$version/$f" "$src/$f" "public, max-age=31536000, immutable"
put "$version/$f.json" "$src/$f.json" "public, max-age=31536000, immutable"
trap 'rm -f models/manifest.toml.signed' EXIT
unseen models sign
put manifest.signed models/manifest.toml.signed "public, max-age=300"
