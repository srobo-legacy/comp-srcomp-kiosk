# SRComp Kiosk

This is a kiosk type system intended for use at the Student Robotics Competition.

It is a puppet config wrapping a firefox profile and a launcher script.

The launcher script is `kiosk.py` and is installed behind a wrapper as
`srcomp-kiosk` which presents an interface similar to a service -- it
has `start`, `stop`, `status` etc.

The output streams from `kiosk.py` ends up in `/var/log/srcomp-kisok`
as two log files, `stdout.log` and `stderr.log`.

If running `srcomp-kiosk` manually be sure that the `DISPLAY` environment
variable is properly set (you probably want `:0.0`).

The puppet config will launch the kiosk if it is not already running,
and it will also automatically start on boot via a `.desktop` file.

## Deployment

### Raspberry Pi setup

SR's Raspberry Pis run the Raspbian distribution (a derivative of Debian).
Two SD card images are available for download from the Raspberry Pi website:
full Raspbian (includes a full desktop environment) and Raspbian Lite (no
desktop). As of April 2016, the full Raspbian image is too large for our 4 GB
SD cards, so we need to use the Raspbian Lite image.

The latest release of Raspbian Lite can be found [here][raspbianlite-latest];
older versions are archived [here][raspbianlite-old]. Download the latest
Raspbian Lite image, and flash it to the SD card (see
[this wiki page][sd-setup] for a guide).

Connect a keyboard, monitor and network cable to the Raspberry Pi and boot it
up. When a login prompt appears, login as user "pi" and password "raspberry".

The filesystem contained in the SD card image is less than 2 GB; we want to
expand this filesystem to the full size of the SD card. We can easily do this
using the `raspi-config` tool:

    sudo raspi-config

Select "Expand Filesystem", and reboot the Pi once the process is complete.
When it has finished rebooting, log in again to continue setup.

It is a good idea to make sure all installed packages are up to date, so enter
these commands to perform system updates:

    sudo apt-get update -y
    sudo apt-get dist-upgrade -y

Next, we need to install a desktop environment. Note that the install process
can take up to an hour:

    sudo apt-get install -y lightdm lxde-core xserver-xorg xinit

Finally, we need to configure the Raspberry Pi to start the desktop environment
as part of the boot sequence. This is also done through the raspi-config tool.
Select the "Enable boot to desktop" option, and then exit when done. Reboot the
Pi to test that it loads a desktop environment on startup.

[raspbianlite-latest]: https://www.raspberrypi.org/downloads/raspbian/
[raspbianlite-old]: http://downloads.raspberrypi.org/raspbian_lite/images/
[sd-setup]: http://elinux.org/RPi_Easy_SD_Card_Setup

### SRComp Kiosk setup

To deploy on a clean Raspberry Pi (one that has not had srcomp-kiosk installed
on its SD card yet), enter the following at a terminal running on the Raspberry Pi:

    # Install Git:
    sudo apt-get install -y git
    # Clone this repo:
    git clone --recursive https://www.studentrobotics.org/gerrit/p/comp/srcomp-kiosk.git
    # Run the bootstrap script:
    cd srcomp-kiosk
    sudo ./init.sh

If `init.sh` prints the following message:

    Puppet dir (/etc/puppet) already exists, remove it? [y/N]:

then enter "y", which replaces whatever was at /etc/puppet (most likely a
previous install of srcomp-kiosk) with the current Puppet config.

If the Puppet config is later modified, the changes can be deployed by running the following commands:

    # Fetch the changes:
    git pull origin master
    # Deploy the new config:
    sudo ./deploy.sh
