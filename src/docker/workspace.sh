#set ROS@ DISTRIBUTION as a variable
ROS_DISTRO="humble"

#source ROS2 setup
source /opt/ros/$ROS_DISTRO/setup.bash

#install system dependencies 
apt-get update && apt-get install -y gnupg curl libpcap-dev


# Navigate back to the workspace root 
cd /root/ros2/ros2_robot

#install ros2 dependedncies
echo "Installing ROS@ Dependencies...."
rosdep update 
rosdep install -i --from-paths src --rosdistro $ROS_DISTRO -y

# build all the packages 
echo "Building all available Packages...."
colcon build --symlink-install
source install/local_setup.bash

echo "Workspace Built Successfully...."

