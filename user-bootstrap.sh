# L-NIC Chipyard CentOS configuration

# Clone and initialize the lnic chipyard repo
cd /home/vagrant
git clone https://github.com/l-nic/chipyard.git
cd chipyard
git checkout lnic-dev
./scripts/init-submodules-no-riscv-tools.sh
export MAKEFLAGS=-j8
./scripts/build-toolchains.sh

# Configure toolchain paths
echo 'source /home/vagrant/chipyard/env.sh' >> /home/vagrant/.bashrc
echo 'export SNPSLMD_LICENSE_FILE=27000@cadlic0.stanford.edu' >> /home/vagrant/.bashrc
