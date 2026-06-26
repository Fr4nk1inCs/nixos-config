#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl gnused jq nix python3 yq-go flutter344 git

set -eou pipefail

ROOT="$(cd "$(dirname "$0")" && pwd -P)"
RELEASE_FILE="$ROOT/release.json"
PUBSPEC_LOCK_JSON="$ROOT/pubspec.lock.json"
GIT_HASHES_JSON="$ROOT/git-hashes.json"

GITHUB_REPO="Chevey339/kelivo"
DARWIN_SYSTEM="aarch64-darwin"
DARWIN_HASH_KEY="${DARWIN_SYSTEM}-release"
DARWIN_ASSET_PATTERN='^Kelivo_macos_[0-9.]+\+[0-9]+\.dmg$'

NIX=(nix --extra-experimental-features nix-command)
NIX_FLAKE=("${NIX[@]}" --extra-experimental-features flakes)

die() {
  echo "error: $*" >&2
  exit 1
}

github_url() {
  echo "https://github.com/${GITHUB_REPO}/$1"
}

latest_release() {
  curl --fail --silent --show-error --location "https://api.github.com/repos/${GITHUB_REPO}/releases/latest"
}

prefetch_flake() {
  "${NIX_FLAKE[@]}" flake prefetch --json "$1" | jq --raw-output .hash
}

prefetch_file() {
  "${NIX[@]}" store prefetch-file --json --hash-type sha256 "$1" | jq --raw-output .hash
}

single_release_asset() {
  local label="$1"
  local pattern="$2"
  local matches count

  matches=$(jq --compact-output --arg pattern "$pattern" \
    '[.assets[].name | select(test($pattern))]' <<<"$release_json")
  count=$(jq --raw-output length <<<"$matches")

  case "$count" in
  0)
    die "could not find ${label} release asset for ${latest_tag}"
    ;;
  1)
    jq --raw-output '.[0]' <<<"$matches"
    ;;
  *)
    echo "error: found multiple ${label} release assets for ${latest_tag}:" >&2
    jq --raw-output '.[]' <<<"$matches" >&2
    exit 1
    ;;
  esac
}

render_release_file() {
  local source_hash="$1"
  local darwin_hash="$2"
  local darwin_filename="$3"

  jq --tab \
    --arg version "$latest_version" \
    --arg source_hash "$source_hash" \
    --arg darwin_system "$DARWIN_SYSTEM" \
    --arg darwin_hash_key "$DARWIN_HASH_KEY" \
    --arg darwin_hash "$darwin_hash" \
    --arg darwin_filename "$darwin_filename" \
    '.version = $version
      | .sha256Hashes.source = $source_hash
      | .sha256Hashes[$darwin_hash_key] = $darwin_hash
      | .releaseFilenames[$darwin_system] = $darwin_filename' \
    "$RELEASE_FILE"
}

render_pubspec_lock() {
  local tag="$1"
  local workdir

  workdir=$(mktemp -d)
  trap "rm -rf '$workdir'" EXIT

  curl --fail --silent --location "$(github_url "archive/refs/tags/${tag}.tar.gz")" |
    tar -xz -C "$workdir" --strip-components=1

  export PUB_CACHE="$workdir/.pub-cache"
  flutter --no-version-check config --no-analytics >/dev/null
  (cd "$workdir" && flutter --no-version-check pub get >&2)

  yq eval --output-format=json --prettyPrint "$workdir/pubspec.lock"
}

render_git_hashes() {
  local pubspec_lock="$1"
  local fetch_git_hashes_script

  fetch_git_hashes_script=$("${NIX[@]}" eval --impure --raw --expr 'with import <nixpkgs> {}; dart.fetchGitHashesScript')
  python3 "$fetch_git_hashes_script" \
    --input <(printf '%s\n' "$pubspec_lock") \
    --output /dev/stdout
}

write_file() {
  local path="$1"
  local contents="$2"

  printf '%s\n' "$contents" >"$path"
}

release_json=$(latest_release)
latest_tag=$(jq --raw-output .tag_name <<<"$release_json")
latest_version="${latest_tag#v}"
current_version=$(jq --raw-output .version "$RELEASE_FILE")

if [[ $current_version == "$latest_version" ]]; then
  echo "kelivo metadata is up-to-date: $current_version"
  exit 0
fi

echo "updating kelivo: $current_version -> $latest_version"

source_hash=$(prefetch_flake "github:${GITHUB_REPO}/${latest_tag}")
darwin_filename=$(single_release_asset "$DARWIN_SYSTEM" "$DARWIN_ASSET_PATTERN")
darwin_url=$(github_url "releases/download/${latest_tag}/${darwin_filename}")
darwin_hash=$(prefetch_file "$darwin_url")
release_file_contents=$(render_release_file "$source_hash" "$darwin_hash" "$darwin_filename")
pubspec_lock_contents=$(render_pubspec_lock "$latest_tag")
git_hashes_contents=$(render_git_hashes "$pubspec_lock_contents")

write_file "$RELEASE_FILE" "$release_file_contents"
write_file "$PUBSPEC_LOCK_JSON" "$pubspec_lock_contents"
write_file "$GIT_HASHES_JSON" "$git_hashes_contents"

echo "kelivo metadata updated: $latest_version"
