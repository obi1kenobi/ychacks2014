firebase = new Firebase('https://pageapp.firebaseio.com/web/data')

auth = new FirebaseSimpleLogin(firebase, (error, user) ->
  if error
    # an error occurred while attempting login
    console.log error
  else if user
    console.log user
    console.log "User ID: " + user.uid + ", Provider: " + user.provider
)

facebook_auth_ags =
  rememberMe: true,
  scope: 'email,user_friends,xmpp_login'

auth.login 'facebook', facebook_auth_ags
