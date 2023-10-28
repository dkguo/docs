
## Network Setup
1. After mounting the robot steadily, here are what you need:
	1) NUC
	2) ip port extender
	3) 3x Ethernet cables

2. Connect robot (X5) to any computer with ethernet cable
	1) Connect with auto DHCP
	2) Go to robot.franka.de, first-time-use page will come up
	3) Follow instructions to update robot firmware from franka.world. 
		Robot is offline (not connected to internet) in this case.
	4) Keep everything as default setting and finish first time use settings
	5) Go to SETTINGS->NETWORK on robot.franka.de page
	6) Unclick DHCP Client box. Set Controller (C2) address and netmask, 
		which should be completely different from robot, such as 
		address 10.10.0.100, netmask 255.0.0.0.
	7) Apply settings. Disconnect the computer from the robot. Remove the 
		ethernet cable from the robot.

3. Connect NUC and your machine to port extender, port extender to Controller (C2) 
	with ethernet cables
	1) Set static IP address for NUC and your machine, such as 
		address 10.10.0.2 and 10.10.0.1, netmask 255.0.0.0
	2) Go to controller address (10.10.0.100). Franka Desk should be accessiable.

## NUC Realtime Kernel Setup
Follow instructions on https://frankaemika.github.io/docs/installation_linux.html#setting-up-the-real-time-kernel

Notes:
1. Find closest version. 5.15.0 is written as 5.15 on the website. 5.15-rt17 worked.
2. You don't need to verify the integrity step.
3. After deleting Additional X.509 keys for default system keyring in TUI, you may 
	still encounter error in compling. "No rule to make target 'debian/canonical-revoked-certs.pem', needed by 'certs/x509_revocation_list'"  
	Run `scripts/config --disable SYSTEM_REVOCATION_KEYS` based on
	https://askubuntu.com/a/1386977 worked.

## Polymetis Installation
Same on NUC and your machine. Follow the instructions on https://facebookresearch.github.io/fairo/polymetis/installation.html#from-source  
**Build Polymetis from source with latest version of libfranka.**

Notes:
1. For creating environment, use mamba instead of conda.  
	```
	# in (base)
	conda install -c conda-forge mamba
	```
	Solving environment in base takes long time.

2. Build libfranka from source. Use fr3-develop branch for FR3 robot.

		cd polymetis/src/clients/franka_panda_client/third_party/
		rm -rf libfranka
		git clone https://github.com/frankaemika/libfranka.git
		cd libfranka
		git checkout fr3-develop
		git submodule update --init --recursive

		mkdir build
		cd build
		cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTS=OFF -DBUILD_EXAMPLES=OFF ..
		cmake --build .

	Following bug is already fixed in the latest version of libfranka. \
	Make sure in `./fairo/polymetis/polymetis/src/clients/franka_panda_client/third_party/libfranka/common/include/research_interface/robot/service_types.h`  
	Line 17 `constexpr Version kVersion = 6;` not `5` for FR3 robot.

3. Add `using std::size_t;` to `./fairo/polymetis/polymetis/torch_isolation/include/torch_server_ops.hpp` if you encounter error `'size_t' has not been declared`.


## Polymetis Usage
Follow instructions on https://facebookresearch.github.io/fairo/polymetis/usage.html 

Notes:
1. Change robot_ip. It should show `[info] Connected.` on NUC for successful connection.  
	```
	launch_robot.py robot_client=franka_hardware robot_client.executable_cfg.robot_ip=10.10.0.100
	```
	For FR3 robot, you need to change the limits.
	```
	launch_robot.py robot_client=franka_hardware robot_client.executable_cfg.robot_ip=10.10.0.100 robot_client.executable_cfg.limits.cartesian_pos_upper="[1.0, 1.0, 1.0]" robot_client.executable_cfg.limits.cartesian_pos_lower="[-1.0, -1.0, -1.0]" robot_client.executable_cfg.limits.joint_pos_upper="[2.6437, 1.6837, 2.8007, -0.2518, 2.7065, 4.4169, 2.9159]" robot_client.executable_cfg.limits.joint_pos_lower="[-2.6437, -1.6837, -2.8007, -2.9421, -2.7065, 0.6445, -2.9159]" robot_client.executable_cfg.limits.joint_vel="[2.52, 2.52, 2.52, 2.52, 5.16, 4.08, 5.16]" robot_client.executable_cfg.limits.elbow_vel="2.520" robot_client.metadata_cfg.default_Kq="[480.0, 720.0, 600.0, 600.0, 420.0, 300.0, 200.0]" robot_client.metadata_cfg.default_Kqd="[30.0, 30.0, 30.0, 30.0, 15.0, 15.0, 15.0]" robot_client.executable_cfg.safety_controller.is_active="false"
	```

2. Change robot_ip for `launch_gripper`  
	`launch_gripper.py gripper=franka_hand gripper.executable_cfg.robot_ip=10.10.0.100`
