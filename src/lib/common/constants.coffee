Constants =
  FIREBASE_NAME: 'ychacks'
  FIREBASE: "https://ychacks.firebaseio.com/"
  SESSIONS_CHILD: 'sessions'
  CONTEXT_CHILD: 'context'
  EVENTS_CHILD: 'events'
  EVENT_TYPE_CHILD: 'type'
  EVENT_NAME_CHILD: 'name'
  TOKENS_CHILD: 'tokens'

  PAIRING_CODE_LENGTH: 6
  PAIRING_CODE_MODULUS: 1000000
  PAIRING_CODE_ALGORITHM: 'sha1'
  PAIRING_CODE_TIME_EXPIRATION: 15000

###
Firebase structure

When the server disconnects, it deletes its session node.

root (/)
+ 'tokens'
|-+ <pairing code>
| |-+ token
|
|-+ <pairing code>
| |-+ token
|
+ 'sessions'
|-+ uid
  |-+ <session info>
  |
  + uid
  |-+ <session info>
  ...

session info
+-'current_app'
|-+ <app name>
|
+-'running_apps'
|-+ <child name>
|-+ <child name>
|
+-'events'
|-+ '-Itgelksjdfds' (push ID)
  |-+ <event info>
  |
  + '-Ifgreoijfddf' (push ID)
  |-+ <event info>

event info
+ 'type'
|-+ <event type>
|
+- 'name'
|-+ <event name>

###

module.exports = Constants
