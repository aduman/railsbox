$(document).ready(function(){
  



  $('#mark_it').click(function(){
    //select all box..
    var checked = this.checked;
    $('#file-container input:checkbox').each(function(){
      if (!this.disabled){
        this.checked = checked;
      } 
    });
  });
  
  
  /*$('#bottom-bar a').overlay({
    onBeforeLoad: function(){
    $('#overlay').html('')
    }
    })*/
  //download
  $('#download-link').click(function(e){
    e.preventDefault();
    var id = getSelectedId('file', true);
    if (id!=0){
      document.location = 'assets/get/'+id;
    }else{
      alert('Please select a file via checkbox');
    }
  });
  
  $('#new-folder-link').click(function(e){
      e.preventDefault(true);
        $('#overlay').load($(this).attr('href'));
  });

  $('#hotlink-link').click(function(e){
      e.preventDefault(true);
      var id = getSelectedId('file', true);
      if (id!=0){
        $('#overlay').load('hotlink/new/'+id+' #content-holder');
      }else{
        alert('Please select a file via checkbox');
      }
  });
  

});

function getSelectedId(type, single){
  var value = $('.'+type+'Tick:checked')
  if (single){
    if (value.size() != 1){
      return 0;
    }else{
      var val = value[0].id.split('_').pop();
      return val;
    }
  }else{
    var arry = []
    $(value).each(function(a){
        arry.push($(this)[0].id.split('_').pop());
    });
    return arry;
  }  
}


