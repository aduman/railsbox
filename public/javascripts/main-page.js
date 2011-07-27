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
		var path = "";
		var x = $(element);
		do{
			if(path != ""){
				path = x.html() + "/" + path;
			}
			else{
				path = x.html();
			}
			x = x.closest('ul').prev('a')
		}
		while(x.length > 0);
		$('#selectedFolder').html(path);
		$('.moveTarget','#moveForms').val($(element).parent().attr('id').split('_').pop());		//add folder id to each of the input boxes
		$('li a.selected','#folderMove').removeClass('selected');
		$(element).addClass('selected');
		$.colorbox.resize();
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
	
	/**************Details*****************/
	
	function getDetails(isFolder, href){
		if (isFolder){
			$.colorbox({
				href: href,
				onComplete: function(){
					$('a.edit:first','#cboxLoadedContent').click(function(){
						$('#rename-link').trigger('click');
						return false;
					});
					$('li .permName a','#permissions').colorbox({
						onComplete: function(){
							$('a.back:first','#cboxLoadedContent').click(function(){
								getDetails(isFolder, href);
								return false;
							});
							$('a.delete:first','#cboxLoadedContent').click(function(){
								var form = $('.edit_permission:first','#cboxLoadedContent');
								if (confirm('Are you sure you want to delete this permission?')){
									$.ajax({
										type: 'DELETE',
										url: $(form).attr('action'),
										data: $(form).serialize(),
										success: function(data, textStatus, jqXHR){
											if(textStatus == "success"){
												getDetails(isFolder, href);
											}
										}
									});
								}								
								return false;
							});
							$('.edit_permission:first','#cboxLoadedContent').submit(function(){
								$.ajax({
									type: 'POST',
									url: $(this).attr('action'),
									data: $(this).serialize(),
									success: function(data, textStatus, jqXHR){
										if(textStatus == "success"){
											getDetails(isFolder, href);
										}
									}
								});
								return false;
							});
							
						}
					});
					$('a.addPermission:first','#cboxLoadedContent').colorbox({
						onComplete: function(){
							colorboxSearchComplete();
							$('a.back:first','#cboxLoadedContent').click(function(){
								getDetails(isFolder, href);
								return false;
							});
							$('#new_permission').submit(function(){
								$.ajax({
									type: 'POST',
									url: $('#new_permission').attr('action'),
									data: $('#new_permission').serialize(),
									success: function(data, textStatus, jqXHR){
										if(textStatus == "success"){
											getDetails(isFolder, href);
										}
									}
								});
								return false;
							});
						}
					});					
				}
			});
		}
		else{
			//is a file
			$.colorbox({
			  href: href,
			  onComplete: function(){
				$('a.edit:first','#cboxLoadedContent').click(function(){
					$('#rename-link').trigger('click');
					return false;
				});
				$('a.createLink:first','#cboxLoadedContent').colorbox({
					onComplete: function(){
						hotlinkMakeForm();
					}
				});
			  }
			});
		}
	}
	
	//Individual details button
	$('.row-container','#file-container').each(function(index,element){
		$('div.name:first a.details:first',element).click(function(){			
			getDetails($(this).closest('.row-container').hasClass('folder'),$(this).attr('href'));
			return false;
			//getDetails(true, );
		});
	});
	
	//Details bottom bar button
	$('#details-link').click(function(e){
		var selected = getSelected(true);
		if (selected.folders > 0){
			getDetails(true, '/folders/details/' + selected.folders[0]);
		}
		else if (selected.files > 0){
			getDetails(false, '/assets/' + selected.files[0]);
		}
		return false;
	});	
	
	/**************End of Details*****************/

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
  
  
  
  //hotlink  
	$('#hotlink-link').click(function(e){
		e.preventDefault(true);
		var selected = getSelected(true,'file');
		if (selected){
			$.colorbox({
				href: '/hotlink/new/'+selected.files[0],
				onComplete: function(){
					hotlinkMakeForm();
				}
			});
		}
	});
	
	function hotlinkMakeForm(){
		$('#new_hotlink').submit(function(e){
			e.preventDefault();
			var valid = true;
			if(!/^\d{0,}$/.match($('#hotlink_days').val().trim())){
				valid = false;
				$('#hotlink_days').addClass('error');
			}
			else{
				$('#hotlink_days').removeClass('error');
			}
			if($('#hotlink_link').val().trim() == ""){
				valid = false;
				$('#hotlink_link').addClass('error');
			}
			else{
				$('#hotlink_link').removeClass('error');
			}
			if (valid==true){
				$.ajax({
					type: 'POST',
					url: $('#new_hotlink').attr('action'),
					data: $('#new_hotlink').serialize(),
					success: function(data, textStatus, jqXHR){
						$.colorbox({
							html: $('#content',data).html(),
							onComplete: function(){
								$('#link').click(function(){
									$(this).select();
								});
							}
						});
						
					}
				});
			}
			else{
				$('#hotlinkError').show();
				$.colorbox.resize();
			}
			return false;
		});
	}
  
	$('#delete-link').click(function(){
		var toDelete = $('#file-container > .row-container > .mark-it > .tick:checked');
		if(confirm('Are you sure you want to delete '+toDelete.length+' items?')){
			$(toDelete).next('form').each(function(index,element){
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
});