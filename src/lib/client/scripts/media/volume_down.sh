#! /bin/bash
touch voldown
while [ -e 'voldown' ]; do
    sleep 0.01
done
