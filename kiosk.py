#!/usr/bin/env python3

import argparse
import subprocess
import time
import yaml

# Parse arguments to get the config file location

parser = argparse.ArgumentParser(description='srcomp kiosk system')
parser.add_argument('--config', dest='config', help='Config file location '
        '(default: /etc/srcomp-kiosk/config.yaml)',
        default="/etc/srcomp-kiosk/config.yaml")

args = parser.parse_args()

configPath = args.config

# Disable screensaver

subprocess.call(["xset", "-dpms"])
subprocess.call(["xset", "s", "off"])
subprocess.call(["xset", "s", "noblank"])
subprocess.Popen(["unclutter"])

oldUrl = None
proc = None

while True:
    time.sleep(1)
    try:
        with open(configPath) as f:
            url = yaml.load(f)['url']
            if url != oldUrl:
                if proc != None:
                    proc.kill()
                proc = subprocess.Popen(["chromium-browser", "--kiosk", url])
                oldUrl = url
    except IOError:
        print("Could not open file.")
