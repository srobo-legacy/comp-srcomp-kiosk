#!/usr/bin/env python3

import argparse
import logging
import os
import subprocess
import time
import yaml

# Parse arguments to get the config file location
DEFAULT_BROWSER = 'firefox'
DEFAULT_CONFIG  = '/etc/srcomp-kiosk/config.yaml'
DEFAULT_PROFILE = '/opt/srcomp-kiosk/firefox-profile'

LOG_FILE = '/var/log/srcomp-kiosk.log'
logging.basicConfig(filename=LOG_FILE,
                    level=logging.INFO,
                    format='%(asctime)s (pid:%(process)d) %(levelname)s:%(message)s'
                   )
logging.info("Starting kiosk on '%s' from '%s'.",
             os.environ.get('DISPLAY'), os.getcwd())

parser = argparse.ArgumentParser(description='srcomp kiosk system')
parser.add_argument('--config', dest='config', help='Config file location '
        '(default: {0})'.format(DEFAULT_CONFIG),
        default=DEFAULT_CONFIG)
parser.add_argument('--browser', dest='browser', help='Browser to use '
        '(default: {0}, must be firefox based)'.format(DEFAULT_BROWSER),
        default=DEFAULT_BROWSER)
parser.add_argument('--profile', dest='profile', help='Profile to use '
        "(default: {0}, passed to the browser after '--profile')".format(DEFAULT_PROFILE),
        default=DEFAULT_PROFILE)

args = parser.parse_args()

configPath = args.config
browser = args.browser
profilePath = args.profile

# Disable screensaver

xset_commands = [
        ["xset", "-dpms"],
        ["xset", "s", "off"],
        ["xset", "s", "noblank"],
    ]

logging.info("Disabling the screensaver")
for command in xset_commands:
    cmd = " ".join(command)
    logging.debug("About to run '%s'.", cmd)
    try:
        subprocess.check_call(command)
    except Exception as e:
        logging.exception("Failed to run '$s'.", cmd)
        print(e)

logging.info("Hiding the mouse")
try:
    unclutter = subprocess.Popen(["unclutter"])
except Exception as e:
    logging.exception("Unclutter failed")
    raise

oldUrl = None

while True:
    try:
        with open(configPath) as f:
            url = yaml.load(f)['url']
            if url != oldUrl:
                subprocess.Popen([browser, "--profile", profilePath, url])
                oldUrl = url
    except IOError as e:
        logging.exception("Failed to set url.")
        print(e)

    time.sleep(1)
    assert unclutter.returncode is None, "Unclutter has closed!"
