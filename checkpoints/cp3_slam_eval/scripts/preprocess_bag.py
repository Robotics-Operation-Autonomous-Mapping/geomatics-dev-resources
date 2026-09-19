#!/usr/bin/env python3
"""Preprocess a field bag: sync / filter / prepare for SLAM.

STUB — implement filtering. CLI is stable for run_cp3.sh.
"""

from __future__ import annotations

import argparse
import shutil
import sys
from pathlib import Path


def preprocess(input_bag: Path, output_bag: Path, max_lidar_range: float) -> None:
    """Filter and rewrite bag.

    TODO(student):
      - drop topics not needed for SLAM/GT
      - optional time sync / deskew notes
      - range filter on PointCloud2 if applicable
    """
    raise NotImplementedError('Implement preprocess')


def main(argv: list[str] | None = None) -> int:
    p = argparse.ArgumentParser(description='CP3 bag preprocess')
    p.add_argument('--input', type=Path, required=True)
    p.add_argument('--output', type=Path, required=True)
    p.add_argument('--max-lidar-range', type=float, default=80.0)
    p.add_argument('--copy-passthrough', action='store_true',
                   help='Dev helper: copy input to output without filtering')
    args = p.parse_args(argv)

    if args.copy_passthrough:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        if args.input.is_dir():
            if args.output.exists():
                shutil.rmtree(args.output)
            shutil.copytree(args.input, args.output)
        else:
            shutil.copy2(args.input, args.output)
        print(f'Passthrough copy → {args.output}')
        return 0

    try:
        preprocess(args.input, args.output, args.max_lidar_range)
    except NotImplementedError as e:
        print(f'[stub] {e}', file=sys.stderr)
        print('Re-run with --copy-passthrough for plumbing tests only.', file=sys.stderr)
        return 2

    print(f'Wrote {args.output}')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
