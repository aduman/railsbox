$(document).ready(function(){
	$('a.colorbox','#content').each(function(index,element){
		if($(element).hasClass('searchUsersGroups')){
			$(element).colorbox({
				onComplete: function(){
					colorboxSearchComplete();
				}
			});
		}
		else{
			$(element).colorbox();
		}
	});
});