#!/bin/bash

cliphist list | fuzzel --dmenu -w 80 | cliphist decode | wl-copy
