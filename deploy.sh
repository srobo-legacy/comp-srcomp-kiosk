#!/bin/bash

apt-get install puppet ruby-hiera-puppet
rm -rf /etc/puppet/hieradata
cp -r hiera.yaml hieradata /etc/puppet
puppet apply main.pp
