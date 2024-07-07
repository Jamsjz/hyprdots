#!/bin/zsh

state="${XDG_STATE_HOME}/togglemonitorlock"
booleanvalue="false"

if [[ -f ${state} ]]; then
	booleanvalue=$(cat ${state})
fi

if [[ ${booleanvalue} == "true" ]]; then
	wlr-randr --output eDP-1 --pos 1920,0
	echo "false" >${state}
else
	wlr-randr --output eDP-1 --pos 2000,2000
	echo "true" >${state}
fi
