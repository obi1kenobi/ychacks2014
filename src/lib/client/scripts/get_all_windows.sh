#! /bin/bash
osascript -e 'tell application "System Events"
   get name of every application process
end tell'