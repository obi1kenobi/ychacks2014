firebase                       = require('firebase')
debug                          = require('debug')('firebase:index')
{ config, constants }          = require('../common')

FirebaseManager =
  rootRef: new Firebase(constants.FIREBASE)


module.exports = FirebaseManager(constants.FIREBASE)
