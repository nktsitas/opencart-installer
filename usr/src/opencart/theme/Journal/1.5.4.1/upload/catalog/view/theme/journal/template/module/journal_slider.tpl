<div class="camera_wrap journal-slider" id="camera_slideshow_<?php echo $module;?>"
	style="max-width: <?php echo $width; ?>px; max-height: <?php echo $height; ?>px;">
	<?php foreach ($images as $img): ?>
    <div data-src="<?php echo $img['image']; ?>" <?php if($img['link']) echo 'data-link="' . $img['link'] . '"'?>>
    	<?php if ($img['title']): ?>
    	<div class="caption"><?php echo htmlspecialchars_decode($img['title']); ?></div>
    	<?php endif; ?>
    </div>
	<?php endforeach; ?>
</div>

<?php if($arrows_position):?>
<style type="text/css">
#camera_slideshow_<?php echo $module;?> .camera_prev {
	left: -70px;
}
#camera_slideshow_<?php echo $module;?> .camera_next {
	right: -70px;
}
<?php if ($this->document->journal_responsive_design === 'yes'): ?>
@media only screen and (max-width: 1030px){
	#camera_slideshow_<?php echo $module;?> .camera_prev {
	left: 0;
	}
	#camera_slideshow_<?php echo $module;?> .camera_next {
		right: 0;
	}
}
<?php endif; ?>

</style>
<?php endif; ?>

<?php if($show_on_hover): ?>
<style type="text/css">
#camera_slideshow_<?php echo $module;?> .camera_pag,
#camera_slideshow_<?php echo $module;?> .camera_prev,
#camera_slideshow_<?php echo $module;?> .camera_next {
	transition: all 0.2s;
	opacity: 0;
}

#camera_slideshow_<?php echo $module;?>:hover .camera_pag,
#camera_slideshow_<?php echo $module;?>:hover .camera_prev,
#camera_slideshow_<?php echo $module;?>:hover .camera_next
{
	opacity: 1;
}
</style>

<?php endif; ?>

<script type="text/javascript">
	/* ie8 hover fix */
	$('.ie8 #camera_slideshow_<?php echo $module;?>').hover(function(){
		$(this).find('.camera_pag,.camera_prev,.camera_next').css('filter', 'alpha(opacity=100)');
	}, function(){
		$(this).find('.camera_pag,.camera_prev,.camera_next').css('filter', 'alpha(opacity=0)');
	});

	/* camera slideshow script */
	(function($){

		$(function(){
			var x = "<?php echo $width;?>";
			var y = "<?php echo $height;?>";
			var num = y / x * 100;

			var options = $.parseJSON('<?php echo json_encode($options);?>');

			options.height = num + '%';
			options.slideOn = 'next';
			options.minHeight = '';

			<?php if (count($images) <= 1): ?>
			options.autoAdvance = false;
			options.navigation = false;
			options.hover = false;
			options.pagination = false;
			<?php endif; ?>

			$('#camera_slideshow_<?php echo $module;?>').camera(options);
		});

	})(jQuery);
</script>