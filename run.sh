#!/bin/sh -ex

if [ -n "$1" ]; then
	set -- -v "$1:/data:Z" -w /data
fi

exec podman run -it --rm \
	--name chipwhisperer \
	-p 8888:8888 \
	--device /dev/bus/usb \
	--security-opt label=disable \
	"$@" \
	chipwhisperer
