from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument
from launch.substitutions import LaunchConfiguration
from launch_ros.actions import Node
from ament_index_python.packages import get_package_share_directory
import os


def generate_launch_description() -> LaunchDescription:
    pkg = get_package_share_directory('cp1_imu_attitude')
    default_params = os.path.join(pkg, 'config', 'params.yaml')

    imu_topic_arg = DeclareLaunchArgument(
        'imu_topic',
        default_value='/imu/data',
        description='IMU topic (sensor_msgs/Imu)',
    )
    params_arg = DeclareLaunchArgument(
        'params_file',
        default_value=default_params,
        description='Path to params YAML',
    )

    node = Node(
        package='cp1_imu_attitude',
        executable='attitude_node',
        name='attitude_node',
        output='screen',
        parameters=[
            LaunchConfiguration('params_file'),
            {'imu_topic': LaunchConfiguration('imu_topic')},
        ],
    )

    return LaunchDescription([imu_topic_arg, params_arg, node])
