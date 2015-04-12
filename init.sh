#!/bin/bash

mydir=`dirname $0`
cd $mydir
mydir=$PWD

if [[ -d "/etc/puppet" ]]
then
    echo "Puppet dir already exists, cannot install."
    exit 1
fi

ln -s $mydir /etc/puppet

apt-get install puppet ruby-hiera-puppet

./deploy.sh
