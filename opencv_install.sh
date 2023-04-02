# 一、从 Ubuntu 源仓库安装 OpenCV
# OpenCV 在 Ubuntu 20.04 软件源中可用。想要安装它，运行：

sudo apt update
sudo apt install libopencv-dev python3-opencv
# 复制
# 上面的命令将会安装所有必要的软件包，来运行 OpenCV：

# 通过导入cv2模块，并且打印 OpenCV 版本来验证安装结果：

python3 -c "import cv2; print(cv2.__version__)"



# 二、 从源码安装 OpenCV
# 从源码安装OpenCV可以允许你安装最新可用的版本。它还将针对你的特定系统进行优化，并且你可以完整控制所有的构建选项。这是最推荐的安装 OpenCV 的方式。

# 执行下面的步骤来从源码安装最新的 OpenCV 版本:

# 01.安装构建工具和所有的依赖软件包：

sudo apt install build-essential cmake git pkg-config libgtk-3-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
    gfortran openexr libatlas-base-dev python3-dev python3-numpy \
    libtbb2 libtbb-dev libdc1394-22-dev libopenexr-dev \
    libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev

# 02.克隆所有的OpenCV 和 OpenCV contrib 源：

mkdir ~/opencv_build && cd ~/opencv_build
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git

# 在写作的时候，github 软件源中的默认版本是 4.3.0。如果你想安装更旧版本的 OpenCV， cd 到 opencv和opencv_contrib目录，并且运行git checkout <opencv-version>。

# 03.一旦下载完成，创建一个临时构建目录，并且切换到这个目录：

cd ~/opencv_build/opencv
mkdir -p build && cd build

# 使用 CMake 命令配置 OpenCV 构建：

cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_build/opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON ..

# 输出将会如下：

-- Configuring done
-- Generating done
-- Build files have been written to: /home/vagrant/opencv_build/opencv/build

# 04.开始编译过程：

make -j8

# 根据你的处理器修改-f值。如果你不知道你的处理器核心数，你可以输入nproc找到。

# 编译将会花费几分钟，或者更多，这依赖于你的系统配置。

# 05.安装 OpenCV:

sudo make install

# 06.验证安装结果，输入下面的命令，那你将会看到 OpenCV 版本：

# C++ bindings:

pkg-config --modversion opencv4

# 输出：4.3.0

# Python bindings:
python3 -c "import cv2; print(cv2.__version__)"

# 输出：4.3.0-dev
