#!/bin/bash

apt-get install puppet ruby-hiera-puppet
cp -r hiera.yaml hieradata /etc/puppet
puppet apply main.pp
