#!/bin/bash

#update the system 
sudo apt-get update \
sudo apt-get upgrade \

#this command installs developer tools
sudo apt-get install build-essential cmake unzip pkg-config \

#install opencv specific tools
sudo apt-get install libjpeg-dev libpng-dev libtiff-dev \
sudo apt-get install libjpeg-dev libpng-dev libtiff-dev \
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
sudo apt-get install libxvidcore-dev libx264-dev \

#install gtk
sudo apt-get install libgtk-3-dev \

#libraries to optimize opencv functions
sudo apt-get install libatlas-base-dev gfortran \

#install python 3 headers and libraries
sudo apt-get install python3-dev \

#downloads opencv.git and opencv_contrib.git
cd ~
wget -O opencv.zip https://github.com/opencv/opencv/archive/3.4.1.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/3.4.1.zip
#unzip both folders
unzip opencv.zip
unzip opencv_contrib.zip

#configures python and installs python installer
wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py

#installs virtual environment
sudo pip install virtualenv virtualenvwrapper
sudo rm -rf ~/get-pip.py ~/.cache/pip
echo -e "\n# virtualenv and virtualenvwrapper" >> ~/.bashrc
echo "export WORKON_HOME=$HOME/.virtualenvs" >> ~/.bashrc
echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc
source ~/.bashrc
mkvirtualenv cv -p python3
workon cv

#installs numpy
pip install numpy
workon cv

#builds opencv
cd ~/opencv-3.4.1/
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_PYTHON_EXAMPLES=ON \
	-D INSTALL_C_EXAMPLES=OFF \
	-D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-3.4.1/modules \
	-D PYTHON_EXECUTABLE=~/.virtualenvs/cv/bin/python \
	-D BUILD_EXAMPLES=ON ..

#makes the files
NPROC=$(nproc)
make -j($NPROC)

#installs the files
sudo make install
sudo ldconfig

cd /usr/local/lib/python3.6/site-packages/
sudo mv cv2.cpython-36m-x86_64-linux-gnu.so cv2.so
cd ~/.virtualenvs/cv/lib/python3.6/site-packages/
ln -s /usr/local/lib/python3.6/site-packages/cv2.so cv2.so

#cleans up a bit
cd ~
rm opencv.zip opencv_contrib.zip
rm -rf opencv-3.4.1 opencv_contrib-3.4.1

