$(document).ready(function(){
	$('a.colorbox','#innerContent').each(function(index,element){
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