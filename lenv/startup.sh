#!/bin/bash

if [[ ! -z "${PUBLIC_KEY}" ]]; then
    echo "$PUBLIC_KEY" >> /root/.ssh/authorized_keys
fi