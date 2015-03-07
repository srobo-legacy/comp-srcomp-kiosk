#!/usr/bin/env python3

import argparse
import browser

parser = argparse.ArgumentParser(description='srcomp kiosk system')
parser.add_argument('--config', dest='config', help='Config file location '
        '(default: /etc/srcomp-kiosk/config.yaml)',
        default="/etc/srcomp-kiosk/config.yaml")

args = parser.parse_args()

configPath = args.config

web = browser.Browser(configPath)
web.go()
