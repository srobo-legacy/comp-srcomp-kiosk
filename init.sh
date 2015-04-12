#!/bin/bash

mydir=`dirname $0`
cd $mydir
mydir=$PWD

puppet_dir='/etc/puppet'

if [[ -d $puppet_dir ]]
then
    echo "Puppet dir ($puppet_dir) already exists, remove it?"
    read do_remove
    if [[ $do_remove -eq "y" ]]
    then
        rm -rf /etc/puppet
    else
        exit 1
    fi
fi

ln -s $mydir /etc/puppet

apt-get install puppet ruby-hiera-puppet

./deploy.sh
