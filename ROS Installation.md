# Ubuntu 20.04
## ROS 1 Noetic
http://wiki.ros.org/noetic/Installation/Ubuntu

## ROS 2 Humble
https://docs.ros.org/en/humble/Installation/Alternatives/Ubuntu-Development-Setup.html

* Instead of installing ROS at ~/ros2_humble, install at /opt/ros/humble. Use `sudo` for all commands.

* During step of `colcon build --symlink-install`, compiling may fail for `rclpy`. https://answers.ros.org/question/403182/colcon-build-errors-failed-rclpy-828s-exited-with-code-2/ \
  Solution: `sudo python -m pip install pybind11-global` and \
  `sudo colcon build --packages-select rclpy --symlink-install --cmake-args -DPYTHON_EXECUTABLE=/usr/bin/python -Dpybind11_DIR=/usr/local/lib/python3.8/dist-packages/pybind11/share/cmake/pybind11`