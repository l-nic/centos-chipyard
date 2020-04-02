#!/usr/bin/env bash

# Expand the file system to use the full disk size
yum install -y cloud-utils-growpart
growpart /dev/sda 1
xfs_growfs /

# Initial dependency configuration (from chipyard page)
yum groupinstall -y "Development tools"
yum install -y gmp-devel mpfr-devel libmpc-devel zlib-devel vim git java java-devel
curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
yum install -y sbt texinfo gengetopt
yum install -y expat-devel libusb1-devel ncurses-devel cmake "perl(ExtUtils::MakeMaker)"
# deps for poky
yum install -y python36 patch diffstat texi2html texinfo subversion chrpath git wget
# deps for qemu
yum install -y gtk3-devel
# deps for firemarshal
yum install -y python36-pip python36-devel rsync libguestfs-tools makeinfo expat ctags
# Install GNU make 4.x (needed to cross-compile glibc 2.28+)
yum install -y centos-release-scl
yum install -y devtoolset-8-make
# install DTC
yum install -y dtc

# Upgrade to a modern git and make
yum -y update
yum -y remove git*
yum -y install  https://centos7.iuscommunity.org/ius-release.rpm
yum -y install  git2u-all
echo 'source /opt/rh/devtoolset-8/enable' >> /home/vagrant/.bashrc
source /opt/rh/devtoolset-8/enable

# Fix python 2 and install testbench dependencies
yum -y install python26 python-pip
pip install --upgrade pip
pip install scapy pandas

# Simulator Network Interface Configuration
touch /usr/local/bin/start-tap-devices.sh
chown vagrant /usr/local/bin/start-tap-devices.sh
echo "sudo ip tuntap add mode tap dev tap0 user vagrant" >> /usr/local/bin/start-tap-devices.sh
echo "sudo ip link set tap0 up" >> /usr/local/bin/start-tap-devices.sh
echo "sudo ip addr add 192.168.1.1/24 dev tap0" >> /usr/local/bin/start-tap-devices.sh
chmod +x /usr/local/bin/start-tap-devices.sh
echo "@reboot /usr/local/bin/start-tap-devices.sh" | sudo crontab -u vagrant -
