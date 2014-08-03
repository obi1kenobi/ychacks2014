###
# getAuthToken is based on
# https://gist.githubusercontent.com/abeisgreat/9757358/raw/97dbd1aca15f336ce61f361db0dcda602672e0b3/client.js
###

async                   = require('async')
debug                   = require('debug')('client:login')
JSONP                   = require('jsonp-client')
{constants}             = require('../common')
crypto                  = require('crypto')

createPairingCode = (token) ->
  sha = crypto.createHash(constants.PAIRING_CODE_ALGORITHM)
  sha.update(JSON.stringify token)
  sha.digest('hex').substr(0, constants.PAIRING_CODE_LENGTH)

###
# cb(error, {token, user})
###
getAuthToken = (firebaseName, cb) ->
  url = "https://auth.firebase.com/auth/anonymous?transport=jsonp&firebase=#{firebaseName}"
  JSONP url, cb


Login =
  ###
  # cb(error, {pairingCode, uid})
  ###
  loginAndSetPairingCode: (firebaseName, rootRef, tokensRef, cb) ->
    async.waterfall [
      (done) ->
        getAuthToken(firebaseName, done)
      (data, done) ->
        # debug("Auth data: #{JSON.stringify data}")
        token = data.token
        rootRef.auth data.token, (err, user) ->
          # debug("Login data: #{JSON.stringify user}")
          pairingCode = createPairingCode(token)
          tokensRef.child(pairingCode).set(token)
          result = { pairingCode, uid: user.auth.uid }
          debug("Login result: #{JSON.stringify result}")
          done(null, result)
    ], cb

  expirePairingCode: (tokensRef, pairingCode) ->
    tokensRef.child(pairingCode).set(null)

module.exports = Login
