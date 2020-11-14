#!/bin/bash

# Requires thunar-archive-plugin
# This installs a patched ark.tap since the default ark.tap doesn't work for me.
# Source: https://gitlab.xfce.org/thunar-plugins/thunar-archive-plugin/-/issues/4

sudo cp ark.tap /usr/lib/xfce4/thunar-archive-plugin/ark.tap
ln -s /usr/lib/xfce4/thunar-archive-plugin/ark.tap /usr/lib/xfce4/thunar-archive-plugin/org.kde.ark.tap

exit
