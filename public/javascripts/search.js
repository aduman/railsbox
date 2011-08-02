function getResults(form, successFunction){
	$('#searchResult').addClass('loading');	
	$.ajax({
		type: 'POST',
		url: $(form).attr('action'),
		data: $(form).serialize(),
		success: function(data){
			$('#searchResult').html(data).removeClass('loading');
			
			//If success function is defined 
			if (typeof successFunction == 'function'){
				successFunction(data);
			}
		}
	});
}

function makeSearchForms(form, successFunction){
	$(form).submit(function(){
		getResults(form, successFunction);
		return false;
	});
	
	$('input[type="text"]',form).keyup(function(){
		getResults(form, successFunction);
	});
	
	$('#inactive').change(function(){
		getResults(form, successFunction);
	});
	getResults(form, successFunction);
	$('#searchButton').hide();
}

function colorboxSearchComplete(){
	var form = $('form:first','#userGroupSearch');
	makeSearchForms(form, function(){
		$('#searchResult').addClass('selectable');
		$.colorbox.resize();
		$('#query').focus();
		$('li a','#searchResult').click(function(){
			$('li a.selected','#searchResult').removeClass('selected');
			$(this).addClass('selected');
			return false;
		});
	});
	
	$('#new_permission, #new_user_group').submit(function(){
		var selected = $('a.selected:first','#searchResult');
		var form = $(this);
		if (selected.length != 1){
			alert('Nothing Selected');
			return false;
		}
		else{
			//Add User to Group form
			$('#user_group_user_id','#new_user_group').val($(selected).attr('href').split('/users/')[1]);
			
			//Add Permission Form
			$('#permission_parent','#new_permission').val($(selected).attr('href'));
		}
		
	});
}
	
$(document).ready(function(){
	var form = $('#userGroupSearchForm');
	if(form.length>0){
		makeSearchForms(form);
	}
	
});

