#!/bin/bash

# Get absolute path to the directory containing this script
SCRIPT_PATH=$(dirname "$(realpath "$0")")

# Get the parent directory path 
PARENT_PATH=$(dirname "$SCRIPT_PATH")

#fucntion to build the Docker image
# This function handles the actual docker building process
build_docker_image(){
    # Set the log message for the BUild Process
    LOG="Building docker image for ROS2_ROBOT..."

    # Print the log message
    print_debug

    # BUild the Dodcker Image
    sudo docker image build -f $SCRIPT_PATH/Dockerfile -t manipulation:latest $PARENT_PATH --no-cache
}

# Funciton to create a shared folder
# This will be used to share files between the host and the container
create_shared_folder(){
    # check if the directory does not already exist
    if [ ! -d "$HOME/achy/shared/ros2" ]; then
        # Log message for folder creation
        LOG="Creating a shared folder at $HOME/achy/shared/ros2"
        print_debug

        # create the directory and its parent directories if they don't exist
        mkdir -p $HOME/achy/shared/ros2
    fi        
}

# Function to print Log messages
# PRoviding consistent formatting for all log messages
print_debug(){
    # Print an empty line for readabilitu
    echo " "
    echo "=============================="
    echo " "

    # print the message
    echo $LOG

    echo " "
    echo "=============================="    
    echo " "
}

# main execution starts here

# FOlder cration first
create_shared_folder

# Building the Docker image 
build_docker_image