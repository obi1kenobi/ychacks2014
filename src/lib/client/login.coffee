###
# getAuthToken is based on
# https://gist.githubusercontent.com/abeisgreat/9757358/raw/97dbd1aca15f336ce61f361db0dcda602672e0b3/client.js
###

async                   = require('async')
debug                   = require('debug')('client:login')
JSONP                   = require('./jsonp')
{constants}             = require('../common')
crypto                  = require('crypto')

createPairingCode = (token) ->
  sha = crypto.createHash(constants.PAIRING_CODE_ALGORITHM)
  sha.update(token)
  sha.digest('hex').substr(0, constants.PAIRING_CODE_LENGTH)

###
# cb(error, {token, user})
###
getAuthToken = (firebaseName, cb) ->
  args =
    url: 'https://auth.firebase.com/auth/anonymous',
    data: {transport: 'jsonp', firebase: firebaseName},
    success: (data) ->
      debug("Received auth token payload: #{data}")
      cb(null, data)
  JSONP(args)


Login =
  ###
  # cb(error, data)
  ###
  loginAndGetToken: (firebaseName, rootRef, tokensRef, cb) ->
    async.waterfall [
      (done) -> getAuthToken(firebaseName, done)
      ({token}, done) -> rootRef.auth(token, done)
      ({token}, done) ->
        pairingCode = createPairingCode(token)
        debug("Created pairing code #{pairingCode}")
        tokensRef.child(pairingCode).set(token)
        true
    ], cb


module.exports = Login
