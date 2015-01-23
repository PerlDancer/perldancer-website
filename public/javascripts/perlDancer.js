$(function() {
	
	$('a[rel=external]').attr('target','_blank');
  	
	setHeight('.col');

    $('#show_open_source').click(function() {
        $('.dancefloor-site').hide();
        $('.opensource').show();
    });

    $('#show_all').click(function() {
        $('.dancefloor-site').show();
    });

    $('#show_dancer2').click(function() {
        $('.dancefloor-site').hide();
        $('.dancer2').show();
    });
			
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
	
