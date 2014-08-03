debug                     = require('debug')('index')
child_process             = require('child_process')
{ firebaseManager }       = require('./firebase')
client                    = require('./client')
{ constants }             = require('./common')

session = "test"

debug("Generating a new session...")

getPairingCode = (cb) ->
  firebaseName = constants.FIREBASE_NAME
  rootRef = firebaseManager.rootRef
  tokensRef = firebaseManager.tokensRef
  client.login.loginAndGetInfo firebaseName, rootRef, tokensRef, (err, info) ->
    if err?
      debug("Error when pairing: #{JSON.stringify err}")
      cb?(err)
    else
      console.log "Login info: #{info}"
      cb?(null, info)
getPairingCode()

debug("Starting client...")

firebaseManager.eventsRef(session).on 'child_added', (snapshot, prevChild) ->
  client.runScript(snapshot.val())
  firebaseManager.eventsRef(session).child(snapshot.name()).set(null)

# Start the media key watcher
media_watcher_file = __dirname + "/client/scripts/media/send_media_key.py"
child_process.execFile media_watcher_file, (err, stdin, stdout) ->
  if err?
    debug("Error launching media watcher: #{JSON.stringify err}")
  debug("Media watcher stdout: #{stdout}") if stdout?

script_directory = __dirname + "/client/scripts/"

open_chrome_tab = (window_index, tab_index) ->
  command = script_directory + "open_chrome_tab.sh"
  child_process.execFile command, [window_index, tab_index], (err, stdin, stdout) ->
    if err?
      debug("Error setting chrome tab #{JSON.stringify err}")

parse_windows_list = (window_string) ->
  unfiltered_windows = window_string.split ", "
  # TODO Filter the windows, return the list
  return unfiltered_windows

parse_chrome_tab_info = (chrome_tab_string) ->
  packed_urls = chrome_tab_string.split ", "
  filtered_tabs = []
  for packed_url in packed_urls
    if not packed_url.length
      continue
    url_params = packed_url.split '|'
    window_index = url_params[0]
    tab_index = url_params[1]
    url = url_params[2]
    # TODO check the url with regex here

  return filtered_tabs

setInterval(() ->
  child_process.execFile script_directory + "get_all_windows.sh", (err, stdin, stdout) ->
    if err?
      debug("Error getting all windows #{JSON.stringify err}")
    new_window_list = parse_windows_list(stdout)
    if "Google Chrome" in new_window_list
      child_process.exectFile script_directory + "get_all_chrome_tabs", (err, stdin, stdout) ->
        if err?
          debug("Error getting chrome tabs")
        new_chrome_tab_info = parse_chrome_tab_info(stdout)
        # TODO: Send off the open window and chrome tab info
    else
      # TODO: Send off the open window info
      return
1000)
