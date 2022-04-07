#!/bin/sh

SSEPUSH_VERSION=7.5.1

if [ ! -e files/ssepush-server-$SSEPUSH_VERSION ]; then
    wget --no-check-certificate https://github.com/nec-baas/ssepush-server/releases/download/v$SSEPUSH_VERSION/ssepush-server-$SSEPUSH_VERSION.tar.gz
    tar xvzf ssepush-server-$SSEPUSH_VERSION.tar.gz -C files/
fi
