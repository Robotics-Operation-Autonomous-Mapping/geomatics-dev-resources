# Autoware sensor kit stub (CP2)

Fill extrinsics from your Kalibr / team calibration. Mirror also lives in
`templates/sensor_kit/` for reuse.

Official context: [Autoware documentation](https://autowarefoundation.github.io/autoware-documentation/main/)

## Files

| File | Purpose |
|------|---------|
| `sensor_kit_calibration.yaml` | Frames / transforms between sensors |
| `README.md` | How you launch localization on the sample bag |

## Launch / localize checklist

- [ ] Extrinsics match Kalibr output (units: metres, radians)
- [ ] Frame names match the bag TF / topic documentation
- [ ] Point cloud map path set for the CP2 sample
- [ ] `use_sim_time:=true` when playing the bag
- [ ] Localization node publishes pose (NDT or team default)

Sample data: `data/cp2/autoware_localize/` (`TODO:SHARED_DRIVE_URL`).
