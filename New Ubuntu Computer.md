## Linux 22.04 LTS
Use 22.04 LTS instead of 20.04 LTS. 20.04 LTS does not have updated Wi-Fi driver.
```
sudo apt update
sudo apt upgrade
sudo apt install zsh git curl gcc make pkg-config libglvnd-dev openssh-server barrier gnome-tweaks chrome-gnome-shell
```

## Network Setup
### Wired Network
Address: 10.10.0.X \
Netmask: 255.0.0.0

### SSH
```
sudo apt install openssh-server
```


## Terminal
### Oh My Zsh
Install Zsh, Git, and Curl
```
sudo apt install zsh git curl
```
Install oh-my-zsh
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
Change default shell to zsh. **Log out** to take effect.
```
chsh -s $(which zsh)
```

Change .zshrc file to Linux Ubuntu Version

Add ~/.oh-my-zsh/themes/guodk.zsh-theme

Install zsh-auto-suggestions
```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

### Anaconda
Follow https://docs.anaconda.com/free/anaconda/install/linux.html

### GitHub ssh key
1. Check existing ssh key [refer to this link](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/checking-for-existing-ssh-keys)

2. Generate new ssh key [refer to this link](
    https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
    ```
    ssh-keygen -t ed25519 -C "code@guodk.com"
    # Hit two enter, you don't need passphrase.
    ```
    Add to ssh-agent
    ```
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519   # change to your key name
    ```
3. Add ssh key to GitHub [refer to this link](
    https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account#adding-a-new-ssh-key-to-your-account)
    ```
    cat ~/.ssh/id_ed25519.pub
    ```
    Copy the output and paste to GitHub. \
    Add to https://github.com/settings/keys

#### Using Multiple Git Accounts and SSH Keys
```
nano ~/.ssh/config
```
Add the following:
```
Host github.com-2
  HostName github.com
  User git
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_<second_id>
```
When cloning a repository, use the following:
```
git clone git@github.com-2:{link}.git
```


## NVIDIA CUDA and Driver
### NVIDIA Driver
```
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
sudo apt install nvidia-driver-XXX
```
OR\
Go to Software & Updates -> Additional Drivers -> Select NVIDIA driver

### CUDA in root
Follow https://developer.nvidia.com/cuda-downloads \
Use deb (local) and install driver following instructions after toolkit is installed. \
Add cuda path to .zshrc (already included in Linux .zshrc file)

### CUDA by Conda
Just install `cudatoolkit` in conda environment


## Apps
### Barrier
```
sudo apt install barrier
```
Certificate will show up when typing server IP \
Switch Ctrl and Super in server settings \
Add barrier to Startup Applications

### Syncthing
1. Follow https://apt.syncthing.net/ to install
    ```
    sudo curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
    sudo apt-get update
    sudo apt-get install syncthing
    ```
2. Start syncthing and setup by adding new device
3. Add `syncthing` to Startup Applications

### Variety Wallpaper Changer
Install newest version from PPA:
```
sudo add-apt-repository ppa:variety/stable
sudo apt update && sudo apt install variety
```
### Night Mode Switcher and Gnome Tweaks
```
sudo apt install gnome-tweaks chrome-gnome-shell
```
Install Night Mode Switcher: https://extensions.gnome.org/extension/2236/night-theme-switcher/ \
Change GTK Theme, Day variant to Adwaita, Night variant to Adwaita-dark. This will let terminal theme follow dark mode as well.

Refer to: https://itsfoss.com/gnome-shell-extensions/

### PyCharm
https://www.jetbrains.com/help/pycharm/installation-guide.html#snap-install-tar \
Install standalone to  `/opt/` \
To create a desktop entry, from the main menu, click Tools -> Create Desktop Entry\
To give PyCharm access to update itself, run `sudo chmod -R 777 /opt/pycharm-community-*/`

### VS Code
Download .deb file from https://code.visualstudio.com/download 
```
sudo apt install ./<file>.deb
```

### MeshLab
1. Install FlatPak (https://flatpak.org/setup/Ubuntu)
    ```
    sudo apt install flatpak
    sudo apt install gnome-software-plugin-flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    ```
2. Install MeshLab
    ```
    flatpak install flathub net.meshlab.MeshLab
    ```
3. Restart based on prompt from flatpak so MeshLab can be found in the application menu

### Open3D-viewer
```
sudo apt install open3d-gui
```

### TimeMachine via SMB
https://github.com/mbentley/docker-timemachine 

```
docker run -d --restart=always \
  --name timemachine \
  --net=host \
  -e TM_USERNAME="timemachine" \
  -e TM_GROUPNAME="timemachine" \
  -e PASSWORD="timemachine" \
  -e TM_UID="1000" \
  -e TM_GID="1000" \
  -e SET_PERMISSIONS="false" \
  -e VOLUME_SIZE_LIMIT="0" \
  -v /path/on/host/to/backup/to/for/timemachine:/opt/timemachine \
  --tmpfs /run/samba \
  mbentley/timemachine:smb
```

#### Mount Hard Drive Automatically
Go to Disks app -> Select Hard Drive -> Edit Mount Options -> Turn off User Session Defaults -> Turn on Mount at system startup

## ROS for Ubuntu 20.04
### ROS 1 Noetic
http://wiki.ros.org/noetic/Installation/Ubuntu

### ROS 2 Humble
https://docs.ros.org/en/humble/Installation/Alternatives/Ubuntu-Development-Setup.html

* Instead of installing ROS at ~/ros2_humble, install at /opt/ros/humble. Use `sudo` for all commands.

* During step of `colcon build --symlink-install`, compiling may fail for `rclpy`. https://answers.ros.org/question/403182/colcon-build-errors-failed-rclpy-828s-exited-with-code-2/ \
  Solution: `sudo python -m pip install pybind11-global` and \
  `sudo colcon build --packages-select rclpy --symlink-install --cmake-args -DPYTHON_EXECUTABLE=/usr/bin/python -Dpybind11_DIR=/usr/local/lib/python3.8/dist-packages/pybind11/share/cmake/pybind11`