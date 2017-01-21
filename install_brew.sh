#!/bin/bash

echo "Linuxbrew requires:"
echo "    build-essential curl git python-setuptools ruby"
echo ""
echo "Press any key to continue..."
read
echo "Installing..."

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
