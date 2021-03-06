#!/bin/bash

#Check script is running as a regular user.
if [[ $EUID -ne 0 ]]; then
  echo "Script is running as user.. Good!" 1>&2
else
  echo "Script is running as root.. Please run this script as a regular user with sudo rights." 1>&2
  exit 1
fi

#Check this user has sudo rights.
CAN_I_RUN_SUDO=$(sudo -n uptime 2>&1|grep "load"|wc -l)
if [ ${CAN_I_RUN_SUDO} -gt 0 ]
then
    echo "User has sudo rights.. Good!" 1>&2
else
    echo "User does not have sudo rights.. Please run this script as a regular user with sudo rights." 1>&2
    exit 1
fi

echo "Starting..."

# Check if 'config' directory exists or not.
if [ ! -d "configs" ]; then
  echo "'configs' directory not found. Exiting.." 1>&2
  exit 1
else
  echo "'configs' directory found! Continuing.." 1>&2
fi
#Check if the files in there exist.
if [ ! -f "configs/.Xdefaults" ]; then
  echo "'.Xdefaults' config file was not found. Exiting.." 1>&2
  exit 1
else
  echo "'.Xdefaults' config file was found! Continuing.." 1>&2
fi
if [ ! -f "configs/.bash_profile" ]; then
  echo "'.bash_profile' config file was not found. Exiting.." 1>&2
  exit 1
else
  echo "'.bash_profile' config file was found! Continuing.." 1>&2
fi
#Check if 'i3' config directory exists or not.
if [ ! -d "configs/i3" ]; then
  echo "'i3' config directory not found. Exiting.." 1>&2
  exit 1
else
  echo "'i3' config directory found! Continuing.." 1>&2
fi
if [ ! -f "configs/i3/config" ]; then
  echo "'i3/config' config file was not found. Exiting.." 1>&2
  exit 1
else
  echo "'i3/config' config file was found! Continuing.." 1>&2
fi
if [ ! -f "configs/i3/i3blocks.conf" ]; then
  echo "'i3/i3blocks.conf' config file was not found. Exiting.." 1>&2
  exit 1
else
  echo "'i3/i3blocks.conf' config file was found! Continuing.." 1>&2
fi
if [ ! -f "configs/i3/exit_menu.sh" ]; then
  echo "'i3/exit_menu.sh' config file was not found. Exiting.." 1>&2
  exit 1
else
  echo "'i3/exit_menu.sh' config file was found! Continuing.." 1>&2
fi
if [ ! -f "configs/.vimrc" ]; then
  echo "'.vimrc' config file was not found. Exiting.." 1>&2
  exit 1
else
  echo "'.vimrc' config file was found! Continuing.." 1>&2
fi
if [ ! -f "configs/.xinitrc" ]; then
  echo "'.xinitrc' config file was not found. Exiting.." 1>&2
  exit 1
else
  echo "'.xinitrc' config file was found! Continuing.." 1>&2
fi
if [ ! -f "configs/networking.service" ]; then
  echo "'networking.service' config file was not found. Exiting.." 1>&2
  exit 1
else
  echo "'networking.service' config file was found! Continuing.." 1>&2
fi
#Check if 'Pictures' directory exists.
if [ ! -d "Pictures" ]; then
  echo "'Pictures' directory not found. Exiting.." 1>&2
  exit 1
else
  echo "'Pictures' directory found! Continuing.." 1>&2
fi
if [ ! -f "Pictures/wave-1913559.jpg" ]; then
  echo "'wave-1913559.jpg' was not found. Exiting.." 1>&2
  exit 1
else
  echo "'wave-1913559.jpg' was found! Continuing.." 1>&2
fi
#Check that there is a valid internet connection by checking 'http://google.com/'
echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "There is a valid internet connection (to 'http://google.com/'! Continuing.." 1>&2
else
    echo "No internet connection (to 'http://google.com/') was found. Exiting.." 1>&2
    exit 1
fi

sudo cp -r configs/sources.list /etc/apt/sources.list

clear

echo "Deleting potential apt lock files."
sudo rm -rf /var/lib/apt/lists/lock
sudo rm -rf /var/cache/apt/archives/lock
sudo rm -rf /var/lib/dpkg/lock
echo "Installing packages using apt (apt-get)."
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get update -y
sudo apt-get clean -y
sudo apt-get install -y aptitude bc git wget curl vim dosfstools ntfs-3g mtools aufs-tools btrfs-tools f2fs-tools hfsprogs hfsutils jfsutils nilfs-tools reiser4progs reiserfsprogs squashfs-tools xfsdump xfsprogs links ranger w3m rxvt-unicode zsh xorg xinit i3 i3lock i3status i3blocks suckless-tools feh rofi fonts-liberation fonts-dejavu fonts-ubuntu-font-family-console ttf-ubuntu-font-family fonts-font-awesome ubuntu-restricted-extras ubuntu-restricted-addons ffmpeg gparted lxappearance network-manager wpasupplicant wpagui cups vlc p7zip-full unrar rar build-essential redshift chromium-browser libreoffice gimp xarchiver software-properties-gtk steam transmission-gtk transmission-cli default-jdk qt5-default alsa-base alsa-utils pulseaudio pavucontrol libdvd-pkg libbluray1 wicd
sudo dpkg-reconfigure libdvd-pkg
sudo apt-get autoremove -y

sudo usermod -a -G vboxusers $USER

clear

echo "NOTE: You will still have to install your specific drivers yourself. (amd64-microcode, intel-microcode, nvidia-driver, etc.."
echo "Launch 'software-properties-gtk' (in Xorg) to assist you in driver installation."

clear

echo "Please set a root password (and remember it!)"
sudo passwd root

echo "Backing up previous config files to '~/configbackups/."
mkdir -p ~/configbackups/i3/
cp -r ~/.bash_profile ~/configbackups/.bash_profile
cp -r ~/.config/i3/* ~/configbackups/i3/
cp -r ~/.vimrc ~/configbackups/.vimrc
cp -r ~/.Xdefaults ~/configbackups/.Xdefaults
cp -r ~/.xinitrc ~/configbackups/.xinitrc
echo "Deleting potentially existing config files."
rm -rf ~/.Xdefaults
rm -rf ~/.bash_profile
rm -rf ~/.config/i3/
rm -rf ~/.vimrc
sudo rm -rf /root/.vimrc
rm -rf ~/.xinitrc
echo "Copying '.Xdefaults' rxvt-unicode config file to '~/.Xdefaults'"
cp -r configs/.Xdefaults ~/.Xdefaults
echo "Copying '.bash_profile' bash login config to '~/.bash_profile'"
cp -r configs/.bash_profile ~/.bash_profile
echo "Copying i3 config files to '~/.config/i3/'"
mkdir -p ~/.config/i3/
cp -r configs/i3/* ~/.config/i3/
echo "Copying '.vimrc' vim config file to '~/.vimrc' and to '/root/.vimrc'"
cp -r configs/.vimrc ~/.vimrc
sudo cp -r configs/.vimrc /root/.vimrc
echo "Copying '.xinitrc' xorg config file to '~/.xinitrc'"
cp -r configs/.xinitrc ~/.xinitrc
#Copy wallpaper over to '~/Pictures' and renme it as 'Wallpaper.jpg', so feh can use it as the wallpaper for i3.
## Wallpaper link: https://pixabay.com/en/wave-atlantic-pacific-ocean-huge-1913559/
mkdir -p ~/Pictures/
cp -r Pictures/wave-1913559.jpg ~/Pictures/Wallpaper.jpg

echo "Create user directories."
mkdir -p ~/Desktop/ ~/Documents/ ~/Downloads/ ~/Music/ ~/Public/ ~/Templates/ ~/Videos/ ~/.fonts ~/.icons ~/.themes

echo "Enabling and starting services."
sudo systemctl enable cups
sudo systemctl start cups
sudo systemctl enable networking
sudo systemctl start networking
sudo systemctl enable network-manager
sudo systemctl start network-manager
sudo systemctl enable wpa_supplicant
sudo systemctl start wpa_supplicant

echo "Restarting network connections. (Ethernet then WiFi.)"
sudo ifdown eno1
sudo ifup eno1
sudo ifdown wlo1
sudo ifup wlo1

# To fix long boot times.
echo "Disabling wait services."
sudo systemctl disable systemd-networkd-wait-online.service
sudo systemctl disable NetworkManager-wait-online.service

echo "Copying 'networking.service' config file to '/etc/systemd/system/network-online.target.wants/networking.service'.
su -c 'cp -r configs/networking.service /etc/systemd/system/network-online.target.wants/networking.service'

# Install screenfetch to '/usr/local/bin/' using 'git clone'.
echo "Setting up screenfetch (using 'git clone'.)"
git clone https://github.com/KittyKatt/screenfetch
sudo mv screenfetch/screenfetch-dev /usr/local/bin/screenfetch
sudo chmod +x /usr/local/bin/screenfetch

#Install wine.
echo "Installing wine.. (Using wine repo.)"
sudo dpkg --add-architecture i386
sudo add-apt-repository -y ppa:wine/wine-builds
sudo apt-get -y update
sudo apt-get install --install-recommends -y winehq-devel
# Set up 32bit wine prefix.
WINEARCH=win32 WINEPREFIX=~/.wine wine wineboot

echo "Setting zsh as the default shell for user: "$USER"."
chsh -s /bin/zsh

#Install VirtualBox extention pack.
#echo "Downloading and installing VirtualBox extention pack using 'curl' then 'vboxmanage'."
#curl http://download.virtualbox.org/virtualbox/5.0.24/Oracle_VM_VirtualBox_Extension_Pack-5.0.24.vbox-extpack -o Oracle_VM_VirtualBox_Extension_Pack-5.0.24.vbox-extpack
#sudo vboxmanage extpack install Oracle_VM_VirtualBox_Extension_Pack-5.0.24.vbox-extpack

echo "All done!"

sleep 4s

echo "Rebooting PC... Press Ctrl+C to cancel reboot operation."
sudo reboot
