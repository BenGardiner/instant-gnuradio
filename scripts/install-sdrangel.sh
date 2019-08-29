sudo apt-get -y install \
	 vim \
	 openssh-server \
	 iputils-ping \
	 traceroute \
	 iproute2 \
	 nmap \
    net-tools \
    python-requests \
    python-flask

# Install base build packages dependencies - step 1
sudo apt-get -y install \
    git \
    cmake \
    g++ \
    pkg-config \
    autoconf \
    automake \
    libtool \
    libfftw3-dev \
    libusb-1.0-0-dev \
    libusb-dev

# Install base build packages dependencies - Qt5
sudo apt-get -y install \
    qtbase5-dev \
    qt5-default
sudo apt-get -y install \
    qtchooser \
    libqt5multimedia5-plugins \
    qtmultimedia5-dev \
    libqt5websockets5-dev
sudo apt-get -y install \
    qttools5-dev \
    qttools5-dev-tools
sudo apt-get -y install \
    libqt5opengl5-dev

# Install base build packages dependencies - Boost
sudo apt-get -y install \
    libpython2.7 libpython2.7-dev
sudo apt-get -y install \
    libpython3-dev
sudo apt-get -y install \
    libpython3.6-dev
sudo apt-get -y install \
    librdmacm1
sudo apt-get -y install \
    libboost-all-dev

# Install base build packages dependencies - the rest
sudo apt-get -y install \
    libasound2-dev \
    pulseaudio \
    libopencv-dev \
    libxml2-dev \
    bison \
    flex \
    ffmpeg \
    libavcodec-dev \
    libavformat-dev \
    libopus-dev \
    libavahi-client-dev

# Install compiled libraries dependencies
# Codec2
sudo apt-get -y install libspeexdsp-dev \
    libsamplerate0-dev
# Perseus
sudo apt-get -y install xxd
# XTRX, UHD
sudo apt-get -y install python-cheetah \
    python-mako

mkdir -p ~/sdrangel/{src,build,src}
nb_cores=4
cd ~/sdrangel/src
# CM256cc
git clone https://github.com/f4exb/cm256cc.git \
    && cd cm256cc \
    && git reset --hard f21e8bc \
    && mkdir build; cd build \
    && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=~/sdrangel/install/cm256cc .. \
    && make -j${nb_cores} install || exit 1

# MBElib
cd ~/sdrangel/src
git clone https://github.com/szechyjs/mbelib.git \
    && cd mbelib \
    && git reset --hard e2d84c1 \
    && mkdir build; cd build \
    && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=~/sdrangel/install/mbelib .. \
    && make -j${nb_cores} install || exit 1

# SerialDV
cd ~/sdrangel/src
git clone https://github.com/f4exb/serialDV.git \
    && cd serialDV \
    && git reset --hard d5830fae715f4acffa2acec33539c3a11c17a1c9 \
    && mkdir build; cd build \
    && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=~/sdrangel/install/serialdv .. \
    && make -j${nb_cores} install || exit 1

# DSDcc
cd ~/sdrangel/src
git clone https://github.com/f4exb/dsdcc.git \
    && cd dsdcc \
    && git reset --hard  b8ecee6c00a45c1ce6cf7fa51d6cc433d6e88948 \
    && mkdir build; cd build \
    && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=~/sdrangel/install/dsdcc -DUSE_MBELIB=ON -DLIBMBE_INCLUDE_DIR=~/sdrangel/install/mbelib/include -DLIBMBE_LIBRARY=~/sdrangel/install/mbelib/lib/libmbe.so -DLIBSERIALDV_INCLUDE_DIR=~/sdrangel/install/serialdv/include/serialdv -DLIBSERIALDV_LIBRARY=~/sdrangel/install/serialdv/lib/libserialdv.so .. \
    && make -j${nb_cores} install || exit 1

# Codec2
cd ~/sdrangel/src
git clone https://github.com/drowe67/codec2.git \
    && cd codec2 \
    && git reset --hard 76a20416d715ee06f8b36a9953506876689a3bd2 \
    && mkdir build_linux; cd build_linux \
    && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=~/sdrangel/install/codec2 .. \
    && make -j${nb_cores} install || exit 1

cd ~/sdrangel/src
repository="https://github.com/f4exb/sdrangel.git"
branch="master"
GIT_SSL_NO_VERIFY=true git clone ${repository} -b ${branch} sdrangel || exit 1

# Create a base image for all GUIs
mkdir -p ~/sdrangel/src/sdrangel/build
cd ~/sdrangel/src/sdrangel/build
cmake -Wno-dev -DDEBUG_OUTPUT=ON -DRX_SAMPLE_24BIT=ON -DBUILD_SERVER=OFF -DMIRISDR_DIR=~/pybombs -DAIRSPY_DIR=~/pybombs -DAIRSPYHF_DIR=~/pybombs -DBLADERF_DIR=~/pybombs -DHACKRF_DIR=~/pybombs -DRTLSDR_DIR=~/pybombs -DLIMESUITE_DIR=~/pybombs -DIIO_DIR=~/pybombs -DCM256CC_DIR=~/sdrangel/install/cm256cc -DDSDCC_DIR=~/sdrangel/install/dsdcc -DSERIALDV_DIR=~/sdrangel/install/serialdv -DMBE_DIR=~/sdrangel/install/mbelib -DCODEC2_DIR=~/sdrangel/install/codec2 -DPERSEUS_DIR=~/sdrangel/install/libperseus -DXTRX_DIR=~/pybombs -DSOAPYSDR_DIR=~/pybombs -DCMAKE_INSTALL_PREFIX=~/sdrangel/install/sdrangel .. \
    && make -j${nb_cores} install || exit 1


