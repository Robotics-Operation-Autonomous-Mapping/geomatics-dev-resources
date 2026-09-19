"""CP1 attitude node — stub.

Subscribe to sensor_msgs/Imu, estimate roll/pitch from accelerometer,
publish attitude, and broadcast a tf2 transform.
"""

from __future__ import annotations

import math

import rclpy
from rclpy.node import Node
from geometry_msgs.msg import TransformStamped, Vector3
from sensor_msgs.msg import Imu
from tf2_ros import TransformBroadcaster


def accel_to_roll_pitch(ax: float, ay: float, az: float) -> tuple[float, float]:
    """Return roll, pitch in radians from accelerometer (m/s^2).

    TODO(student): implement. Typical stationary formulas:

        roll  = atan2(ay, az)
        pitch = atan2(-ax, sqrt(ay^2 + az^2))

    Handle degenerate cases; document assumptions in your PR.
    """
    raise NotImplementedError('Implement accel_to_roll_pitch')


class AttitudeNode(Node):
    def __init__(self) -> None:
        super().__init__('attitude_node')
        self.declare_parameter('imu_topic', '/imu/data')
        self.declare_parameter('parent_frame', 'base_link')
        self.declare_parameter('child_frame', 'imu_attitude')

        imu_topic = self.get_parameter('imu_topic').get_parameter_value().string_value
        self._parent = self.get_parameter('parent_frame').get_parameter_value().string_value
        self._child = self.get_parameter('child_frame').get_parameter_value().string_value

        self._pub = self.create_publisher(Vector3, 'attitude', 10)
        self._tf = TransformBroadcaster(self)
        self._sub = self.create_subscription(Imu, imu_topic, self._on_imu, 10)
        self.get_logger().info(f'Subscribing to {imu_topic}')

    def _on_imu(self, msg: Imu) -> None:
        ax = msg.linear_acceleration.x
        ay = msg.linear_acceleration.y
        az = msg.linear_acceleration.z

        try:
            roll, pitch = accel_to_roll_pitch(ax, ay, az)
        except NotImplementedError:
            self.get_logger().error('accel_to_roll_pitch not implemented', throttle_duration_sec=5.0)
            return

        out = Vector3()
        out.x = float(roll)
        out.y = float(pitch)
        out.z = float('nan')
        self._pub.publish(out)

        t = TransformStamped()
        t.header.stamp = msg.header.stamp
        t.header.frame_id = self._parent
        t.child_frame_id = self._child
        # TODO(student): set t.transform.rotation from roll/pitch (yaw=0)
        # Hint: quaternion from RPY, or compose manually.
        t.transform.rotation.w = 1.0
        self._tf.sendTransform(t)


def main(args=None) -> None:
    rclpy.init(args=args)
    node = AttitudeNode()
    try:
        rclpy.spin(node)
    finally:
        node.destroy_node()
        rclpy.shutdown()


if __name__ == '__main__':
    main()
