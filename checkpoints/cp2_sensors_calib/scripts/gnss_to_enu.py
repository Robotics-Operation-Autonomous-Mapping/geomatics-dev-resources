#!/usr/bin/env python3
"""Parse GNSS log → ENU trajectory plot colored by fix quality.

STUB: implement parse + LLA→ENU. Output paths are fixed for grading.
"""

from __future__ import annotations

import argparse
import csv
import sys
from pathlib import Path


def parse_gnss(path: Path) -> list[dict]:
    """Return list of dicts with keys: t, lat, lon, alt, fix_quality.

    TODO(student): support NMEA GGA and/or the KITTI CSV from docs/data.md
    (columns t,lat,lon,alt,fix_quality,numsats).
    """
    raise NotImplementedError('Implement parse_gnss')


def lla_to_enu(
    lat: float, lon: float, alt: float, lat0: float, lon0: float, alt0: float
) -> tuple[float, float, float]:
    """Convert LLA to ENU relative to origin.

    TODO(student): implement (pymap3d OK if dependency documented).
    """
    raise NotImplementedError('Implement lla_to_enu')


def plot_trajectory(points: list[dict], out: Path) -> None:
    """Plot East-North colored by fix_quality; save to out.

    TODO(student): matplotlib scatter.
    """
    raise NotImplementedError('Implement plot_trajectory')


def main(argv: list[str] | None = None) -> int:
    p = argparse.ArgumentParser(description='GNSS to ENU plot')
    p.add_argument('--input', type=Path, required=True)
    p.add_argument('--output-plot', type=Path, default=Path('output/gnss_enu.png'))
    p.add_argument('--output-csv', type=Path, default=Path('output/gnss_enu.csv'))
    p.add_argument('--origin-lat', type=float, default=None)
    p.add_argument('--origin-lon', type=float, default=None)
    p.add_argument('--origin-alt', type=float, default=0.0)
    args = p.parse_args(argv)

    try:
        fixes = parse_gnss(args.input)
    except NotImplementedError as e:
        print(f'[stub] {e}', file=sys.stderr)
        args.output_csv.parent.mkdir(parents=True, exist_ok=True)
        with args.output_csv.open('w', newline='', encoding='utf-8') as f:
            w = csv.writer(f)
            w.writerow(['t', 'e', 'n', 'u', 'fix_quality'])
        print(f'Wrote placeholder CSV {args.output_csv}')
        return 0

    lat0 = args.origin_lat if args.origin_lat is not None else fixes[0]['lat']
    lon0 = args.origin_lon if args.origin_lon is not None else fixes[0]['lon']
    alt0 = args.origin_alt

    rows = []
    for g in fixes:
        e, n, u = lla_to_enu(g['lat'], g['lon'], g['alt'], lat0, lon0, alt0)
        rows.append({**g, 'e': e, 'n': n, 'u': u})

    args.output_csv.parent.mkdir(parents=True, exist_ok=True)
    with args.output_csv.open('w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fieldnames=['t', 'e', 'n', 'u', 'fix_quality'])
        w.writeheader()
        for r in rows:
            w.writerow(
                {
                    't': r['t'],
                    'e': r['e'],
                    'n': r['n'],
                    'u': r['u'],
                    'fix_quality': r['fix_quality'],
                }
            )

    try:
        plot_trajectory(rows, args.output_plot)
    except NotImplementedError as e:
        print(f'[stub] {e}', file=sys.stderr)

    print(f'Wrote {args.output_csv}')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
