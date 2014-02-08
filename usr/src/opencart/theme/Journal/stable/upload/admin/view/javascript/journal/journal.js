(function($){

$(window).load(function(){
	$('#content').show();
	$('.loader').hide();
});

$(function(){

	//$('.setting_extended_filter select, .setting_preloader_visibility select, .setting_transparent_overlay select, .setting_sale_product_badge select').addClass('yes_no');
	$('.check').prettyCheckable();
	$('.yes_no').switchify();
	$('.add-image').removeClass('button').addClass('btn btn-primary');

	// $('.upload-thumb').wrap('<div class="upload-img btn-group" />');
	$('.choose-img, .clear-img').not($('.upload-thumb.choose-img')).addClass('btn btn-mini');

	//create custom select box
    function custom_select(){
		var sel = $('select').not($('.yes_no'));
		var wrap = sel.parent();
		sel.css('opacity', 0);
		sel.wrap('<div class="select-wrap" />');
		$('<span class="val"></span>').prependTo($('.select-wrap'));

		$('select').each(function(){
			var select = $(this);
		    var wrap = select.prev();
		    select.change(function () {
		        wrap.text($('option:selected', this).text());
		    });
		}).trigger('change');
	}

	//run custom select function
	custom_select();

	//apply custom select box on newly created elements
	$('td.left a, #module-add img').live('click', function(){
		$('.select-wrap > select').unwrap($('.select-wrap'));
		$('span.val').remove();
	    custom_select();
	    $('td.right input').addClass('short');	
	    $('.image').addClass('btn-group');
		$('.image a').addClass('btn btn-mini');
		$('.yes_no').switchify();
	});

	$('.image').addClass('btn-group');
	$('.image a').addClass('btn btn-mini');

	$('.ui-switch-labels').live('click', function(e) {
		e.preventDefault(); 
		return false; 
	});

});

})(jQuery);