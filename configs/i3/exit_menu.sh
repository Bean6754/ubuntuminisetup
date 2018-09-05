#!/bin/bash

res=$(rofi -dmenu < ~/.dmenu-i3exit)

if [ $res = "logout" ]; then
    i3-msg exit
fi
if [ $res = "restart" ]; then
    reboot
fi
if [ $res = "shutdown" ]; then
    poweroff
fi
exit 0
