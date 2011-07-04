$(document).ready(function(){
	function getSelected(single, type){
		if (type===undefined){
			var value = $('#file-container > .row-container > .mark-it > .tick:checked');
			if(value.size() < 1){
				alert('Please select an item');
				return false;
			}
		}
		else{
			var value = $('#file-container > .row-container > .mark-it > .'+type+'Tick:checked');
			if(value.size() < 1){
				alert('Please select a ' + type);
				return false;
			}
		}
		if(single && value.size() > 1){
			//More than 1 item selected if single is true
			alert('Please select only 1 item');
			return false;
		}
		else{
			var result = new Object();
		
			//Get Folders
			if(type===undefined || type == "folder"){
				var folders = [];
				value.filter("[id^='folder_']").each(function(index, element){
					folders.push(element.id.split('_').pop());
				});
				result.folders = folders;
			}
			
			//Get Files
			if(type===undefined || type == "file"){
				var files = [];
				value.filter("[id^='file_']").each(function(index, element){
					files.push(element.id.split('_').pop());
				});
				result.files = files;
			}
			return result;
		}
	}
	
  $('#mark_it').click(function(){
    //select all box..
    var checked = this.checked;
    $('#file-container input:checkbox').each(function(){
      if (!this.disabled){
        this.checked = checked;
      } 
    });
  });
	

	/******************** MOVE ****************/
	
	$('#move-link').click(function(e){
		e.preventDefault();
		
		var selected = getSelected(false);
		if(selected){
			if(selected.folders.length > 0 && selected.files.length > 0){
				alert('Please select either folders or files');
				return false;
			}
			else if(selected.folders.length > 0){
				$.colorbox({
				  href: '/folders/'+selected.folders.join(',')+'/move',
				  onComplete: function(){
					makeFolderStructure('#folderMove', '#allFolders_'+selected.folders.join(',#allFolders_'));
					$('#move','#cboxLoadedContent').click(function(){
						moveItems();
					});
				  }
				});
			}
			else if(selected.files.length > 0){
				$.colorbox({
				  href: '/assets/'+selected.files.join(',')+'/move',
				  onComplete: function(){
						makeFolderStructure('#folderMove', false);
					$('#move','#cboxLoadedContent').click(function(){
						moveItems();
					});
				  }
				});
			}
		}
	});
	
	//Get child elements of a folder
	function makeFolderStructure(parent, exclude){
		if(exclude==false){
			var children = $('li a',parent);
		}
		else{
			//If moving a folder exclude the current folder(s) from being selected
			var children = $('li:not("'+exclude+'") a',parent);
			$(exclude)
				.addClass('disabled')
				.click(function(){
					return false;
				});
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
	
	//When a destination folder is selected
	function moveFolderSelect(element){
		$('#selectedFolder').html($(element).html());
		$('.moveTarget','#moveForms').val($(element).parent().attr('id').split('_').pop());
		$('li a.selected','#folderMove').removeClass('selected');
		$(element).addClass('selected');
	}
	
	//Execute move
	function moveItems(){
		var forms = $('form','#moveForms');
		var completed = 0;
		$(forms).each(function(index,element){
			$.ajax({
				type: 'POST',
				url: $(element).attr('action'),
				data: $(element).serialize(),
				complete: function(){
					completed++;
					if (forms.length==completed){
						window.location.reload();
					}
				}
			});
		});
	}
	
	/**************END OF MOVE*****************/

  $('#upload-link, #new-folder-link').colorbox();
  
  
	//download
	$('#download-link').click(function(e){
		var selected = getSelected(true,'file');
		if (selected.files > 0){
			document.location = 'assets/get/'+selected.files[0];
		}
		return false;
	});
  
	//rename
	$('#rename-link').click(function(e){
		var selected = getSelected(true);
		if (selected.folders > 0){
			$.colorbox({
			  href: '/folders/'+selected.folders[0]+'/rename'
			});
		}
		else if (selected.files > 0){
			$.colorbox({
			  href: '/assets/'+selected.files[0]+'/rename'
			});
		}
		return false;
	});
  
  //details
	$('#details-link').click(function(e){
		var selected = getSelected(true);
		if (selected.folders > 0){
			$.colorbox({
			  href: '/folders/details/' + selected.folders[0]
			});
		}
		else if (selected.files > 0){
			$.colorbox({
			  href: '/assets/'+selected.files[0]
			});
		}
		return false;
	});
  
  //hotlink  
	$('#hotlink-link').click(function(e){
		e.preventDefault(true);
		var selected = getSelected(true,'file');
		if (selected){
			$.colorbox({
				href: '/hotlink/new/'+selected.files[0]
			});
		}
	});
  
	$('#delete-link').click(function(){
		if(confirm('Are you sure?')){
			$('#file-container > .row-container > .mark-it > .tick:checked').next('form').each(function(index,element){
				$.ajax({
					type: 'DELETE',
					url: $(element).attr('action'),
					data: $(element).serialize(),
					success: function(){
						$(element).closest('.row-container').slideUp();
					}
				});
			});
		}
		return false;
	});
})