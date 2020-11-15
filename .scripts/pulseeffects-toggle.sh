#!/bin/bash

# A simple script to toggle PulseEffects Auto Gain and Limiter on and off

state=$(dconf read /com/github/wwmm/pulseeffects/sinkinputs/limiter/state)

if [ $state == true ]
then
    dconf write /com/github/wwmm/pulseeffects/sinkinputs/autogain/state false
    dconf write /com/github/wwmm/pulseeffects/sinkinputs/limiter/state false
    notify-send 'PulseEffects' 'Auto Gain and Limiter Off'
else
    dconf write /com/github/wwmm/pulseeffects/sinkinputs/autogain/state true
    dconf write /com/github/wwmm/pulseeffects/sinkinputs/limiter/state true
    notify-send 'PulseEffects' 'Auto Gain and Limiter On'
fi
