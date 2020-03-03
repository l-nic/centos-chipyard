# L-NIC Chipyard CentOS configuration

# Clone and initialize the lnic chipyard repo
cd /home/vagrant
git clone https://github.com/l-nic/chipyard.git
cd chipyard
git checkout lnic-dev
./scripts/init-submodules-no-riscv-tools.sh
export MAKEFLAGS=-j8
./scripts/build-toolchains.sh

# # Create local vcs copy
# mkdir /home/vagrant/local_vcs
# unzip /vagrant/local_vcs.zip -d /home/vagrant/local_vcs/

# Configure toolchain paths
echo 'source /home/vagrant/chipyard/env.sh' >> /home/vagrant/.bashrc
#echo 'export VCS_HOME=/home/vagrant/local_vcs' >> /home/vagrant/.bashrc
#echo 'export PATH=$PATH:/home/vagrant/local_vcs/bin' >> /home/vagrant/.bashrc
echo 'export SNPSLMD_LICENSE_FILE=27000@cadlic0.stanford.edu' >> /home/vagrant/.bashrc
#sudo ln -s /home/vagrant/local_vcs/linux64 /home/vagrant/local_vcs/linux
#sudo ln -s /home/vagrant/chipyard/riscv-tools-install/lib/libfesvr.a /lib/libfesvr.a

