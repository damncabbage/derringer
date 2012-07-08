$(document).ready(function(){

  var $order = $('#order');

  // Toggle buttons.
  $button = $('ul.orders button', $order);
  $button.button();
  $button.on('click',function(e){
    alert($(e.target));
  });

});
