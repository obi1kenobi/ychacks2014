#! /bin/bash
osascript -e '
tell application "Google Chrome"
    activate
	set active tab index of window '$1' to '$2'
end tell'
