#!/bin/sh

# Load Qualcomm CLD WLAN driver for Google Coral Dev Board
modprobe -q wlan 2>/dev/null || true
