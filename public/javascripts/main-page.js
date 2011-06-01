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
  
  
  //details
  $('#details-link').click(function(e){
    e.preventDefault();
    var id = getSelectedId('folder', true);
    if (id!=0){
      document.location = 'folders/details/'+id;
    }else{
      //try file
      id = getSelectedId('file', true);
      if (id!=0){
        document.location = 'assets/'+id;
      }else{
        alert('Please select a file or folder via checkbox');
      }
    }
  });
  
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

  //hotlink  
  $('#hotlink-link').click(function(e){
      e.preventDefault(true);
      var id = getSelectedId('file', true);
      if (id!=0){
        document.location = 'hotlink/new/'+id;
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


