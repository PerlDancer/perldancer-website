$(function() {
	
	$('a[rel=external]').attr('target','_blank');
  	
	setHeight('.col');

});
	
var maxHeight = 0;

function setHeight(col) {
	col = $(col);
  col.each(function() {        
		if($(this).height() > maxHeight) {
    	maxHeight = $(this).height();;
    }
  });
	col.height(maxHeight);	
};
	