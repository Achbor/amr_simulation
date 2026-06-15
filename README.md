**AMR ROBOT SIMULATION**

This project encapsulates Autonomous Mobile Robot implementation at a simulation stage. 
The core implementation includes SLAM and Navigation ROS2 pakcages for 2d-map creation, localization and autonomous Navigation of the Robot and gazebo setup for simulation.

The ROS version is Humble, but can be updated and upgraded to other versions.

MAin COmponents required:
1. ROS2 Humble
2. ROS2 runnig platform (jetson, raspberrypi or a computer)
3. A joystick controller (optional).

LAUNCHING STEPS

first change the directory to the root directory of your workspace  and  build the workspace and make sure the ROS2 packages are all installed
```
bash
colcon build --symlink-install

# maske sure you are in the root directory of your workspace
source install/local_setup.sh
```

After bilding and sourcing the environment, make sure all the dependencies are correctly installed in your system so that the Launch goes smoothly
```
bash
sudo rosdep init
rosdep update

# The folling command might tale a while yo complete the full installation of unavaialbe packages
rosdep install --from-paths src --ignore-src -r -y
```

When successfully installed the packages, then launch the simulation lauinch file. Note that you can specify a custom GAzebo world simulation environment 
```
bash
ros2 launch my_robot launch_sim.launch.py world:=<path/to/your/saved/gazebo/world/file>
```

After launching the Simulation, open a separate terminal, and launch the control packake. Make sure that you have source the workspace on teh new terminal.
If you have joysticks connected then run the following command.
```
bash
ros2 launch my_robot joystick.launch.py
```
IF you are using a keyboard to control the robot then use the following command. Use teleop_twist_keyboard package but remapp the /cmd_vel to /diff_cont/cmd_vel_unstamped (The velocity command topic the robot subscribes to)
```
bash
ros2 run teleop_twist_keyboard teleop_twist_keyboard --ros-args -r /cmd_vel:=/diff_cont/cmd_vel_unstamped
```

**MAPPING**

To start mapping now, open a separate terminal and source the Workspace. 
after making sure the simulation Environment works well. Open a new terminal and source the Workspace again before running the following command.

We are going to use ```slam_toolbox``` package. It has multiple executables, the one used here will be online asynchronous. 

For smooth running, we are going to pass a custom params file. When mapping make sure the '''mode''' in the '''mapper_params_online_async.yaml''' file is set to '''mapping'''
```
bash
# run the command to start mapping services with a custom params file
ros2 launch slam_toolbox online_async_launch.py slam_params_file:=<path/to/root/directory>/src/my_robot/config/mapper_params_online_async.yaml
```
Open Rviz and make sure to add the relevant Nodes (```LaseScan```, ```RobotModel```, ```Map``` ) for visualizations.

<img width="3840" height="1783" alt="Screenshot 2026-06-12 145413" src="https://github.com/user-attachments/assets/f531422f-5a0f-4557-b2ae-3ef8ce335d9d" />

After the whole environment is mapped, Under the Panels menu, add the slam_toolbox panel. USe the pannel to save the map and serializa the map for future use in Autonomous navigation

**AUTONOMOUS NAVIGATION**

To start navigating the space autonomously, repeat the Robot launching and controls launching sequences. 

After The robot and Robot controls are launched. We need to launch the slam_toolbox's '''online_async_launch.py''' with our custom parameters file. The following parameters have to be changed befire launching it in localization mode.
'''mode''' has to be changed from '''mapping''' to '''localization'''
'''map_start_at_dock''' has to be '''true'''
'''map_file_name''' has to be The absolute path to the saved '''.serial''' map file (without the extension)

After making the changes to the '''mapper_params_online_async.yaml''' file then launch the slam_toolbox to make the saved map readily available. 
Run the following command
```
bash
# run the command to start mapping services with a custom params file
ros2 launch slam_toolbox online_async_launch.py slam_params_file:=<path/to/root/directory>/src/my_robot/config/mapper_params_online_async.yaml
```

Lastly, launch the navigation Nav2 package with a '''use_sim_time''' flag set to '''true''' to help us with the path planning within the space in simulation mode. run the following command.
```
bash
# run the command to start mapping services with a custom params file
ros2 launch my_robot navigation_launch.py use_sim_time:=true
```

Open Rviz and make sure to add the relevant Nodes (```LaseScan```, ```RobotModel```, ```Map``` ) for visualizations.

To give the goal Pose to the Robot use the 2d Goal Pose optinos in the RVIZ menu and select a goal point and orientation by clicking and dragging towards a direction. 


























