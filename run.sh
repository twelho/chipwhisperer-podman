#!/bin/sh -ex

if [ -n "$1" ]; then
	set -- -v "$1:/opt/chipwhisperer/jupyter:Z"
fi

exec podman run -it --rm \
	--name chipwhisperer \
	-p 8888:8888 \
	--device /dev/bus/usb \
	--security-opt label=disable \
	-e TZ="$(readlink -f /etc/localtime)" \
	"$@" \
	chipwhisperer
