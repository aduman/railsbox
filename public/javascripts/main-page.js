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

	function getSelectedId(type, single){
	  var value = $('#file-container > .row-container > .mark-it > .'+type+'Tick:checked');
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
	

	//Move
	function moveFolderSelect(element){
		$('#selectedFolder').html($(element).html());
		$('#asset_folder_id, #folder_parent_id').val($(element).parent().attr('id').split('_').pop());
		$('li a.selected','#folderMove').removeClass('selected');
		$(element).addClass('selected');
	}

	function makeFolderStructure(parent, exclude){
		if(exclude==false){
			var children = $('li a',parent);
		}
		else{
			//If moving a folder exclude the current folder from being selected
			var children = $('li:not("'+exclude+'") a',parent);
			$(exclude).hide();
		}
		$(children).toggle(
			//Open
			function(){
				if($(this).parent().find('ul:first').length > 0){
					//already got folders
					$(this).parent().find('ul:first').show();
				}
				else{
					//Get folders
					$('#moveDialogLoading').show();
					var x = this;
					$.get($(x).attr('href'),function(data){
						$(x).parent().append(data);
						makeFolderStructure($(x).parent().find('ul:first'), exclude);
						$('#moveDialogLoading').hide();
					});
				}
				moveFolderSelect(this);
				$(this).addClass('opened');
				return false;
			},
			//Hide
			function(){
				$(this)
					.removeClass('opened')
					.parent()
					.find('ul:first')
						.hide();
				moveFolderSelect(this);
				return false;
			}
		);
	}

	$('#move-link').click(function(e){
		e.preventDefault();
		var id = getSelectedId('folder', true);
		if (id!=0){
			$.colorbox({
			  href: '/folders/'+id+'/move',
			  onComplete: function(){
				makeFolderStructure('#folderMove', '#allFolders_'+id);
			  }
			});
		}
		else{
		  //try file
		  id = getSelectedId('file',true);
		  if (id!=0){
			$.colorbox({
			  href: '/assets/'+id+'/move',
			  onComplete: function(){
				makeFolderStructure('#folderMove', false);
			  }
			});
		  }
		  else{
			alert('Please select a file or folder via checkbox');
		  }
		}
	});

  $('#upload-link, #new-folder-link').colorbox();
  
  
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
  
  //rename
  $('#rename-link').click(function(e){
	e.preventDefault();
    var id = getSelectedId('folder', true);
    if (id!=0){
        $.colorbox({
          href: '/folders/'+id+'/rename'
        });
    }else{
      //try file
      id = getSelectedId('file', true);
      if (id!=0){
        $.colorbox({
          href: '/assets/'+id+'/rename'
        });
      }else{
        alert('Please select a file or folder via checkbox');
      }
    }
  });
  
  //details
  $('#details-link').click(function(e){
    e.preventDefault();
    var id = getSelectedId('folder', true);
    if (id!=0){
        $.colorbox({
          href: '/folders/details/'+id
        });
    }else{
      //try file
      id = getSelectedId('file', true);
      if (id!=0){
        $.colorbox({
          href: '/assets/'+id
        });
      }else{
        alert('Please select a file or folder via checkbox');
      }
    }
  });
  
  //hotlink  
  $('#hotlink-link').click(function(e){
      e.preventDefault(true);
      var id = getSelectedId('file', true);
      if (id!=0){
        $.colorbox({
          href: '/hotlink/new/'+id
		});
      }else{
        alert('Please select a file via checkbox');
      }
  });
  
	$('#delete-link').click(function(){
		if(confirm('Are you sure?')){
			$('#file-container > .row-container > .mark-it > .tick:checked').next('form').each(function(index,element){
				$.ajax({
					type: 'DELETE',
					url: $(element).attr('action'),
					data: 'authenticity_token=' + $('input[name="authenticity_token"]:first',element).val() +'&utf8=' + $('input[name="utf8"]:first',element).val(),
					success: function(){
						$(element).closest('.row-container').slideUp();
					}
				});
			});
		}
		return false;
	});
});