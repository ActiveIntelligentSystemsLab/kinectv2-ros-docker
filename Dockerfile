FROM nvcr.io/nvidia/l4t-base:r32.2.1

WORKDIR /root
# avoid blocking in installation of tzdata
ENV DEBIAN_FRONTEND=noninteractive
ARG ROS_DISTRO=melodic

RUN apt-get update && apt install -y \
  wget \
  lsb-release \
  net-tools \
  git \
  build-essential \
  cmake \
  pkg-config \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*rm 

# Install ROS
#  Add key
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

#
# Install necessary packages
#
RUN apt-get update && apt-get install -y \
  libusb-1.0-0-dev \
  libturbojpeg \
  libturbojpeg0-dev \
  libjpeg-turbo8-dev \
  libglfw3-dev \
  libopenni2-dev \
  freeglut3-dev \
  uuid-dev \
  libsdl2-dev \
  usbutils \
  python-catkin-tools \
  python-rosdep \
  alsa-utils \
  ros-${ROS_DISTRO}-ros-core \
  ros-${ROS_DISTRO}-vision-opencv \
  ros-${ROS_DISTRO}-nodelet-core \
  ros-${ROS_DISTRO}-perception-pcl \
  ros-${ROS_DISTRO}-compressed-depth-image-transport \
  ros-${ROS_DISTRO}-compressed-image-transport \
  ros-${ROS_DISTRO}-geometry \
  ros-${ROS_DISTRO}-depth-image-proc \
  python-opencv \
  libopencv-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*rm 

#
# Initialize the ROS environment
#
RUN rosdep init && rosdep update 

#
# Build and install libfreenect2
#
RUN git clone https://github.com/OpenKinect/libfreenect2.git

RUN cd libfreenect2 \
  && mkdir build \
  && cd build \
  && cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/freenect2 -DENABLE_CXX11=ON -DENABLE_CUDA=off \
  && make -j8 \
  && make install \
  && mkdir -p /etc/udev/rules.d/ \
  && cp ../platform/linux/udev/90-kinect2.rules /etc/udev/rules.d/
RUN chmod a+rwx /etc/udev/rules.d

#
# Entrypoint
#
COPY ./ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh

ENTRYPOINT ["/ros_entrypoint.sh"]
