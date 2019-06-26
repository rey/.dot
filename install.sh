#!/bin/bash

cd ~
ln -sf ~/.dot/bash_profile ~/.bash_profile
ln -sf ~/.dot/bashrc ~/.bashrc
ln -sf ~/.dot/gitconfig ~/.gitconfig
ln -sf ~/.dot/gitignore_global ~/.gitignore_global
ln -sf ~/.dot/inputrc ~/.inputrc
mkdir -p ~/_trash && crontab ~/.dot/crontab.rey
