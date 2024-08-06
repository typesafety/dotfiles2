#!/usr/bin/env python3
"""Create a snapshot of relevant system files/packages.

NOTE:
    Do NOT run with --force without knowing what it does -- it will delete
    files and/or directories.

* Copy files and directories from a given whitelist
* Query pacman for installed packages and output to file

"""

import shutil
import subprocess
import sys
from argparse import ArgumentParser
from pathlib import Path


PATHS_TO_SYNC: list[str] = [
    "/home/typesafety/.config/nvim",
    "/home/typesafety/.config/zellij",
    "/home/typesafety/.zshrc",
]

def sync_files(results_dir: Path) -> None:
    src_dst_map: dict[Path, Path] = {
        Path(s): results_dir / s.lstrip("/")
        for s in PATHS_TO_SYNC
    }

    for src, dst in src_dst_map.items():
        if src.is_dir():
            shutil.copytree(src, dst, dirs_exist_ok=True, symlinks=True)
        else:
            dst.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src, dst, follow_symlinks=False)

    print("Synced files.")


def prepare_results_dir(results_dir: Path, force: bool = False):
    if results_dir.exists():
        if force:
            print(f"--force option given, removing {results_dir}")
            shutil.rmtree(results_dir)
        else:
            raise FileExistsError(f"Output directory '{results_dir}' already exists!")

    results_dir.mkdir()


def sync_all(results_dir: Path) -> None:
    print("Starting sync.")

    sync_files(results_dir)

    print("Finished sync.")


def _get_parser() -> ArgumentParser:
    parser = ArgumentParser()
    parser.add_argument(
        "--results-dir",
        type=Path,
        help=(
            "Location to dump outputted files to.  Defaults to"
            " <location of script>/root/"
        ),
        default=Path(__file__).parent / "root",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help=(
            "(USE WITH CAUTION) Delete and recreate the results directory if it"
            " already exists."
        ),
    )
    return parser


def main() -> None:
    args = _get_parser().parse_args()

    prepare_results_dir(args.results_dir, force=args.force)
    sync_all(args.results_dir)

    sys.exit(0)



if __name__ == "__main__":
    main()
