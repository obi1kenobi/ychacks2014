/* app.js */


var current_icon = 0;

$(function() {

  var $app_icon = $('.app_icon');
  var $app_icons = $('.app_icons');


  $('.button').on("touchstart", function(){
    $(this).addClass('active');
    $(this).removeClass('finished');
  });
  $('.button').on("touchend", function(){
    $(this).removeClass('active');
    $(this).addClass('finished');
  });

  $app_icon.on("touchstart", function(){
    $(this).addClass('grow');
    $(this).removeClass('shrink');
    $('.popovers').removeClass('bounce');
  });

  $app_icon.on("touchend", function(){

    var icon_index = Number($(this).data("icon-id"));

    if (icon_index == current_icon){
      $('.popovers').toggleClass('active');
    }

    $(this).addClass('shrink');
    $(this).removeClass('grow');

    elementSpringTo("#caret", icon_index*95 + 45, 150, [50, 10, 2]);
    $('.popovers').addClass('bounce');

    setTimeout(function(){
      $('.controlset').removeClass('active');
      $('.controlset[data-icon-id="'+icon_index + '"]').addClass('active');
    }, 200);
  });

  // Register callbacks
  LOGIN.onServerDisconnect(function() {
    window.location = '/index.html';
  });

  // TODO(ddoucet): everything needs to start as display:none
  // and then onAdded, we change it to display:block or whatever

  // TODO(ddoucet): add click handlers for changing current app
  // TODO(ddoucet): add click handlers to send command
  var runningApps = [];

  LOGIN.onAddedRunningApp(function(name) {
    // TODO
  });

  LOGIN.onRemovedRunningApp(function(name) {
    // TODO0
  });
});

