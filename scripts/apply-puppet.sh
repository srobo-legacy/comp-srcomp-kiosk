#!/bin/sh

cd $(dirname $0)/..

exec sudo puppet apply --modulepath=modules manifests/main.pp "$@"
