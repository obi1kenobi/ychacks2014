#! /bin/bash
osascript -e 'set output_string to ""

tell application "Google Chrome"
	return URL of active tab of front window
end tell'
