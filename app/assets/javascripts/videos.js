$(document).ready(function(){
  $('.datetimepicker').datetimepicker({
    icons: {   date: 'fa fa-calendar',
                time: 'fa fa-clock-o',
                up: 'fa fa-chevron-up',
                down: 'fa fa-chevron-down'},
    sideBySide: true
  });

  $('#video_expires_at').on('focusin', function(e){
    $('.input-group.datetimepicker button').click();
  });

  if ( $('#form_offset').length > 0 ){
    var d = new Date();
    $('#form_offset').val(d.getTimezoneOffset());
  } 
});