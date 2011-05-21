$(document).ready(function(){

  $('#form-holder').hide();

  $('#logon-link').click(function(e){
    $('#form-holder').show();
    e.preventDefault();
  });

});
