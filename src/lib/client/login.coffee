###
# getAuthToken is based on
# https://gist.githubusercontent.com/abeisgreat/9757358/raw/97dbd1aca15f336ce61f361db0dcda602672e0b3/client.js
###

async                   = require('async')
debug                   = require('debug')('client:login')
JSONP                   = require('jsonp-client')
{constants}             = require('../common')
crypto                  = require('crypto')

hexValue = (char) ->
  switch char
    when '0' then 0
    when '1' then 1
    when '2' then 2
    when '3' then 3
    when '4' then 4
    when '5' then 5
    when '6' then 6
    when '7' then 7
    when '8' then 8
    when '9' then 9
    when 'a', 'A' then 10
    when 'b', 'B' then 11
    when 'c', 'C' then 12
    when 'd', 'D' then 13
    when 'e', 'E' then 14
    when 'f', 'F' then 15

createPairingCode = (token) ->
  sha = crypto.createHash(constants.PAIRING_CODE_ALGORITHM)
  sha.update(JSON.stringify token)
  hex = sha.digest('hex').substr(0, constants.PAIRING_CODE_LENGTH)
  total = 0
  for i in [0...hex.length]
    total *= 16
    total += hexValue(hex.charAt(i))
  total %= constants.PAIRING_CODE_MODULUS
  pairingCode = total.toString()
  while pairingCode.length < constants.PAIRING_CODE_LENGTH
    pairingCode = '0' + pairingCode
  pairingCode

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
          tokensRef.child(pairingCode).onDisconnect().set(null)
          result = { pairingCode, uid: user.auth.uid }
          debug("Login result: #{JSON.stringify result}")
          done(null, result)
    ], cb

  expirePairingCode: (tokensRef, pairingCode) ->
    tokensRef.child(pairingCode).set(null)

module.exports = Login
