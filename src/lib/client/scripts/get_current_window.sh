#! /bin/bash
osascript -e 'tell application "System Events"
    get name of first application process whose frontmost is true
end tell'