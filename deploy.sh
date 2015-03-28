#!/bin/bash

cp hiera.yaml hieradata /etc/puppet
puppet apply main.pp
./kiosk.py &
