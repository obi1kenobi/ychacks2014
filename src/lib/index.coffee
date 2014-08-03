async                     = require('async')
debug                     = require('debug')('index')
child_process             = require('child_process')
{ firebaseManager }       = require('./firebase')
client                    = require('./client')
{ constants }             = require('./common')

session = null
pairingCode = null

# cb(err)
getLoginInfo = (cb) ->
  debug("Generating a new session...")
  firebaseName = constants.FIREBASE_NAME
  rootRef = firebaseManager.rootRef
  tokensRef = firebaseManager.tokensRef
  client.login.loginAndSetPairingCode firebaseName, rootRef, tokensRef, (err, info) ->
    if err?
      debug("Error when pairing: #{JSON.stringify err}")
      cb(err)
    else
      # debug("Login info: #{JSON.stringify info}")
      session = info.uid
      pairingCode = info.pairingCode
      cb(null)

eraseSessionIfExists = (cb) ->
  firebaseManager.sessionsRef.child(session).set null, cb

startListening = () ->
  firebaseManager.eventsRef(session).on 'child_added', (snapshot, prevChild) ->
    client.runScript(snapshot.val())
    firebaseManager.eventsRef(session).child(snapshot.name()).set(null)

startMediaKeyWatcher = () ->
  # Start the media key watcher
  media_watcher_file = __dirname + "/client/scripts/media/send_media_key.py"
  child_process.execFile media_watcher_file, (err, stdin, stdout) ->
    if err?
      debug("Error launching media watcher: #{JSON.stringify err}")
    debug("Media watcher stdout: #{stdout}") if stdout?

startMediaKeyWatcher()
async.series [
  (done) -> getLoginInfo done
  (done) -> eraseSessionIfExists done
  (done) ->
    console.log()
    console.log("**************************************************")
    console.log("          Your pairing code is: #{pairingCode}")
    console.log("**************************************************")
    setTimeout () ->
      console.log()
      console.log("Pairing code expired. If you didn't log in already, please restart the app.")
      client.login.expirePairingCode(firebaseManager.tokensRef, pairingCode)
    , constants.PAIRING_CODE_TIME_EXPIRATION
    console.log()
    console.log("Ready to receive data!")
    startListening()
    process.nextTick done
], (err) ->
  if err?
    debug("Error: #{JSON.stringify err}")
