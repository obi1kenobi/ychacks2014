/* app.js */


var icon_offset = 0;

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
    var new_icon_offset = -93*icon_index;


    $(this).addClass('shrink');
    $(this).removeClass('grow');

    elementSpringTo("#caret", icon_index*95 + 45, 150, [50, 10, 2]);
    $('.popovers').addClass('bounce');

    setTimeout(function(){
      $('.controlset').removeClass('active');
      $('.controlset[data-icon-id="'+icon_index + '"]').addClass('active');
    }, 200);  
    

  });

});

