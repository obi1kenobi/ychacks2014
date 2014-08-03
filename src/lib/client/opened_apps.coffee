white_apps = [{
  name: 'Spotify',
  title_regex: /^Spotify$/
}]

white_tabs = [{
  name: 'Reddit',
  url_regex: /reddit\.com/
}, {
  name: 'Youtube',
  url_regex: /youtube\.com/
}, {
  name: 'Gmail',
  url_regex: /mail\.google\.com/
}, {
  name: 'Facebook',
  url_regex: /facebook\.com/
}, {
  name: 'Netflix',
  url_regex: /netflix.com\/WiPlayer?movieid/
}]

find = (list, pred) ->
  for x in list
    if pred x
      return x
  return null

_filter_and_fetch_apps_from_titles = (app_titles) ->
  apps = (find(white_apps, (app) -> title.match(app.title_regex)?) \
    for title in app_titles)
  filtered = (app for app in apps when app?)

  if filtered
    return (new NativeRunningApp(app.name) for app in filtered)
  else
    return []

_filter_and_fetch_tabs = (tab_objects) ->
  chrome_app_from_string = (obj) ->
    return new ChromeRunningApp(obj.window_index, obj.tab_index, obj.tab_url)

  tabs = ({tab_object: tab_obj, tab: \
      find(white_tabs, (tab) -> tab_obj.tab_url.match(tab.url_regex)?) } \
    for tab_obj in tab_objects)
  filtered = (tab for tab in tabs when tab.tab?)

  return (new ChromeRunningApp(x.tab_object.window_index, x.tab_object.tab_index, x.tab.name) \
    for x in filtered)

class RunningApp
  constructor: (@name) ->

  activate: () ->
    throw new Error('Not implemented')

  equals: (o) -> o? and @name == o.name

class ChromeRunningApp extends RunningApp
  constructor: (@window_index, @tab_index, @name) ->
    super(@name)

  activate: () ->
    console.log(@name)

class NativeRunningApp extends RunningApp
  constructor: (@name) ->
    super(@name)

  activate: () ->
    console.log(@name)

# The AppState only considers a list of names, e.g. ['Youtube', 'Spotify', 'Reddit']
# When we scan the list of currently running apps, filter them to get the names and
# then pass the list of currently running app names to the app state's update_app_state
# method. It will make db inserts that will cause the mobile app to update.
class AppState
  update_app_state: (current_apps) ->

  _on_app_inserted: (app) ->

  _on_app_removed: (app) ->


module.exports =
  # list of strings, list of {window_index, tab_index, tab_url}
  get_apps: (app_titles, tab_objects) ->
    native_apps = _filter_and_fetch_apps_from_titles(app_titles)
    tab_apps = _filter_and_fetch_tabs(tab_objects)

    return native_apps.concat(tab_apps)
