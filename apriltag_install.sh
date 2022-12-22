-------------------------------------------------------------------
#install apriltag
git clone https://github.com/AprilRobotics/apriltag.git
cd apriltag
mkdir build
cd build
cmake ..
make -j4
make install



-------------------------------------------------------------------
#install apriltag_ros
cd
mkdir -p apriltag_ros/src
cd apriltag_ros/src
git clone https://github.com/AprilRobotics/apriltag_ros
cd ..
#if on jetson, do below first
sudo gedit /opt/ros/melodic/share/image_geometry/cmake/image_geometryConfig.cmake  ,change opencv to opencv4, in row 94 and 96.
sudo gedit /opt/ros/melodic/share/cv_bridge/cmake/cv_bridgeConfig.cmake  ,change opencv to opencv4, in row 94 and 96.
#if not on jetson, ignore up two lines
catkin_make



-------------------------------------------------------------------
#install usb_cam
# apt install, very easy, recommended
sudo apt install ros-melodic-usb-cam
roslaunch usb_cam usb_cam-test.launch

# Or install from source code
cd
mkdir -p usb_cam/src
cd usb_cam/src
git clone https://github.com/bosch-ros-pkg/usb_cam.git
cd ..
catkin_make
source devel/setup.bash
cd src/usb_cam
mkdir build
cd build
cmake ..
make
cd ..
cd launch
roslaunch usb_cam usb_cam-test.launch



-------------------------------------------------------------------
#calibrate usb_cam
sudo apt-get install ros-melodic-camera-calibration #18.04 melodic   20.04 noetic
roslaunch usb_cam usb_cam-test.launch
rosrun camera_calibration cameracalibrator.py --size 7x10 --square 0.015 image:=/usb_cam/image_raw camera:=/usb_cam

go to /tmp, find calibrationdata.tar.gz
find ost.yaml, change its name to head_camera.yaml, and place it under /home/$usrname/.ros/camera_info



-------------------------------------------------------------------

cd ~/apriltag_ros/src/apriltag_ros/apriltag_ros/config
sudo gedit settings.yaml
###
	tag_family:        'tag36h11' # options: tagStandard52h13, tagStandard41h12, tag36h11, tag25h9, tag16h5, tagCustom48h12, tagCircle21h7, tagCircle49h12  #支持单一标签类型
	tag_threads:       2          # default: 2           # 设置Tag_Threads允许核心APRILTAG 2算法的某些部分运行并行计算。 典型的多线程优点和限制适用
	tag_decimate:      1.0        # default: 1.0       #减小图像分辨率
	tag_blur:          0.0        # default: 0.0            #设置tag_blur> 0模糊图像，tag_blur  < 0锐化图像
	tag_refine_edges:  1          # default: 1       #增强了计算精度，但消耗了算力
	tag_debug:         0          # default: 0            #1为保存中间图像到~/.ros
	max_hamming_dist:  2          # default: 2 (Tunable parameter with 2 being a good choice - values >=3 consume large amounts of memory. Choose the largest value possible.)
	# Other parameters
	publish_tf:        true       # default: false       #发布tf坐标
###




sudo gedit tags.yaml
###!!!!! no tabs!!! just spaces!!!!
standalone_tags:
    [
        {id: 001, size: 0.167, name: tag_1}
    ]



tag_bundles:
    [
        {
          name: 'tag_1',
          layout:
        [
            {id: 001, size: 0.167, x: 0, y: 0, z: 0, qw: 1, qx: 0, qy: 0, qz: 0}
        ]
        }
    ]
###



cd ~/apriltag_ros/src/apriltag_ros/apriltag_ros/launch
gedit continuous_detection.launch
### 
	<arg name="camera_name" default="/usb_cam" /> 
	<arg name="image_topic" default="image_raw" />
###


-------------------------------------------------------------------
#start to locate
source ~/usb_cam/devel/setup.bash
roslaunch usb_cam usb_cam-test.launch
source ~/apriltag_ros/devel/setup.bash
roslaunch apriltag_ros continuous_detection.launch
rqt_image_view

#show locating results
source ~/apriltag_ros/devel/setup.bash
rostopic echo /tag_detections




