# L-NIC Chipyard CentOS configuration

# Python pip configuration
cd /home/vagrant
curl "https://bootstrap.pypa.io/pip/2.7/get-pip.py" -o "get-pip.py"
python get-pip.py
python -m pip install scapy pandas
python -m pip install 'fabric<2.0'

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

# scala vim syntax highlighting
mkdir -p ~/.vim/{ftdetect,indent,syntax} && for d in ftdetect indent syntax ; do wget -O ~/.vim/$d/scala.vim https://raw.githubusercontent.com/derekwyatt/vim-scala/master/$d/scala.vim; done

# Set up remaining local firesim dependencies
cd /home/vagrant/chipyard/software/local_firesim/PcapPlusPlus
./configure-linux --default
make -j8
sudo make install

cd /home/vagrant/chipyard/sims/firesim
git submodule update --init sim/firesim-lib/src/main/cc/lib/libdwarf
git submodule update --init sim/firesim-lib/src/main/cc/lib/elfutils
./scripts/build-libelf.sh
./scripts/build-libdwarf.sh
sudo ldconfig

