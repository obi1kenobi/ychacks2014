/* app.js */


var current_icon = 0;
var popover_closed = true;

$(function() {

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

});

