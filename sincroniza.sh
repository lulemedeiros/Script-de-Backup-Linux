#!/bin/bash

set -xueo pipefail

sudo dnf -y install fedora-workstation-repositories

sudo dnf update -y

sudo dnf config-manager --set-enabled google-chrome
sudo dnf -y install google-chrome-stable
sudo dnf -y install numlockx.x86_64
sudo dnf -y install remmina
sudo dnf -y install xpad.x86_64
sudo dnf -y install htop.x86_64
sudo dnf -y install git
sudo dnf -y install sl
sudo dnf -y install cowsay
sudo dnf -y install xcowsay.x86_64
sudo dnf -y install toilet.x86_64
sudo dnf -y install xrdp
sudo dnf -y install xorgxrdp
sudo dnf -y install filezilla.x86_64
sudo dnf -y install figlet.x86_64
sudo dnf -y install fish
sudo dnf -y install gpick.x86_64
sudo dnf -y install tilix.x86_64
sudo dnf -y install gnome-software.x86_64
sudo dnf -y install libreoffice-langpack-pt-BR.x86_64
sudo dnf -y install libreoffice-icon-theme-papirus.noarch
#sudo rpm --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
#sudo printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=gitlab.com_paulcarroty_vscodium_repo\nbaseurl=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg" |sudo tee -a /etc/yum.repos.d/vscodium.repo
#sudo dnf -y install codium

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update
sudo dnf -y install code

sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -y install vlc

sudo rpm --import https://packagecloud.io/shiftkey/desktop/gpgkey
sudo sh -c 'echo -e "[shiftkey]\nname=GitHub Desktop\nbaseurl=https://packagecloud.io/shiftkey/desktop/el/7/\$basearch\nenabled=1\ngpgcheck=0\nrepo_gpgcheck=1\ngpgkey=https://packagecloud.io/shiftkey/desktop/gpgkey" > /etc/yum.repos.d/shiftkey-desktop.repo'
sudo dnf -y install github-desktop

sudo dnf -y install virt-manager bridge-utils libvirt virt-install qemu-kvm
sudo dnf -y install virt-top libguestfs-tools

sudo dnf -y install -y python3.x86_64 \
    python-crypto \
    python-devel \
    python-dns \
    python-markdown \
    python2-gpg \
    python2-tkinter.x86_64 \
    python3-tkinter.x86_64 \
    python3 \
    python3-crypto \
    python3-devel \
    python3-dns \
    python3-gpg \
    python3-markdown \
    python3-ldap3.noarch \
    python-vlc \

sudo systemctl start xrdp
sudo systemctl enable xrdp

sudo systemctl start libvirtd
sudo systemctl enable libvirtd

sudo firewall-cmd --add-port=3389/tcp --permanent
sudo firewall-cmd --reload

sudo dnf -y clean all
