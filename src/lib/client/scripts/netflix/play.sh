#! /bin/bash
# page up = key code 116
osascript -e 'tell application "System Events"
        tell application "Google Chrome" to activate
        key code 116
end tell'
