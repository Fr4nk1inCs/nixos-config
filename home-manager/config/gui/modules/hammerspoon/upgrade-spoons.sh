#!/usr/bin/env bash

# This script upgrades all declared Hammerspoon spoons in this directory.
set -euo pipefail

basedir=$(dirname "$0")
pushd "$basedir" >/dev/null || exit 1

awk() {
  nix run nixpkgs#gawk -- "$@"
}

fetch_rev() {
  local owner="$1"
  local repo="$2"
  local branch="${3:-main}"

  gh api "repos/$owner/$repo/branches/$branch" \
    --jq '.commit.sha' 2>/dev/null
}

fetch_zip_hash() {
  local url="$1"
  nix-prefetch-url --unpack "$url"
}

fetch_github_repo_hash() {
  local owner="$1"
  local repo="$2"
  local rev="$3"

  local url="https://github.com/$owner/$repo"

  nix-shell -p nix-prefetch-git jq \
    --run "nix-prefetch-git --url $url --quiet --rev $rev | jq -r '.sha256'" \
    2>/dev/null
}

# github:Hammerspoon/Spoons ReloadConfiguration
reload_config() {
  local owner="Hammerspoon"
  local repo="Spoons"

  local orig_rev
  orig_rev=$(awk 'NR==17 {match($0, /rev = "(.*)";/, arr); print arr[1]}' ./default.nix)

  local rev
  rev=$(fetch_rev "$owner" "$repo" "master")

  if [[ "$rev" == "$orig_rev" ]]; then
    echo "ReloadConfiguration is already up to date ($rev)"
    return
  fi

  local spoon="ReloadConfiguration"
  local zip_url="https://github.com/$owner/$repo/raw/$rev/Spoons/$spoon.spoon.zip"
  local zip_hash
  zip_hash=$(fetch_zip_hash "$zip_url")

  sed -i '' '17s/rev = "[^"]*";/rev = "'"$rev"'";/' ./default.nix
  sed -i '' '21s/sha256 = "[^"]*";/sha256 = "'"$zip_hash"'";/' ./default.nix
}
reload_config

# github:mogenson/PaperWM.spoon
paperwm() {
  local owner="mogenson"
  local repo="PaperWM.spoon"

  local orig_rev
  orig_rev=$(awk 'NR==16 {match($0, /rev = "(.*)";/, arr); print arr[1]}' ./paperwm.nix)
  local rev
  rev=$(fetch_rev "$owner" "$repo" "main")

  if [[ "$rev" == "$orig_rev" ]]; then
    echo "PaperWM is already up to date ($rev)"
    return
  fi

  local hash
  hash=$(fetch_github_repo_hash "$owner" "$repo" "$rev")

  sed -i '' '16s/rev = "[^"]*";/rev = "'"$rev"'";/' ./paperwm.nix
  sed -i '' '17s/sha256 = "[^"]*";/sha256 = "'"$hash"'";/' ./paperwm.nix
}
paperwm

# github:mogenson/WarpMouse.spoon
warpmouse() {
  local owner="mogenson"
  local repo="WarpMouse.spoon"

  local orig_rev
  orig_rev=$(awk 'NR==22 {match($0, /rev = "(.*)";/, arr); print arr[1]}' ./paperwm.nix)
  local rev
  rev=$(fetch_rev "$owner" "$repo" "main")

  if [[ "$rev" == "$orig_rev" ]]; then
    echo "WarpMouse is already up to date ($rev)"
    return
  fi

  local hash
  hash=$(fetch_github_repo_hash "$owner" "$repo" "$rev")

  sed -i '' '22s/rev = "[^"]*";/rev = "'"$rev"'";/' ./paperwm.nix
  sed -i '' '23s/sha256 = "[^"]*";/sha256 = "'"$hash"'";/' ./paperwm.nix
}
warpmouse

popd >/dev/null || exit 1
