#!/bin/bash

echo "Enter channel name:"
read channel

# Check is chatterino is running
if pgrep -x "chatterino" > /dev/null
then
    echo "Chatterino is already running.."
else
    chatterino &
fi

streamlink twitch.tv/$channel best --twitch-disable-ads --player=mpv --twitch-low-latency &

disown
exit
