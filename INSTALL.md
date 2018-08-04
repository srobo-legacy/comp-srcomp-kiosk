# SRComp Kiosk Installation

## Raspberry Pi setup

If the Raspberry Pi already have a desktop environment set up and it doesn't
need to be re-imaged, then you can skip this section and jump straight to
"SRComp Kiosk setup".

SR's Raspberry Pis run the Raspbian distribution (a derivative of Debian).
Two SD card images are available for download from the Raspberry Pi website:
full Raspbian (includes a full desktop environment) and Raspbian Lite (no
desktop). As of April 2016, the full Raspbian image is too large for our 4 GB
SD cards, so we need to use the Raspbian Lite image.

Download the [latest Raspbian Lite image][raspbianlite], and flash it to the SD
card (see [this page][sd-setup] for a guide). You should then follow the
[instructions][rpi-setup] on the Raspberry Pi website to power on and log in to
the Raspberry Pi.

It is a good idea to make sure all installed packages are up to date, so enter
these commands to perform system updates:

    sudo apt-get update -y
    sudo apt-get upgrade -y

Next, we need to install a desktop environment. Note that the install process
can take up to an hour:

    sudo apt-get install -y lightdm lxde-core xserver-xorg xinit

Finally, we need to configure the Raspberry Pi to start the desktop environment
as part of the boot sequence. This is also done through the raspi-config tool
using the "Enable boot to desktop" option. Reboot the Raspberry Pi to test that
it loads a desktop environment on startup.

[raspbianlite]: https://www.raspberrypi.org/downloads/raspbian/
[sd-setup]: https://www.raspberrypi.org/documentation/installation/installing-images/README.md
[rpi-setup]: https://www.raspberrypi.org/help/quick-start-guide/

## SRComp Kiosk setup

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
