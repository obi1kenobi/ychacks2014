#! /bin/bash
osascript -e 'set output_string to ""

tell application "Google Chrome"
	set all_windows to every window
	set i to 0
	repeat with the_window in all_windows
		set i to i + 1
		set j to 0
		set tab_list to every tab in the_window
		repeat with the_tab in tab_list
			set j to j + 1
			set the_url to the URL of the_tab
			set the_url to i & "|" & j & "|" & the_url
			set output_string to output_string & ", " & the_url
		end repeat
	end repeat
end tell

do shell script "echo " & quoted form of the output_string'