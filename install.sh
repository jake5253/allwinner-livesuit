#!/bin/bash
set -e

if [[ $EUID -ne 0 ]];
then
    exec sudo /bin/bash "$0" "$@"
fi
lines=79

echo " "
echo "========***********LiveSuit installer***********==========="
echo "LiveSuit and USB Drivers are being installed to your system"
echo "USB Driver is updated to install on kernel versions 4.11.x+"
echo "This installer will also add a shortcut to LiveSuit in your"
echo "Application Menu under the Accessories submenu and put your"
echo "user-group into an udev.rules file so you DO NOT have to"
echo "run LiveSuit as sudo in order for it to detect your device"
echo "========*Modded by Jason Miller [XDA: jake5253]*==========="
echo " "

echo "Extracting installation files..."
tail -n +$lines $0 > /tmp/livesuit.tar.xz
tar -xJf /tmp/livesuit.tar.xz -C /tmp/
echo "Done"
echo " "
echo "Installing USB Driver..."
dpkg -i /tmp/livesuit/awdev-dkms_0.5.1_all.deb
echo "Done"
echo " "
echo "Moving LiveSuit files into applications folder..."
cp -r /tmp/livesuit/bin/ /usr/lib/livesuit/
cp /tmp/livesuit/livesuit /usr/bin/livesuit
echo "Done"
echo " "
echo "Writing udev rule..."
usergroup=$(su -c "groups | cut -f1 -d\ " $SUDO_USER)
cat >/etc/udev/rules.d/10-allwinner.rules <<EOL 
# for LiveSuit
SUBSYSTEM!="usb_device", ACTION!="add", GOTO="objdev_rules_end"
ATTRS{idVendor}=="1f3a", ATTRS{idProduct}=="efe8", GROUP="${usergroup}",
MODE="0666"
LABEL="objdev_rules_end"
EOL
echo "Done"
echo " "
echo "Creating Application Menu item..."
cat >/usr/share/applications/livesuit.desktop <<EOL
[Desktop Entry]
Name=LiveSuit
Categories=Utility;
Type=Application
Exec=/usr/bin/livesuit
Terminal=false
NoDisplay=false
EOL
echo "Done"
echo " "
echo "Setting permissions..."
chmod -R 755 /usr/lib/livesuit
chmod 755 /usr/bin/livesuit
chmod 644 /etc/udev/rules.d/10-allwinner.rules
chmod 644 /usr/share/applications/livesuit.desktop
echo "Done"
echo " "
echo "Force Applications Menu update..."
su -c "xdg-desktop-menu forceupdate" $SUDO_USER
echo "Done"
echo " "
echo "Force udev rules update..."
udevadm control --reload-rules
echo "Done"
echo " "
echo "Cleaning up"
rm -rf /tmp/livesuit
rm /tmp/livesuit.tar.xz
echo "FINISHED!!"

exit 0
