#!/bin/bash

# @Author: GeorgeRaven <archer>
# @Date:   2020-02-29T21:27:15+00:00
# @Last modified by:   archer
# @Last modified time: 2020-03-01T12:04:45+00:00
# @License: please see LICENSE file in project root

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/zsh root
cp -aT /etc/skel/ /root/
chmod 700 /root

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

systemctl enable pacman-init.service choose-mirror.service
systemctl set-default multi-user.target

# get the system up and running with SSH key based authentication on boot
systemctl enable sshd
mkdir ~/.ssh
cd ~/.ssh
git clone https://gist.github.com/DreamingRaven/e3c78d0bd91a9401dca02563f42cf529 .
cp azuran_ssh authorized_keys

# set up basic user
user_name=archer
useradd -m ${user_name}
echo "${user_name} ALL=(ALL) ALL" >> /etc/sudoers
rm /home/${user_name}/.bashrc
cd /home/${user_name}/
git init .
git remote add -t \* -f origin https://github.com/DreamingRaven/.files
git checkout master
