#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -yq
sudo apt-get install -yq python3 python3-pip xauth x11-xserver-utils xfonts-base

# Prepare folder for next script
mkdir -p ~/.vnc
