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
      }

      var $app_icon = $('.app_icon');
      var $app_icons = $('.app_icons');


      $('.button').on("touchstart", function(){
        $(this).addClass('active');
        $(this).removeClass('finished');

        var type = $(this).attr('data-type');
        var command = $(this).attr('data-command');
        LOGIN.executeCommand(type, command);
      });

      $('.button').on("touchend", function(){
        $(this).removeClass('active');
        $(this).addClass('finished');
      });

      var onAppTouchStart = function($this) {
        var icon_index = Number($this.data("icon-id"));
        if(disabled_apps[icon_index]) {
          return
        }

        $this.addClass('grow');
        $this.removeClass('shrink');
        $('.popovers').removeClass('bounce');
      }

      var onAppTouchEnd = function($this) {
        var dict = {
          0: 'Youtube',
          1: 'Facebook',
          2: 'Gmail',
          3: 'Spotify',
          4: 'Reddit',
          5: 'Netflix'
        };

        var icon_index = Number($this.data("icon-id"));
        if (disabled_apps[icon_index]) {
          return
        }
        console.log(dict[icon_index]);
        if (dict[icon_index] !== undefined) {
          console.log("Setting to " + dict[icon_index]);
          LOGIN.setCurrentApp(dict[icon_index]);
        }
        console.log(icon_index);

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

        $this.addClass('shrink');
        $this.removeClass('grow');

        var caretIndex =  (icon_index % 3);
        elementSpringTo("#caret", caretIndex*95 + 45, 150, [50, 10, 2]);
        $('.popovers').addClass('bounce');

        //setTimeout(function(){
          $('.controlset').removeClass('active');
          $('.controlset[data-icon-id="'+icon_index + '"]').addClass('active');
        //}, 200);
      }

      $app_icon.on("touchstart", function() {
        onAppTouchStart($(this));
      });

      $app_icon.on("touchend", function() {
        onAppTouchEnd($(this));
      });

      // Register callbacks
      LOGIN.onServerDisconnect(function() {
        window.location = '/index.html';
      });

      LOGIN.onCurrentAppChanged(function(name) {
        if (name === "UNKNOWN") {
          $('.popovers').removeClass('active');
          popover_closed = true;
          elementSpringTo("#caret", 150, 1550, [50, 10, 2]);
          $(".app_icons").css({"-webkit-transform": "translateY(0px)"});
          return;
        }

        var dict = {
          'Youtube': 0,
          'Facebook': 1,
          'Gmail': 2,
          'Spotify': 3,
          'Reddit': 4,
          'Netflix': 5
        };

        var appIconId = dict[name];

        if (appIconId === undefined) {
          console.log("Couldn't find app");
          return;
        }

        console.log("Trying to set to " + name);
        var button = $('div.app_icon[data-icon-id=' + appIconId + ']');

        console.log(button);

        onAppTouchStart(button);
        onAppTouchEnd(button);
      });

      var disabled_apps = {};

      function disable_app(name) {
        var dict = {
          'Youtube': 0,
          'Facebook': 1,
          'Gmail': 2,
          'Spotify': 3,
          'Reddit': 4,
          'Netflix': 5
        };
        if(disabled_apps[name] == undefined || !disabled_apps[name]) {
          disabled_apps[name] = true;
          $('div.app_icon[data-icon-id=' + dict[name] + ']').addClass('grey');
        }
      }

      function enable_app(name) {
        var dict = {
          'Youtube': 0,
          'Facebook': 1,
          'Gmail': 2,
          'Spotify': 3,
          'Reddit': 4,
          'Netflix': 5
        };
        if(disabled_apps[name] == undefined || !disabled_apps[name]) {
          return
        }
        disabled_apps[name] = false;
        $('div.app_icon[data-icon-id=' + dict[name] + ']').removeClass('grey');
      }

      LOGIN.onAddedRunningApp(function(name) {
        enable_app(name)
      });

      LOGIN.onRemovedRunningApp(function(name) {
        disable_app(name)
      }); 
    }
  });
});

