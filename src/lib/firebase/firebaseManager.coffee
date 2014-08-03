firebase                       = require('firebase')
debug                          = require('debug')('firebase:index')
{ config, constants }          = require('../common')

FirebaseManager =
  rootRef: new firebase.Firebase(constants.FIREBASE)
  sessionsRef: rootRef.child(constants.CONTEXT_CHILD)
  eventsRef: (session) ->
    sessionsRef.child(session).child(constants.EVENTS_CHILD)
  contextRef: (session) ->
    sessionsRef.child(session).child(constants.CONTEXT_CHILD)

module.exports = FirebaseManager(constants.FIREBASE)
