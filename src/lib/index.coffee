debug                     = require('debug')('index')
{ firebaseManager }       = require('./firebase')
client                    = require('./client')

session = "test"

debug("Starting client...")

newEventHandler = (snapshot, prevChild) ->
  client.runScript(snapshot.val())

firebaseManager.eventsRef(session).on 'child_added', newEventHandler
