#!/usr/bin/env python
"""downloads files from the 'arc-ctc-tahoe100'"""

import argparse
import os

import gcsfs

GCP_BASE_PATH = "gs://arc-ctc-tahoe100/"


def main():
    parser = argparse.ArgumentParser(description="Download from arc-ctc-tahoe100 GCS bucket")
    parser.add_argument(
        "--dest",
        "-d",
        default="./data/",
        help="Destination folder for downloaded files (default: ./data)",
    )

    args = parser.parse_args()

    dest = os.path.join(args.dest, os.path.basename(GCP_BASE_PATH.rstrip("/")), "")
    os.makedirs(dest, exist_ok=True)

    fs = gcsfs.GCSFileSystem()

    fs.get(GCP_BASE_PATH, dest, recursive=True)


if __name__ == "__main__":
    main()
