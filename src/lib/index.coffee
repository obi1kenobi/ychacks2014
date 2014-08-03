debug                     = require('debug')
{ firebaseManager }       = require('./firebase')
client                    = require('./client')

session = "test"

newEventHandler = (snapshot, prevChild) ->
  client.runScript(snapshot.val())

firebaseManager.eventsRef(session).on 'child_added', newEventHandler
