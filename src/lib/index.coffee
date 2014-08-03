async                     = require('async')
debug                     = require('debug')('index')
child_process             = require('child_process')
{ firebaseManager }       = require('./firebase')
client                    = require('./client')
{ constants }             = require('./common')
opened_apps               = require('./client/opened_apps')

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
  ref = firebaseManager.sessionsRef.child(session)
  ref.set null, cb
  ref.onDisconnect().set(null)

startListening = () ->
  ref = firebaseManager.eventsRef(session)
  ref.on 'child_added', (snapshot, prevChild) ->
    client.scriptRunner.runScript(snapshot.val())
    ref.child(snapshot.name()).set(null)

  @context_ref = firebaseManager.contextRef(session)
  @context_ref.on 'child_changed', (snapshot, prevChild) ->
    if snapshot.name() != 'current_app'
      return
    @context_ref.child('running_apps').once 'value', (apps) ->
      current_app = snapshot.val()
      if current_app == 'UNKNOWN'
        return

      all_apps = apps.val()

      if current_app not of all_apps
        debug "Could not find current app (#{current_app}) in all apps"
        return

      if all_apps[current_app] != 1
        open_chrome_tab(all_apps[current_app].window_index, all_apps[current_app].tab_index)
      else
        # TODO: Make sure this works for all of our native apps (aka keynote)
        open_window(current_app)

startMediaKeyWatcher = () ->
  # Start the media key watcher
  media_watcher_file = __dirname + "/client/scripts/media/send_media_key.py"
  child_process.execFile media_watcher_file, (err, stdout, stderr) ->
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
    start_watching_apps()
    startListening()
    process.nextTick done
], (err) ->
  if err?
    debug("Error: #{JSON.stringify err}")

script_directory = __dirname + "/client/scripts/"

open_window = (window_name) ->
  command = script_directory + "open_window.sh"
  child_process.execFile command, [window_name], (err, stdout, stderr) ->
    if err?
      debug("Error opening window #{JSON.stringify err}")

open_chrome_tab = (window_index, tab_index) ->
  command = script_directory + "open_chrome_tab.sh"
  child_process.execFile command, [window_index, tab_index], (err, stdout, stderr) ->
    if err?
      debug("Error setting chrome tab #{JSON.stringify err}")

parse_windows_list = (window_string) ->
  unfiltered_windows = window_string.split ", "
  return unfiltered_windows

parse_chrome_tab_info = (chrome_tab_string) ->
  packed_urls = chrome_tab_string.split ", "
  unfiltered_tabs = []
  for packed_url in packed_urls
    if not packed_url.length
      continue
    url_params = packed_url.split '|'
    unfiltered_tabs.push
      window_index: url_params[0]
      tab_index: url_params[1]
      tab_url: url_params[2]
  return unfiltered_tabs

get_current_windows = () ->
  command = script_directory + "get_current_window.sh"
  child_process.execFile command, (err, stdout, stderr) ->
    stdout = stdout.trim()
    if stdout == 'Google Chrome'
      command = script_directory + "get_current_chrome_tab.sh"
      child_process.execFile command, (err, stdout, stderr) ->
        unfiltered_tab = [
          window_index: 1
          tab_index: 1
          tab_url: stdout.trim()
        ]
        current_app = opened_apps.get_apps [], unfiltered_tab
        if not Object.keys(current_app).length
          @context_ref.child('current_app').set('UNKNOWN')
          return
        else
          @context_ref.child('current_app').set(Object.keys(current_app)[0])
          return
    else
      current_app = opened_apps.get_apps [stdout], []
      if not Object.keys(current_app).length
        @context_ref.child('current_app').set('UNKNOWN')
        return
      else
        @context_ref.child('current_app').set(Object.keys(current_app)[0])
        return

start_watching_apps = () ->
  setInterval(() ->
    child_process.execFile script_directory + "get_all_windows.sh", (err, stdout, stderr) ->
      if err?
        debug("Error getting all windows #{JSON.stringify err}")
      unfiltered_window_list = parse_windows_list(stdout)
      if "Google Chrome" in unfiltered_window_list
        child_process.execFile script_directory + "get_all_chrome_tabs.sh", (err, stdout, stderr) ->
          if err?
            debug("Error getting chrome tabs")
          unfiltered_chrome_tab_info = parse_chrome_tab_info(stdout)
          apps = opened_apps.get_apps(unfiltered_window_list, unfiltered_chrome_tab_info)
          debug apps
          @context_ref.child('running_apps').set(apps)
          get_current_windows()
      else
        apps = opened_apps.get_apps(unfiltered_window_list, [])
        debug apps
        @context_ref.child('running_apps').set(apps)
        get_current_windows()
  1000)
