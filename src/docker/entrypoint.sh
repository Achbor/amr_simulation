#!/bin/bash

#setup ros distribution
ROS_DISTRO="humble"

# Create required temp directories for GUI Apps
export XDG_RUNTIME_DIR=/tmp/runtime-$USER
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# set base paths for convenience
ROS_WS="/root/ros2/ros2_robot"

# Shared ros2 files
SHARED_ROS2="/root/shared/ros2"

# Creating ROS domain id.txt file with default value of 0 if it does not exist
ROS_DOMAIN_ID_FILE="$SHARED_ROS2/ros_domain_id.txt"

if [ ! -f "$ROS_DOMAIN_ID_FILE" ]; then
    # create a file with value id = 0
    echo "0" > "$ROS_DOMAIN_ID_FILE"
    echo "Created $ROS_DOMAIN_ID_FILE with default value 0"
fi

# The ROS_DOMAIN_ID will need to be the same for computers that you want to communicate with each other.
# this value can taake any  number between 0 and 232. 
# It is useful if you have multiple ROS2 robots in the same environment.
if [ ! grep -q "export ROS_DOMAIN_ID" /root/.bashrc ]; then
    # Read the ros domain id from the file
    ros_domain_id=$(cat "$ROS_DOMAIN_ID_FILE")
    # add the export command to .bashrc if it is not already there
    echo "export ROS_DOMAIN_ID=$ros_domain_id" >> /root/.bashrc
fi

# Make ROS sDomain ID available to the current scripts
export ROS_DOMAIN_ID=$(cat "$ROS_DOMAIN_ID_FILE")

# Source the main ROS setup
source /opt/ros/$ROS_DISTRO/setup.bash

#source the local workspace
source $ROS_WS/install/local_setup.bash

# source the .bashrc to make sure all environment variables are loaded
source /root/.bashrc

# redirect to ROS2 workspace
cd $ROS_WS

# Build the workspace
colcon build --symlink-install

# change back into root directory
cd ~

# source .bashrc to ensure any chagnes are made available 
source /root/.bashrc

# any command written after this will run in the environment setup by the script
exec "$@"

