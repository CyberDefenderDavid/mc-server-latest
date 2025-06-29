#!/usr/bin/env bash
set -e

manifest_url="https://launchermeta.mojang.com/mc/game/version_manifest.json"
manifest="$(curl -sL "$manifest_url")"
latest=$(jq -r '.latest.release' <<<"$manifest")
version_url=$(jq -r ".versions[] | select(.id==\"$latest\") | .url" <<<"$manifest")
ver_manifest="$(curl -sL "$version_url")"
jar_url=$(jq -r '.downloads.server.url' <<<"$ver_manifest")
sha1=$(jq -r '.downloads.server.sha1' <<<"$ver_manifest")
release_time=$(jq -r '.releaseTime' <<<"$ver_manifest")

cat <<EOF > data/mc-latest.json
{
  "version": "$latest",
  "jar_url": "$jar_url",
  "sha1": "$sha1",
  "release_time": "$release_time"
}
EOF
