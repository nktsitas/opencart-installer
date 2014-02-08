

<div class="box">
<style>

.journal-boxes{
	margin-right: -20px;
}

#column-right + #content .journal-boxes{
	margin-right: 0;
}

.journal-boxes ul li a{
	background-position: center;
	background-repeat: no-repeat;
	background-size: cover;
}

.journal-boxes ul{
	display: table;
	position: relative;
	width: 100%;
}

.journal-boxes ul li{
	display: table-cell;
	position: relative;
	padding: 0px 20px 20px 0;
}

.journal-boxes ul li a{
	display: block;
	height: 100%;
}

#journal-boxes-<?php echo $module; ?> ul {
	height: <?php echo (int)$height; ?>px;
}

@media only screen and (max-width: 980px) {
	#journal-boxes-<?php echo $module; ?> ul {
		height: <?php echo (int)$height*0.78; ?>px;
	}
}
@media only screen and (max-width: 760px) {
	#journal-boxes-<?php echo $module; ?> ul {
		height: <?php echo (int)$height*0.5; ?>px;
	}
}
@media only screen and (max-width: 470px) {
	#journal-boxes-<?php echo $module; ?> ul {
		height: <?php echo (int)$height*0.32; ?>px;
	}
}
.box ul li a, .box ul li {
	height: 100%;
}
</style>
<div id="journal-boxes-<?php echo $module; ?>" class="journal-boxes">
	<ul>
		<?php foreach ($images as $image): ?>
		<?php if($image['link']): ?>
		<?php $target = $image['new_window'] ? 'target="_blank"' : ''; ?>
		<li><a href="<?php echo $image['link']; ?>" style="background-image: url(<?php echo $image['image']; ?>); ?>;" <?php echo $target;?>></a></li>
		<?php else: ?>
		<li><a href="javascript:;" style="background-image: url(<?php echo $image['image']; ?>); ?>; cursor: default;"></a></li>
		<?php endif;?>
		<?php endforeach; ?>
	</ul>
</div>
</div>