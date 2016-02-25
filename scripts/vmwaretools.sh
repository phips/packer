#!/bin/bash
# running under sudo from packer

echo $PWD
mkdir -p /media/cdrom
mount -oloop linux.iso /media/cdrom
cd /var/tmp
tar xzf /media/cdrom/VM*tar.gz
cd vmware-tools-distrib
./vmware-install.pl -d
umount /media/cdrom
rm /home/vagrant/linux.iso
