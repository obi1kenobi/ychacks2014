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

# Retrieve the files open when the client starts
get_all_directory = __dirname + "/client/scripts/"
child_process.execFile get_all_directory + "get_all_windows.sh", (err, stdin, stdout) ->
