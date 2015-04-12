#!/usr/bin/env python3

import argparse
import subprocess
import time
import yaml

# Parse arguments to get the config file location
DEFAULT_BROWSER = 'firefox'
DEFAULT_CONFIG  = '/etc/srcomp-kiosk/config.yaml'
DEFAULT_PROFILE = '/opt/srcomp-kiosk/firefox-profile'

parser = argparse.ArgumentParser(description='srcomp kiosk system')
parser.add_argument('--config', dest='config', help='Config file location '
        '(default: {0})'.format(DEFAULT_CONFIG),
        default=DEFAULT_CONFIG)
parser.add_argument('--browser', dest='browser', help='Browser to use '
        '(default: {0}, must be firefox based)'.format(DEFAULT_BROWSER),
        default=DEFAULT_BROWSER)
parser.add_argument('--profile', dest='browser', help='Profile to use '
        "(default: {0}, passed to the browser after '--profile')".format(DEFAULT_PROFILE),
        default=DEFAULT_PROFILE)

args = parser.parse_args()

configPath = args.config
browser = args.browser
profilePath = args.profile

# Disable screensaver

subprocess.call(["xset", "-dpms"])
subprocess.call(["xset", "s", "off"])
subprocess.call(["xset", "s", "noblank"])
subprocess.Popen(["unclutter"])

oldUrl = None

while True:
    time.sleep(1)
    try:
        with open(configPath) as f:
            url = yaml.load(f)['url']
            if url != oldUrl:
                subprocess.Popen([browser, "--profile", profilePath, url])
                oldUrl = url
    except IOError as e:
        print(e)
