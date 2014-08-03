#! /bin/bash
touch volup
while [ -e 'volup' ]; do
    sleep 0.01
done
