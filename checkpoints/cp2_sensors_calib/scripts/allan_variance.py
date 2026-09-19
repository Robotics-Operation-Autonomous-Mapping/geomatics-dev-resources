#!/usr/bin/env python3
"""Allan variance for a static IMU log → plot + imu_noise.yaml.

STUB: implement variance computation. CLI and YAML schema are fixed for grading.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path


def compute_allan_deviation(omega: list[float], dt: float) -> tuple[list[float], list[float]]:
    """Return (tau_s, sigma) Allan deviation curve.

    TODO(student): implement overlapping or non-overlapping Allan variance.
    """
    raise NotImplementedError('Implement compute_allan_deviation')


def extract_noise_params(tau: list[float], sigma: list[float]) -> dict:
    """Extract angle/velocity random walk and bias instability-style params.

    TODO(student): fit noise density and random walk from the curve.
    Return dict with keys used in write_yaml().
    """
    raise NotImplementedError('Implement extract_noise_params')


def write_yaml(path: Path, params: dict) -> None:
    import yaml

    payload = {
        'accelerometer': {
            'noise_density': float(params['accel_noise_density']),
            'random_walk': float(params['accel_random_walk']),
            'units': {
                'noise_density': 'm/s^2/sqrt(Hz)',
                'random_walk': 'm/s^3/sqrt(Hz)',
            },
        },
        'gyroscope': {
            'noise_density': float(params['gyro_noise_density']),
            'random_walk': float(params['gyro_random_walk']),
            'units': {
                'noise_density': 'rad/s/sqrt(Hz)',
                'random_walk': 'rad/s^2/sqrt(Hz)',
            },
        },
    }
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(yaml.safe_dump(payload, sort_keys=False), encoding='utf-8')


def main(argv: list[str] | None = None) -> int:
    p = argparse.ArgumentParser(description='Allan variance to imu_noise.yaml')
    p.add_argument('--input', type=Path, help='IMU CSV or bag directory')
    p.add_argument('--output-yaml', type=Path, default=Path('output/imu_noise.yaml'))
    p.add_argument('--output-plot', type=Path, default=Path('output/allan_plot.png'))
    p.add_argument('--help-schema', action='store_true', help='Print YAML keys and exit')
    args = p.parse_args(argv)

    if args.help_schema:
        print('accel_noise_density, accel_random_walk, gyro_noise_density, gyro_random_walk')
        return 0

    if args.input is None:
        p.error('--input is required unless --help-schema is set')

    # TODO(student): load IMU samples from --input
    # CSV from scripts/kitti_oxts_prepare.py: t,ax,ay,az,gx,gy,gz  (or a rosbag2 dir)
    print(f'[stub] would load IMU from {args.input}', file=sys.stderr)
    try:
        tau, sigma = compute_allan_deviation([], 0.01)
        params = extract_noise_params(tau, sigma)
    except NotImplementedError as e:
        print(f'[stub] {e}', file=sys.stderr)
        # Write placeholder so pipeline plumbing can be tested
        write_yaml(
            args.output_yaml,
            {
                'accel_noise_density': float('nan'),
                'accel_random_walk': float('nan'),
                'gyro_noise_density': float('nan'),
                'gyro_random_walk': float('nan'),
            },
        )
        print(f'Wrote placeholder YAML to {args.output_yaml}')
        return 0

    write_yaml(args.output_yaml, params)
    # TODO(student): save plot to args.output_plot
    print(f'Wrote {args.output_yaml}')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
