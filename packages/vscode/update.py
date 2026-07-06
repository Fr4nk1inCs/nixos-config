import json
import logging
import subprocess
from enum import StrEnum
from pathlib import Path
from typing import Literal, overload

import requests
import tyro
from pydantic import BaseModel

BASE_DIR = Path(__file__).parent
VERSION_URL = (
    "https://marketplace.visualstudio.com/_apis/public/gallery/"
    "extensionquery?api-version=7.2-preview.1"
)

logging.basicConfig(level=logging.INFO, format="%(levelname)8s | %(message)s")
logger = logging.getLogger(__name__)


class SpecificPlatforms(StrEnum):
    x86_64_linux = "x86_64-linux"
    aarch64_linux = "aarch64-linux"
    x86_64_darwin = "x86_64-darwin"
    aarch64_darwin = "aarch64-darwin"

    def to_vscode(self) -> str:
        match self:
            case SpecificPlatforms.x86_64_linux:
                return "linux-x64"
            case SpecificPlatforms.aarch64_linux:
                return "linux-arm64"
            case SpecificPlatforms.x86_64_darwin:
                return "darwin-x64"
            case SpecificPlatforms.aarch64_darwin:
                return "darwin-arm64"


def download_url(
    publisher: str,
    name: str,
    version: str,
    universal: bool,
    platform: SpecificPlatforms | None,
) -> str:
    suffix: str
    if universal:
        assert platform is None
        suffix = ""
    else:
        assert platform is not None
        suffix = f"targetPlatform={platform.to_vscode()}"

    return (
        f"https://{publisher}.gallery.vsassets.io/"
        f"_apis/public/gallery/publisher/{publisher}/extension/{name}/"
        f"{version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
        f"?{suffix}"
    )


def nix_prefetch_sha256(url: str) -> str:
    result = subprocess.run(
        ["nix-prefetch-url", "--type", "sha256", url],
        capture_output=True,
        text=True,
        check=True,
    ).stdout.strip()
    sha256 = subprocess.run(
        ["nix-hash", "--type", "sha256", "--to-sri", result],
        capture_output=True,
        text=True,
        check=True,
    )
    return sha256.stdout.strip()


def get_latest_version(publisher: str, name: str) -> str:
    data = {
        "filters": [
            {
                "criteria": [
                    {
                        "filterType": 7,
                        "value": f"{publisher}.{name}",
                        "sortBy": 1,
                        "sortOrder": 0,
                    },
                ],
            }
        ],
        "flags": 914,
    }
    headers = {
        "Accept": "application/json;api-version=7.2-preview.1",
        "Content-Type": "application/json",
    }

    with requests.post(VERSION_URL, json=data, headers=headers) as response:
        response.raise_for_status()
        result = response.json()
        return result["results"][0]["extensions"][0]["versions"][0]["version"]


class UniversalVersionData(BaseModel):
    version: str
    hash: str

    def update(self, publisher: str, extension: str) -> bool:
        new_version = get_latest_version(publisher, extension)
        if new_version == self.version:
            return False
        logger.info(
            "Updating %s.%s from version %s to %s",
            publisher,
            extension,
            self.version,
            new_version,
        )
        self.version = new_version
        self.hash = nix_prefetch_sha256(
            download_url(publisher, extension, new_version, True, None)
        )
        logger.info(
            "New hash for %s.%s: %s",
            publisher,
            extension,
            self.hash,
        )
        return True


class PlatformSpecificVersionData(BaseModel):
    version: str
    hashes: dict[SpecificPlatforms, str]

    def update(self, publisher: str, extension: str) -> bool:
        new_version = get_latest_version(publisher, extension)
        if new_version == self.version:
            return False
        logger.info(
            "Updating %s.%s from version %s to %s",
            publisher,
            extension,
            self.version,
            new_version,
        )
        self.version = new_version
        self.hashes = {
            platform: nix_prefetch_sha256(
                download_url(publisher, extension, new_version, False, platform)
            )
            for platform in SpecificPlatforms
        }
        for platform, hash in self.hashes.items():
            logger.info(
                "New hash for %s.%s on %s: %s",
                publisher,
                extension,
                platform.value,
                hash,
            )
        return True


VersionData = UniversalVersionData | PlatformSpecificVersionData


@overload
def read_version_data(
    extension: str,
    universal: Literal[True],
) -> tuple[UniversalVersionData, Path]: ...


@overload
def read_version_data(
    extension: str, universal: Literal[False]
) -> tuple[PlatformSpecificVersionData, Path]: ...


def read_version_data(
    extension: str, universal: bool
) -> tuple[VersionData, Path]:
    path = BASE_DIR / f"{extension}.json"
    json = path.read_text(encoding="utf-8")
    if universal:
        return UniversalVersionData.model_validate_json(json), path
    return PlatformSpecificVersionData.model_validate_json(json), path


class Args(BaseModel):
    publisher: str
    extension: str
    universal: bool = False


def main(arg: Args) -> None:
    data, path = read_version_data(arg.extension, arg.universal)
    if data.update(arg.publisher, arg.extension):
        path.write_text(
            json.dumps(data.model_dump(), indent="\t") + "\n",
            encoding="utf-8",
        )
        logger.info("Updated %s.json", arg.extension)
    else:
        logger.info("%s.%s is already up to date", arg.publisher, arg.extension)


if __name__ == "__main__":
    args = tyro.cli(Args)
    main(args)
