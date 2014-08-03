#! /bin/bash
# page up = key code 121
osascript -e 'tell application "System Events"
        tell application "Google Chrome" to activate
        key code 121
end tell'
