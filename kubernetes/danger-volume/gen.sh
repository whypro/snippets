#!/bin/sh

path=$1
size=$2

dd if=/dev/zero of=${path}/${size}M.file bs=1048576 count=${size}
