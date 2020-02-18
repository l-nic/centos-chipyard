# L-NIC Chipyard CentOS configuration

# Initial dependency configuration (from chipyard page)
sudo yum groupinstall -y "Development tools"
sudo yum install -y gmp-devel mpfr-devel libmpc-devel zlib-devel vim git java java-devel
curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
sudo yum install -y sbt texinfo gengetopt
sudo yum install -y expat-devel libusb1-devel ncurses-devel cmake "perl(ExtUtils::MakeMaker)"
# deps for poky
sudo yum install -y python36 patch diffstat texi2html texinfo subversion chrpath git wget
# deps for qemu
sudo yum install -y gtk3-devel
# deps for firemarshal
sudo yum install -y python36-pip python36-devel rsync libguestfs-tools makeinfo expat ctags
# Install GNU make 4.x (needed to cross-compile glibc 2.28+)
sudo yum install -y centos-release-scl
sudo yum install -y devtoolset-8-make
# install DTC
sudo yum install -y dtc

# Upgrade to a modern git and make
sudo yum -y update
sudo yum -y remove git*
sudo yum -y install  https://centos7.iuscommunity.org/ius-release.rpm
sudo yum -y install  git2u-all
echo 'source /opt/rh/devtoolset-8/enable' >> /home/vagrant/.bashrc
source /opt/rh/devtoolset-8/enable

# Fix python 2 and install testbench dependencies
sudo yum -y install python26 python-pip
sudo pip install --upgrade pip
sudo pip install scapy pandas

# Clone and initialize the lnic chipyard repo
cd /home/vagrant
git clone https://github.com/l-nic/chipyard.git
cd chipyard
git checkout lnic-dev
./scripts/init-submodules-no-riscv-tools.sh
export MAKEFLAGS=-j16
./scripts/build-toolchains.sh

# Create local vcs copy
mkdir /home/vagrant/local_vcs
unzip /vagrant/local_vcs.zip -d /home/vagrant/local_vcs/

# Configure toolchain paths
echo 'source /home/vagrant/chipyard/env.sh' >> /home/vagrant/.bashrc
echo 'export VCS_HOME=/home/vagrant/local_vcs' >> /home/vagrant/.bashrc
echo 'export PATH=PATH:/home/vagrant/local_vcs/bin' >> /home/vagrant/.bashrc
echo 'export SNPSLMD_LICENSE_FILE=27000@cadlic0.stanford.edu' >> /home/vagrant/.bashrc
sudo ln -s /home/vagrant/local_vcs/linux64 /home/vagrant/local_vcs/linux
sudo ln -s /home/vagrant/chipyard/riscv-tools-install/lib/libfesvr.a /lib/libfesvr.a

# Simulator Network Interface Configuration
sudo touch /usr/local/bin/start-tap-devices.sh
sudo chown $USER /usr/local/bin/start-tap-devices.sh
echo "sudo ip tuntap add mode tap dev tap0 user vagrant" >> /usr/local/bin/start-tap-devices.sh
echo "sudo ip link set tap0 up" >> /usr/local/bin/start-tap-devices.sh
echo "sudo ip addr add 192.168.1.1/24 dev tap0" >> /usr/local/bin/start-tap-devices.sh
echo "@reboot /usr/local/bin/start-tap-devices.sh" | sudo crontab -u vagrant -
