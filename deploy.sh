#!/bin/bash

if [[ ! -d "/etc/puppet" ]]
then
    echo "Puppet dir not present; cannot deploy. Did you run init yet?"
    exit 1
fi

puppet apply /etc/puppet/manifests/main.pp
