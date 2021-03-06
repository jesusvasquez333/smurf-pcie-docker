# Docker image with smurf-pcie for the SMuRF project

## Description

This docker image, named **smurf-pcie** contains the smurf-pcie repository for the SMuRF project.

It is based on the smurf-rogue docker image, which contains Rogue (using the smurf's `cryo-det` branch), python 3, EPICS 3.15.5 (the community version), and other necessary packages and tools.

## Source code

The base image is smurf-rogue, which contains the smurf version of rogue and all additional tools.

The smurf-pcie source code is checked out directly from its [github repository](https://github.com/slaclab/smurf-pcie), using the master branch.

## Building the image

The provided script *build_docker.sh* will automatically build the docker image. It will tag the resulting image using the same git tag string (as returned by `git describe --tags --always`).

## How to get the container

To get the most recent version of the docker image, first you will need to install docker in you host OS and be logged in. Then you can pull a copy by running:

```
docker pull jesusvasquez333/smurf-pcie:<TAG>
```

Where **<TAG>** represents the specific tagged version you want to use.

## How to run the container

The container can be in three different modes:
- GUI mode: In this mode the PCIe GUI is open,
- Configuration mode: In this mode, a configuration file is loaded into the PCIe's FPGA, without starting any GUI. The configuration file can be one of the 2 defaults included in the `smurf-pcie` repository.
- Programming mode: In this mode, the FPGA Programming scrip is invoke and one the the firmware image included in the `smurf-pcie` repository can be loaded into the FPGA.

If you want to open the GUI, the you need go some extra steps in order to be able to forward X from the container to the host; and these steps are different depending if you are running the container locally in the host, or via an ssh connection.

If you want to load a configuration or programming the FPGA, as these modes don't use a GUI, then you can run directly the container, without the extra steps.

Here below you will find an example bash script you can use for running the container in each case:

### Running the GUI mode

#### Locally from the host

```
$ cat run_docker.sh
docker run -ti \
-u $(id -u) \
-e DISPLAY=unix$DISPLAY \
-v "/tmp/.X11-unix:/tmp/.X11-unix" \
-v "/etc/group:/etc/group:ro" \
-v "/etc/passwd:/etc/passwd:ro" \
jesusvasquez333/smurf-pcie:<TAG>
```

#### Remotely via an ssh connection

```
$ cat run_docker.sh
#!/usr/bin/env bash

XAUTH=/tmp/.docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | sudo xauth -f $XAUTH nmerge -
sudo chmod 777 $XAUTH
X11PORT=`echo $DISPLAY | sed 's/^[^:]*:\([^\.]\+\).*/\1/'`
TCPPORT=`expr 6000 + $X11PORT`
sudo ufw allow from 172.17.0.0/16 to any port $TCPPORT proto tcp
DISPLAY=`echo $DISPLAY | sed 's/^[^:]*\(.*\)/172.17.0.1\1/'`

docker run -ti --rm \
-e DISPLAY=$DISPLAY \
-v $XAUTH:$XAUTH \
-e XAUTHORITY=$XAUTH \
--device /dev/datadev_0 \
jesusvasquez333/smurf-pcie:<TAG>
```

### Running the configuration mode

#### Load default `pcie_rssi_config.yml`

```
$ cat run_docker.sh
#!/usr/bin/env bash

docker run -ti --rm \
--device /dev/datadev_0 \
jesusvasquez333/smurf-pcie:<TAG> rssi
```

#### Load default `pcie_fsbl_config.yml`

```
$ cat run_docker.sh
#!/usr/bin/env bash

docker run -ti --rm \
--device /dev/datadev_0 \
jesusvasquez333/smurf-pcie:<TAG> fsbl
```

### Running the programming mode

```
$ cat run_docker.sh
#!/usr/bin/env bash

docker run -ti --rm \
--device /dev/datadev_0 \
jesusvasquez333/smurf-pcie:<TAG> program
```

where:
- **TAG** is the tag version of the docker image you want to use,
