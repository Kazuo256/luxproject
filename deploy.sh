#!/bin/bash

help(){
    echo "Placeholder Help Message - Ask Wil"
}

if [ $# -lt 1 ] ; then
    echo "Error: Missing argument!"
    help
    exit 1;
fi

if [ $1 == "-h" -o $1 == "--help" ]; then
    help
    exit 0
fi

if [ ! -d $1/lux ]
then
  mkdir $1/lux
fi

cp -v lux/*.lua $1/lux

if [ ! -d $1/lux/geom ]
then
  mkdir $1/lux/geom
fi

cp lux/geom/*.lua $1/lux/geom

if [ ! -d $1/lux/externals ]
then
  mkdir $1/lux/externals
fi

cp lux/externals/*.lua $1/lux/externals

