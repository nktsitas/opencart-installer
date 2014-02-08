/*
	Journal - Premium & Responsive OpenCart Theme
	Version 1.2.0
	Copyright (c) 2013 Digital Atelier
	http://journal.digital-atelier.com/
	--
	MAIN JS FILE
*/

(function($){

	if (responsive_design) {
		$('html').addClass('responsive');
	}

	//cart hover
	function add_cart_hover() {
		var $cart = $('#cart');
		var timeout;
		$('#cart > .heading a').die('mouseover').die('click').live('mouseover', function() {
			if ($cart.hasClass('journal-active')) return false;

			$cart.addClass('journal-active');

			$cart.load('index.php?route=module/cart #cart > *', function() {
				if (!$cart.hasClass('journal-active')) return false;
				clearTimeout(timeout);
				timeout = setTimeout(function(){
					$cart.addClass('active');
				}, 100);
			});
		});
		$cart.die('mouseleave').live('mouseleave', function(){
			clearTimeout(timeout);
			$cart.removeClass('active').removeClass('journal-active');
		});
	}

	function add_cart_click() {
		var $cart = $('#cart');
		if ($('.android').length) {
			$("#cart").click(function(){
				parent.window.location = "index.php?route=checkout/cart";
			});
			return;
		}
		var timeout;
		$('#cart > .heading a').die('mouseover').die('click').live('click', function() {
			if ($cart.hasClass('active')) {
				clearTimeout(timeout);
				$cart.removeClass('active');
			} else {
				$cart.load('index.php?route=module/cart #cart > *', function() {
				timeout = setTimeout(function(){
					$cart.addClass('active');
				}, 100);
			});
			}
		});
		$cart.die('mouseleave');
	}

	//hide preloader
	$(window).load(function(){
		$(".loader").delay(100).fadeOut(350, "easeOutQuart");
		setTimeout(function(){
			$("#bgslider").show();
		}, 1000);
	});

	$(document).ready(function(){
		/* change first and last links on pagination */
		var $pag_first_link = $('.pagination .links a:first-child');
		if ($pag_first_link.html() === '|&lt;') {
			$pag_first_link.html('&#171;');
		}
		var $pag_last_link = $('.pagination .links a').last();
		if ($pag_last_link.html() === '&gt;|') {
			$pag_last_link.html('&#187;');
		}

		/* disable default opencart cart event */
		$('#cart > .heading a').die('click');

		/* products image effects */
		(function(){
			var $img = $('#image');
			if (!$img.length) return;
			$img.elevateZoom();
			$('.product-info .image-additional a').click(function(e){
				/* change big thumb */
				$img.attr('src', $(this).attr('href'));
				$img.parent().attr('href', $(this).attr('href'));
				/* change zoom image */
				$img.data('elevateZoom').swaptheimage($(this).attr('href'), $(this).attr('href'));
				return false;
			});

			$('#first-a').click(function(e){
				if ($(window).width() < 980) {
					return true;
				}
				e.preventDefault();
				$('.colorbox').colorbox({open: true, rel: 'colorbox', transition: 'none'});
				return false;
			});
		})();


	  //add sequential class names to menu items
	  $('.top-links a').each(function(i) {
     	$(this).addClass('item'+(i+1));
   	  });
   	  $('#menu > ul > li > a').each(function(i) {
     	$(this).addClass('link'+(i+1));
   	  });
   	  $('#menu > ul > li > div ul li a').each(function(i) {
     	$(this).addClass('sub-link'+(i+1));
   	  });

   	  //global resize call
	  $(window).resize();

	  //sort orders
	  $('#cboxOverlay').topZIndex();
	  $('#colorbox').topZIndex();
	  $('#cboxWrapper > div:eq(1)').topZIndex();
	  $('.loader').topZIndex();

	  //positions
	  $('#content .journal-slider, #content .slideshow, #content .banner, .breadcrumb').each(function(){ $('header').after($(this));});
	  $('.home').parent().addClass('home-container')
	  $('.tags a:empty').parent().hide();
	  $('<div class="column-head"></div>').prependTo($('#column-right'));
	  $('#content h1').prependTo($('#content'));

	  //Blog Manager
	  $('.relProduct').css('width','');
	  $('a.button span').contents().unwrap();
	  $('.boxPlain').removeClass('boxPlain');
	  $('#column-right .recentComments, #column-right .popularArticles, #column-right .recentArticles').parent().removeClass('box-content').addClass('box-product');
	  $('#column-right .recentComments, #column-right .popularArticles, #column-right .recentArticles').each(function(){ $(this).addClass('prod');});
	  $('#tab-related-article').appendTo( $('#content'));
	  $('#tab-related-article > ul > li').each(function(){
	  	  var a1 = $(this).find('a').first();
	  	  var a2 = a1.next();
	  	  a2.insertBefore(a1);
	  });


	  //categories menu flexible width
	  $('#menu > ul > li > div > ul > li').each(function() {
	      var x = $(this).parent().parent().parent().width() + "px";
	      $(this).css("min-width", x);
	      $('.-moz- #menu > ul > li > div > ul').css("width", x);
	  });

	  /* ie8 hover fix !*/
	  	$('.ie8 #menu > ul > li').hover(function(){
			$(this).find('div').css('filter', 'alpha(opacity=100)');
		}, function(){
			$(this).find('div').css('filter', 'alpha(opacity=0)');
		});

	  //product-over
	  $('.product-grid > div > .image a, .box-product .image a').prepend($('<div class="product-over"></div>'));


	  //center additonal product images if < 4
	  var count = $('.product-info .image-additional').children().length;
	  if(count < 4){
		$('.product-info .image-additional').css('text-align','center');
	  }

	  //journal banners min-height
	  var count = $('.journal-boxes ul').children().length;
	  if(count > 1){
		$('.journal-boxes ul').css('min-height','100px');
	  }


	  $('#content .welcome + p').addClass('welcome-copy');

	  //border for login screen
	  $('<hr>').insertBefore($('.login-content .button'));

	  if(!$('.breadcrumb').next().is($('#container'))){
	  		$('.breadcrumb').css('border','none');
	  }

	  //remove sale badge from columns
	  $('#column-right').find( $('.sale')).remove();

	  //column full height background
	  var cr = $('#column-right').parent();
	  cr.prepend($('<div class="side-shade"></div>'));

	  var liActive = $('#column-right .box-content ul li a.active').parent();
	  liActive.addClass('active');

	$(window).scroll(function () {
		if ($(this).scrollTop() > 300) {
			$('.back-top').fadeIn();
		} else {
			$('.back-top').fadeOut();
		}
	});

    // scroll body to 0px on click
    $('.back-top').click(function () {
      $('body, html').animate({
        scrollTop: 0
      }, 800, "easeInOutQuart");
      return false;
    });

	  //responsive
	  function responsive_980() {

	  	if( $(window).width() < 980 && responsive_design ){
	  		$('.product-info .image a').removeClass('zoom').addClass('colorbox');
	  		$('#journal-header .cart').before($('#journal-header .welcome'));
	        $('#journal-header .cart').before($('#journal-header #search'));
	        $('.top-row').after($('.fb'));
	        $('.fb-box').hide();
	        add_cart_click();
	    } else {
	        $('#journal-header #search').before($('#journal-header .cart'));
	        $('#journal-header .welcome').before($('#journal-header .cart'));
	       	$('.fb-box').show();
	       	$('.fb').appendTo($('.fb-box'));
	        add_cart_hover();
	     }
	  }

	  function responsive_760(){
	  	if (!responsive_design) return;
	  	$('#menu > ul li.open').unbind('click');

	  	if( $(window).width() < 760 ){
	        $('#menu > ul').addClass('mobile-nav');
	        var $this = $('#menu > ul li.open');
			var $menu = $('#menu > ul');
		    $this.toggle(function(){
			  $menu.animate({height: $menu[0].scrollHeight+'px'}, 400);
			}, function(){
			  $menu.animate({height: '40px'}, 400);
			});
	        $('#menu > ul').css('overflow','hidden');
	      	$('.login-content .left').before($('.login-content .right'));
	      	$('#powered div p').appendTo( $('#powered div'));
	      	return;
	    }

        $('#menu > ul').removeClass('mobile-nav');
        $('#menu > ul').css('height','40px');
        $('#menu > ul').css('overflow','auto');
      	$('.login-content .right').before($('.login-content .left'));
	  }

		function responsive_470(){
			if( $(window).width() < 470 ){
				$('.checkout-product tfoot tr td:first-child').each(function(){
					$(this).attr('colspan','3');
				});
				$('.top-links a').each(function(){
					if ($(this).find('img').length > 0) {
						$(this).find('span').hide();
					}
				});
			} else{
				$('.checkout-product tfoot tr td:first-child').each(function(){
					$(this).attr('colspan','4');
				});
				$('.top-links a').each(function(){
					if ($(this).find('img').length > 0) {
						$(this).find('span').show();
					}
				});
			}
		}

	  responsive_980();
	  responsive_760();
	  responsive_470();

	  $(window).resize(function(){
	  	$("#cart").removeClass('active');
	  	responsive_980();
	  	responsive_760();
	  	responsive_470();
	  });

	  $('.price').each(function(){
        var $price_old = $(this).find('.price-old');
        var $price_new = $(this).find('.price-new');

        if ($price_old.length && $price_new.length) {
          var o = $price_old.parseNumber();
          var n = $price_new.parseNumber();
          var disc = Math.round((o - n) / o * 100);
          $(this).find('.sale').html('-' + disc + '%');
        }
      });

	 $('#search input[type="text"]').live('keydown', function(e) {
		if (e.keyCode == 13) {
			url = $('base').attr('href') + 'index.php?route=product/search';

			var filter_name = $('#search input[type="text"]').attr('name');
			var filter_value = $('#search input[type="text"]').attr('value');

			if (filter_name && filter_value) {
				url += '&' + filter_name +'=' + encodeURIComponent(filter_value);
			}

			location = url;
		}
	});

	});
})(jQuery);