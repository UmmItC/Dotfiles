#!/bin/bash 
grim /tmp/shot.png
magick /tmp/shot.png -blur 0x4 -level 0%,100% /tmp/magick_blurred.png
wlogout --protocol layer-shell
