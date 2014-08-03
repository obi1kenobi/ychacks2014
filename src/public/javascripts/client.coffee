firebase = new Firebase('https://ychacks.firebaseio.com/sessions/test/events/')

send_command = (type, name) ->
  firebase.push {type, name}

make_command = (type, name) ->
  return {type, name}

data = [
  make_command('facebook', 'like')
  make_command('gmail', 'archive')
  make_command('gmail', 'undo')
  make_command('lists', 'back')
  make_command('lists', 'down')
  make_command('lists', 'open')
  make_command('lists', 'select')
  make_command('lists', 'up')
  make_command('media', 'volume_up')
  make_command('media', 'volume_down')
  make_command('netflix', 'play')
  make_command('netflix', 'pause')
  make_command('reddit', 'upvote')
  make_command('reddit', 'downvote')
]

make_command_sender = (command) ->
  return () ->
    send_command(command.type, command.name)

for command in data
  $('#commands')
    .append(
      $('<div>')
        .append(
          $('<a>')
            .text(command.type + ': ' + command.name)
            .click(make_command_sender(command))))
