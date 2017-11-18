#!/bin/sh
for bin in /usr/lib/go-1.8/bin/* ; do
    sudo update-alternatives --install /usr/bin/$(basename $bin) $(basename $bin) $bin 0
    sudo update-alternatives --set $(basename $bin) $bin
done
