#!/bin/bash
INFO_URL="http://reanisz.site44.com/minecraft/dragonscraft"

wget "$INFO_URL/info.json" -O last_info.json

VERSION=`jq -r ".version" last_info.json`
MODS_URL=`jq -r ".mods_url.server" last_info.json`
CONFIG_URL=`jq -r ".config_url" last_info.json`
MODS_PATH="mods_v$VERSION.zip"
CONFIG_PATH="config_v$VERSION.zip"

if [ ! -e $MODS_PATH ]; then
    wget $MODS_URL -O $MODS_PATH
else
    echo "INFO: $MODS_PATH is already exists."
fi

if [ ! -e $CONFIG_PATH ]; then
    wget $CONFIG_URL -O $CONFIG_PATH
else
    echo "INFO: $CONFIG_PATH is already exists."
fi

rm -rf mods.bak/*
rmdir mods.bak
rm -rf config.bak/*
rmdir config.bak
mv mods mods.bak
mv config config.bak

unzip $MODS_PATH
unzip $CONFIG_PATH

mv last_info.json "info_v$VERSION.json"
