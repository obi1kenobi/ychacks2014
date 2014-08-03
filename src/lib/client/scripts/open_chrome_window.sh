#! /bin/bash
osascript -e '
tell application "Google Chrome" to set index of window '$1' to 1
do shell script "open -a Google\\ Chrome"'
