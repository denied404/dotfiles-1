#!/bin/bash

name="$6"

if [[ "$name" == "office" ]]; then
    /home/oeprator/bin/resolvconf-switch office
fi
