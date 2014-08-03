/* app.js */


var current_icon = 0;
var popover_closed = true;

$(function() {

  LOGIN.auth(function(err, uid) {
    if (err) {
      throw err;
    } else {
      document.ontouchmove = function(event){
          event.preventDefault();
      };

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

        if (icon_index == current_icon || popover_closed==true){
          $('.popovers').toggleClass('active');
          popover_closed = !popover_closed;
          if (popover_closed == true){
            elementSpringTo("#caret", 150, 1550, [50, 10, 2]);
            $(".app_icons").css({"-webkit-transform": "translateY(0px)"});
          }
        }
        if (popover_closed == false){
          var app_row = (icon_index - (icon_index % 3))/3
          $(".app_icons").css({"-webkit-transform": "translateY(" + -120*app_row + "px)"});
        }
        current_icon = icon_index;

        $(this).addClass('shrink');
        $(this).removeClass('grow');

        var caretIndex =  (icon_index % 3);
        elementSpringTo("#caret", caretIndex*95 + 45, 150, [50, 10, 2]);
        $('.popovers').addClass('bounce');

        //setTimeout(function(){
          $('.controlset').removeClass('active');
          $('.controlset[data-icon-id="'+icon_index + '"]').addClass('active');
        //}, 200);
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


      document.ontouchmove = function(event){
          event.preventDefault();
      }

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

        if (icon_index == current_icon || popover_closed==true){
          $('.popovers').toggleClass('active');
          popover_closed = !popover_closed;
          if (popover_closed == true){
            elementSpringTo("#caret", 150, 1550, [50, 10, 2]);
            $(".app_icons").css({"-webkit-transform": "translateY(0px)"});
          }
        }
        if (popover_closed == false){
          var app_row = (icon_index - (icon_index % 3))/3
          $(".app_icons").css({"-webkit-transform": "translateY(" + -120*app_row + "px)"});
        }
        current_icon = icon_index;

        $(this).addClass('shrink');
        $(this).removeClass('grow');

        var caretIndex =  (icon_index % 3);
        elementSpringTo("#caret", caretIndex*95 + 45, 150, [50, 10, 2]);
        $('.popovers').addClass('bounce');

        //setTimeout(function(){
          $('.controlset').removeClass('active');
          $('.controlset[data-icon-id="'+icon_index + '"]').addClass('active');
        //}, 200);
      });

      $('.app-button').on('touchstart', function() {
        var type = $(this).attr('data-type');
        var command = $(this).attr('data-command');
        alert('type: ' + type + '; command: ' + command);
      });
    }
  });
});

