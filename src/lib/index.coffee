debug                     = require('debug')('index')
{ firebaseManager }       = require('./firebase')
client                    = require('./client')
child_process             = require('child_process')

session = "test"

debug("Starting client...")

firebaseManager.eventsRef(session).on 'child_added', (snapshot, prevChild) ->
  client.runScript(snapshot.val())
  firebaseManager.eventsRef(session).child(snapshot.name()).set(null)

# Start the media key watcher
media_watcher_file = __dirname + "/client/scripts/media/send_media_key.py"
child_process.execFile media_watcher_file, (err, stdin, stdout) ->
  if err?
    console.log err
  console.log stdout
