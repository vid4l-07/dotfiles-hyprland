#!/bin/bash

mount -t vfat -o uid=1000,gid=1000,umask=022 /dev/sda4 /home/hvidal/programacion

#sudo systemctl enable mnt-prog
#/etc/systemd/system/mnt-prog.service

