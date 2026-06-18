import logging
import subprocess
from pathlib import Path

import requests
from pydantic import BaseModel, Field

log = logging.getLogger(__name__)

SPOONS_JSON = Path(__file__).parent / "spoons.json"
GITHUB_API = "https://api.github.com"
GITHUB_BASE = "https://github.com"


class GitHubSpoon(BaseModel):
    owner: str
    repo: str
    rev: str
    sha256: str


class SpoonsSpec(BaseModel):
    official_rev: str = Field(alias="officialRev")
    official_spoons: dict[str, str] = Field(alias="officialSpoons")
    github_spoons: dict[str, GitHubSpoon] = Field(alias="GitHubSpoons")

    model_config = {"populate_by_name": True}


class NixPrefetchGit(BaseModel):
    url: str
    rev: str
    sha256: str
    hash: str
    date: str = ""
    path: str = ""
    fetchLFS: bool = False
    fetchSubmodules: bool = False
    deepClone: bool = False
    fetchTags: bool = False
    leaveDotGit: bool = False
    rootDir: str = ""


def official_spoon_url(name: str, rev: str) -> str:
    """Return the fetchzip URL for an official Hammerspoon spoon."""
    OFFICIAL_REPO = "Hammerspoon/Spoons"
    OFFICIAL_URL = f"{GITHUB_BASE}/{OFFICIAL_REPO}"
    return f"{OFFICIAL_URL}/raw/{rev}/Spoons/{name}.spoon.zip"


def prefetch_zip_hash(url: str, hash: str = "sha256") -> str:
    """Return the sri hash of a fetchzip url via nix-prefetch-url --unpack."""
    raw = subprocess.check_output(
        ["nix-prefetch-url", "--unpack", "--type", hash, url],
        text=True,
    ).strip()
    return subprocess.check_output(
        ["nix", "hash", "convert", "--hash-algo", hash, "--from", "nix32", raw],
        text=True,
    ).strip()


def prefetch_github_hash(
    owner: str,
    repo: str,
    rev: str,
    format: str = "sha256",
) -> str:
    """Return the hash of a fetchFromGitHub source via nix-prefetch-git."""
    url = f"{GITHUB_BASE}/{owner}/{repo}"
    out = subprocess.check_output(
        [
            "nix-prefetch-git",
            "--quiet",
            "--url",
            url,
            "--rev",
            rev,
            "--hash",
            format,
        ],
        text=True,
    )
    result = NixPrefetchGit.model_validate_json(out)
    return result.hash


def latest_rev(owner: str, repo: str) -> str:
    """Return the HEAD commit SHA of the default branch."""
    info = requests.get(f"{GITHUB_API}/repos/{owner}/{repo}").json()
    branch = info["default_branch"]
    resp = requests.get(
        f"{GITHUB_API}/repos/{owner}/{repo}/commits/{branch}",
        headers={"Accept": "application/vnd.github.sha"},
    )
    return resp.text.strip()


OFFICIAL_REPO = "Hammerspoon/Spoons"


def update(spec: SpoonsSpec) -> None:
    """Update all spoons to their latest revisions and hashes."""
    owner, repo = OFFICIAL_REPO.split("/")
    rev = latest_rev(owner, repo)
    log.info("%s -> %s", OFFICIAL_REPO, rev)
    spec.official_rev = rev
    for name in spec.official_spoons:
        url = official_spoon_url(name, rev)
        spec.official_spoons[name] = prefetch_zip_hash(url)
        log.info("  %s -> %s", name, spec.official_spoons[name])

    for name, spoon in spec.github_spoons.items():
        rev = latest_rev(spoon.owner, spoon.repo)
        log.info("%s/%s -> %s", spoon.owner, spoon.repo, rev)
        spoon.rev = rev
        spoon.sha256 = prefetch_github_hash(spoon.owner, spoon.repo, rev)
        log.info("  %s -> %s", name, spoon.sha256)


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format="%(message)s")
    spec = SpoonsSpec.model_validate_json(SPOONS_JSON.read_text())
    update(spec)
    SPOONS_JSON.write_text(spec.model_dump_json(indent=2, by_alias=True) + "\n")
    log.info("wrote %s", SPOONS_JSON)
