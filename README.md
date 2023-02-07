# kinectv2-ros-docker
A docker environment to use Kinect v2 with ROS

## Usage
### Build the image

```
make build
```

### `catkin build`

```
docker-compose up catkin-build
```

### Launch `kinect2_bridge`

```
docker-compose up kinect2-bridge
```

### Calibration
Follow the steps shown [here](https://github.com/code-iai/iai_kinect2/tree/0e2c5f63134a076606bb79963406e1d47f2da651/kinect2_calibration)

1. Make a directory for storing images 

   ```mkdir calib```

1. Collect color images

   ```docker-compose up kinect2-calibration-record-color```

1. Calibrate the RGB camera

   ```docker-compose up kinect2-calibration-calibrate-color```

1. Collect IR images

   ```docker-compose up kinect2-calibration-record-ir```
   
1. Calibrate the IR camera

   ```docker-compose up kinect2-calibration-calibrate-ir```

1. Collect synchronized RGB and IR images

   ```docker-compose up kinect2-calibration-record-sync```

1. Calibrate the extrinsics of the RGB and IR cameras

   ```docker-compose up kinect2-calibration-calibrate-sync```

1. Calibrate depth

   ```docker-compose up kinect2-calibration-calibrate-depth```

1. Copy the generated parameter files to `catkin_ws/src/iai_kinect2/kinect2_bridge/data/<sensor serial>`

**NOTE**: Change the parameters of the checkerboard in the commands depending on the one you use.