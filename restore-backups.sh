#! /bin/bash

if [[ -f /vagrant/x64/install.tar.gz.bak ]]; then
  rm /vagrant/x64/install.tar.gz
  mv /vagrant/x64/install.tar.gz.bak /vagrant/x64/install.tar.gz
fi

if [[ -f /vagrant/ARM64/install.tar.gz.bak ]]; then
  rm /vagrant/ARM64/install.tar.gz
  mv /vagrant/ARM64/install.tar.gz.bak /vagrant/ARM64/install.tar.gz
fi


