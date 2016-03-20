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
