#!/usr/bin/env bash
# Publishes a release for the app to download: every entry in models/manifest.toml
# for <version> whose `url` points to it (e.g. tiled ONNX and litert .tflite) plus
# its sidecar, then models/manifest.toml, signed, as `manifest.signed`.
#   op run --env-file models/publish.env -- models/publish.sh <version> <model dir>
# Model weights and manifests live under models/<project>/ of the bucket
# `public` (https://pub.lolli.tech); nothing private goes there.
set -euo pipefail
version=${1:?usage: models/publish.sh <version> <model dir>}
src=${2:?usage: models/publish.sh <version> <model dir>}
src=$(cd -- "$src" && pwd)
cd -- "$(dirname "$0")/.."
: "${CLOUDFLARE_API_TOKEN:?}" "${CLOUDFLARE_ACCOUNT_ID:?}" "${UNSEEN_MANIFEST_KEY:?}"
base=https://pub.lolli.tech/models/unseen
unseen() { cargo run -q --release -p unseen-cli -- "$@"; }

# Every app installs what this file lists.
status=$(git status --porcelain -- models/manifest.toml)
[ -z "$status" ] ||
  { echo "commit models/manifest.toml first" >&2; exit 1; }

# Collect every published manifest entry for <version>; reject mismatched URLs or duplicates.
entries=$(awk -v ver="$version" -v url="$base/$version" '
  /^\[\[model\]\]/ { flush(); next }
  /^version[[:space:]]*=/ { v = unquote($0) }
  /^variant[[:space:]]*=/ { var = unquote($0) }
  /^file[[:space:]]*=/    { f = unquote($0) }
  /^url[[:space:]]*=/     { u = unquote($0) }
  END { if (!failed) flush() }
  function unquote(s) { sub(/^[^"]*"/, "", s); sub(/".*$/, "", s); return s }
  function flush() {
    if (v == ver && u != "") {
      if (u != url) {
        printf "manifest.toml entry %s %s has url %s, expected %s\n", ver, var, u, url > "/dev/stderr"
        failed = 1; exit 1
      }
      if (var == "" || f == "") {
        printf "manifest.toml entry for %s is missing variant or file\n", ver > "/dev/stderr"
        failed = 1; exit 1
      }
      if (seen_var[var]++ || seen_file[f]++) {
        printf "manifest.toml has duplicate entry for %s (%s / %s)\n", ver, var, f > "/dev/stderr"
        failed = 1; exit 1
      }
      print var "\t" f
    }
    v = var = f = u = ""
  }
' models/manifest.toml)
[ -n "$entries" ] ||
  { echo "manifest.toml has no entry for $version with url $base/$version" >&2; exit 1; }

# Verify every listed file, its sidecar, and the signing key before uploading anything.
while IFS=$'\t' read -r variant f; do
  out=$(unseen models verify "$src/$f" 2>&1) || { echo "$out" >&2; exit 1; }
  grep -qF "(unseen-det $version $variant)" <<< "$out" ||
    { echo "$src/$f is not unseen-det $version $variant ($out)" >&2; exit 1; }
done <<< "$entries"

trap 'rm -f models/manifest.toml.signed' EXIT
unseen models sign

# put <key> <file> <cache-control>; the token goes through stdin, not argv.
put() {
  printf 'header = "Authorization: Bearer %s"\n' "$CLOUDFLARE_API_TOKEN" |
    curl -fsS -K - -o /dev/null -X PUT -H "Cache-Control: $3" -H "Content-Type: application/octet-stream" --data-binary "@$2" \
      "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/r2/buckets/public/objects/models/unseen/$1"
  echo "put models/unseen/$1" >&2
}

# A version's files never change; the manifest is uploaded last.
while IFS=$'\t' read -r _variant f; do
  put "$version/$f" "$src/$f" "public, max-age=31536000, immutable"
  put "$version/$f.json" "$src/$f.json" "public, max-age=31536000, immutable"
done <<< "$entries"
put manifest.signed models/manifest.toml.signed "public, max-age=300"
