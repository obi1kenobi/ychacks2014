Constants =
  FIREBASE: 'https://ychacks.firebaseio.com/'
  SESSIONS_CHILD: 'sessions'
  CONTEXT_CHILD: 'context'
  EVENTS_CHILD: 'events'
  EVENT_TYPE_CHILD: 'type'
  EVENT_NAME_CHILD: 'name'
  TOKENS_CHILD: 'tokens'

  PAIRING_CODE_LENGTH: 6
  PAIRING_CODE_ALGORITHM: 'sha1'

###
Firebase structure

root (/)
+ 'tokens'
|-+ <pairing code>
| |-+ token
|
|-+ <pairing code>
| |-+ token
|
+ 'sessions'
|-+ '-Ijsdfjrnesdf' (push ID)
  |-+ <session info>
  |
  + '-Ifreoijfdslk' (push ID)
  |-+ <session info>
  ...

session info
+ 'context'
|-+ <context type>
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
