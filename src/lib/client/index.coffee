child_process = require('child_process')

logDebug      = require('debug')('client:debug')
logError      = require('debug')('client:error')

x = require('./opened_apps')
apps = x.get_apps(['apple', 'iTunes', 'Spotify'], [{
  window_index: 1,
  tab_index: 1,
  tab_url: 'https://youtube.com/http?v=12345'
}, {
  window_index: 1,
  tab_index: 2,
  tab_url: 'lololol'
}, {
  window_index: 2,
  tab_index: 1,
  tab_url: 'mail.google.com/reading_some_mail_here'
}, {
  window_index: 3,
  tab_index: 3,
  tab_url: 'www.reddit.com/r/leagueoflegends'
}])

for app in apps
  app.activate()

Client =
  login: require('./login')
  scriptRunner: require('./scriptRunner')

module.exports = Client
