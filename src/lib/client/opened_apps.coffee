white_apps = [{
  name: 'Spotify',
  title_regex: /Spotify/
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

list_contains = (list, pred) ->
  for x in list
    if pred x
      return true
  return false

_filter_and_fetch_apps_from_titles = (app_titles) ->
  filtered = (title for title in app_titles \
    if title and list_contains white_apps, (app) -> title.match(app.title_regex))

  if filtered
    return (NativeRunningApp(title) for title in filtered)
  else
    return []

_filter_and_fetch_tabs = (tab_objects) ->
  chrome_app_from_string = (obj) ->
    return ChromeRunningApp(obj.window_index, obj.tab_index, obj.tab_url)

  return (chrome_app_from_string(tab_obj) for tab_obj in tab_objects \
    if tab_obj and list_contains white_tabs, (app) -> tab_obj.tab_url.match(app.url_regex))

class RunningApp
  constructor: (@name) ->
    console.log("Constructing app!")
    console.log(@name)

  activate: () ->
    throw new Error('Not implemented')

  equals: (o) -> o? and @name == o.name

class ChromeRunningApp
  constructor: (@name, @window_index, @tab_index) ->
    console.log('chrome ctor')
    super(@name)

  activate: () ->
    console.log("Activating chrome!")
    console.log(@name)
    console.log(@window_index)
    console.log(@tab_index)

class NativeRunningApp
  constructor: (@name) ->
    console.log('native ctor')
    super(@name)

  activate: () ->
    console.log("Activating native!")
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
    return _filter_and_fetch_apps_from_titles(app_titles) + \
      _filter_and_fetch_tabs(tab_objects)
