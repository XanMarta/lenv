#!/bin/bash

if [[ ! -z "${PUBLIC_KEY}" ]]; then
    echo "$PUBLIC_KEY" > /home/user/.ssh/authorized_keys
fi
