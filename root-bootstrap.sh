# L-NIC Chipyard CentOS configuration

# Expand the file system to use the full disk size
yum install -y cloud-utils-growpart
growpart /dev/sda 1
xfs_growfs /

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
# Install NFS client dependencies
yum -y install nfs-utils nfs-utils-lib
yum -y install tcl
# Install some extra utils for using Synopsys VCS
yum -y install libpng12-devel libXScrnSaver
yum -y install bc
yum -y install time
# Deps for Synopsys DC
yum -y install compat-libtiff3
yum -y install libmng-1.0.10-14.el7.x86_64
yum -y install libpng12-1.2.50-10.el7.x86_64
# X11 tools
yum install -y xorg-x11-server-Xorg xorg-x11-xauth xorg-x11-apps
# Additional tools
yum -y install net-tools
yum -y install gtkwave

# Upgrade to a modern git and make
sudo yum -y update
sudo yum -y remove git*
sudo yum -y install https://packages.endpoint.com/rhel/7/os/x86_64/endpoint-repo-1.7-1.x86_64.rpm
sudo yum -y install git
echo 'source /opt/rh/devtoolset-8/enable' >> /home/vagrant/.bashrc
source /opt/rh/devtoolset-8/enable

# Install pcap support
sudo yum -y install libpcap-devel

# Verilator install
cd /home/vagrant
git clone https://github.com/verilator/verilator
cd verilator
git checkout stable
autoconf
./configure
make -j8
sudo make install

# Fix python 2 and install testbench dependencies
sudo yum -y install epel-release
sudo yum -y install python26

# Simulator Network Interface Configuration
sudo touch /usr/local/bin/start-tap-devices.sh
sudo chown vagrant /usr/local/bin/start-tap-devices.sh
sudo chmod +x /usr/local/bin/start-tap-devices.sh
echo "sudo ip tuntap add mode tap dev tap0 user vagrant" >> /usr/local/bin/start-tap-devices.sh
echo "sudo ip link set tap0 up" >> /usr/local/bin/start-tap-devices.sh
echo "sudo ip addr add 192.168.1.1/24 dev tap0" >> /usr/local/bin/start-tap-devices.sh
echo "@reboot /usr/local/bin/start-tap-devices.sh" | sudo crontab -u vagrant -
