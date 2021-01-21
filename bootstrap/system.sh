#!/bin/sh

set -xe

TARGET_HOSTNAME="raspberrypi"

# base stuff
apk add ca-certificates
update-ca-certificates
echo "root:raspberry" | chpasswd
setup-hostname $TARGET_HOSTNAME
echo "127.0.0.1    $TARGET_HOSTNAME $TARGET_HOSTNAME.localdomain" > /etc/hosts
setup-keymap us us

# time
apk add chrony tzdata
setup-timezone -z America/Denver

# other stuff
apk add nano htop curl wget bash bash-completion git mesa-dri-vc4
echo "vc4" >/etc/modules-load.d/vc4.conf
sed -i 's/\/bin\/ash/\/bin\/bash/g' /etc/passwd

# login
apk add util-linux
sed -E -e 's,getty(.*)$,agetty\1 linux,' -e '/tty1/s,agetty,agetty --autologin pi --noclear,' -i /etc/inittab