ARG ROS_DISTRO=humble

FROM ros:$ROS_DISTRO

# sEt the maintainer info for teh docker file
LABEL maintainer="Ahbor AMR team <achborjm@gmail.com>"

# set up the environmental variables
ENV PIP_BREAK_SYSTEM_PACKAGES=1
ENV DEBIAN_FRONTEND=noninteractive

# Set the default shell to chache for RUN commands
SHELL ["/bin/bash", "-c"]

# Update the system and install essential packages
RUN apt-get update -q && apt-get upgrade -yq \
    && apt-get install -yq --no-install-recommends apt-utils wget curl git build-essential \
    vim sudo lsb-release locales bash-completion tzdata gosu gedit htop nano libserial-dev

# install additional ROS2 dev tools
# run the pakcages to help with building and managing ROS2 workspaces
RUN apt-get update -q && apt-get install -y gnupg2 iputils-ping usbutils \
    python3-argcomplete python3-colcon-common-extensions python3-networkx python3-pip python3-rosdep \
    python3-vcstool

# setup the rors2 enivronment
# this ensures that the ROS2 commands are available in teh shell
RUN rosdep update && \
    grep -F "source /opt/ros/${ROS_DISTRO}/setup.bash" /root/.bashrc || echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /root/.bashrc && \
    grep -F "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" /root/.bashrc || echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> /root/.bashrc

# Install additional ROS2 packages
RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-joint-state-publisher-gui \
    ros-${ROS_DISTRO}-xacro \
    ros-${ROS_DISTRO}-demo-nodes-cpp \
    ros-${ROS_DISTRO}-demo-nodes-py \
    ros-${ROS_DISTRO}-rviz2 \
    ros-${ROS_DISTRO}-rqt-reconfigure 

# install Mesa graphics drivers
RUN apt-get update && apt-get install -y software-properties-common && \
    DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:kisak/kisak-mesa

# Create neccesssary directories
RUN mkdir -p /etc/udev/rules.d && \
    mkdir -p /root/ros2/ros2_robot/src/achbor_amr

# Copy the entire project into the container
COPY . /root/ros2/ros2_robot/src/achbor_amr

# Copy the configuration files from the docker directory
# Note the docker/ prefix since we are now in the parent context
COPY ./docker/workspace.sh /root/
COPY ./docker/entrypoint.sh /root/
COPY ./docker/bash_alias.txt /root/.bashrc_aliases

# make scripts executable
RUN chmod +x /root/workspace.sh /root/entrypoint.sh

# Add bash aliases to the bashrc
RUN cat /root/.bashrc_aliases >> /root/.bashrc

# Run the worlspace script to install depenedencies and build ROS2 Packages
WORKDIR /root

RUN ./workspace.sh

# encure the ROS2 workspace is sourced in every new shell 
RUN echo "source /root/ros2/ros2_robot/install/local_setup.bash" >> /root/.bashrc

# Set the entrypoint for teh container
# This script runs everytime a new ccontainer starts
ENTRYPOINT ["/root/entrypoint.sh"]

# Set the default command
# the command keeps teh container running indifinetly, allowinf us to exc into it and run commands
CMD ["/bin/bash", "-c", "tail -f /dev/null"]