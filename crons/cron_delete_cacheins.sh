#!/bin/bash
DIRECTORY=$(cd `dirname $0` && pwd)
cd $DIRECTORY
source "config.sh"

#Elimina el cacheins:
dir="cache_ins/*"
rm -Rf $basedir$dir
