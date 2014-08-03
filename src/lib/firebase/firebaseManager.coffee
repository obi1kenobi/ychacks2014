Firebase                       = require('firebase')
debug                          = require('debug')('firebase:index')
{ config, constants }          = require('../common')

rootRef = new Firebase(constants.FIREBASE)
sessionsRef = rootRef.child(constants.SESSIONS_CHILD)
eventsRef = (session) ->
  sessionsRef.child(session).child(constants.EVENTS_CHILD)
contextRef = (session) ->
  sessionsRef.child(session).child(constants.CONTEXT_CHILD)

FirebaseManager = {rootRef, sessionsRef, eventsRef, contextRef}

module.exports = FirebaseManager
