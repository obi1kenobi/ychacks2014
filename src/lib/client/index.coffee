child_process = require('child_process')

logDebug      = require('debug')('client:debug')
logError      = require('debug')('client:error')

Client =
  login: require('./login')
  scriptRunner: require('./scriptRunner')

module.exports = Client
