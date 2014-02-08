<?php echo $header; ?>
<script>
$(document).ready(function(){
    $('header').addClass('home-header');
});
</script>

<?php if(isset($this->document->journal_welcome_text) && $this->document->journal_welcome_text === 'center'):?>
<style>
#content .welcome, #content .welcome + p {
  text-align: center;
}

</style>
<?php unset($this->document->journal_welcome_text); endif; ?>

<?php if(isset($this->document->journal_welcome_text) && $this->document->journal_welcome_text === 'right'):?>
<style>
#content .welcome, #content .welcome + p {
  text-align: right;
}
</style>
<?php unset($this->document->journal_welcome_text); endif; ?>

<?php if (isset($this->document->journal_extended_filter) && $this->document->journal_extended_filter === 'yes'): ?>

<style type="text/css">

#container{
  background-color: transparent;
}

#content{
  padding: 0;
}

.home-container .side-shade{
	top: 0;
} 
.home-container #column-right{
	position: relative;
	top: 0;
}

.home .journal-filter .product-grid > div{
  width: 230px;
  margin-right: 20px;
}

.home-container #content .box-product > div{
  width: 230px;
  margin-right: 17px;
}

.home-container #column-right + #content .product-grid > div, .home-container #column-right + #content .box-product > div{
  width: 240px;
}

.home-container #column-right + #content .journal-filter .product-grid > div{
  margin-right: 20px;
}

.home-container #content .welcome{
  margin-top: 15px;
}


<?php if ($this->document->journal_responsive_design === 'yes'): ?>
@media only screen and (max-width: 980px){

.home-container .journal-filter .product-grid > div, .home-container #content .box-product > div{
      width: 243px;
  }
.home-container #column-right + #content .product-grid > div, .home-container #column-right + #content .box-product > div{
    margin-right: 23px;
    width: 260px;
  }
}

@media only screen and (max-width: 760px){

  .home-container .journal-filter .product-grid > div, .home-container #content .box-product > div{
      width: 230px;
    }
  .home-container #column-right + #content .product-grid > div, .home-container #column-right + #content .box-product > div{
    margin-right: 18px;
    width: 230px;
  }
}

@media only screen and (max-width: 470px){
.home-container .journal-filter .product-grid > div, .home-container #content .box-product > div{
    width: 280px;
    margin-top: 20px;
    margin-left: 20px;
  }

  .home-container .journal-filter ul{
    width: 320px;
  }  
  .home-container .journal-filter ul li{
    width: 79px;
  }
  .home-container #column-right + #content .product-grid > div, .home-container #column-right + #content .box-product > div{
    width: 280px;
  }
}
<?php endif; ?>

</style> 
<?php endif;?>

<?php echo $column_right; ?>
<div id="content" class="home">
	<?php echo $content_top; ?>
	<?php echo $content_bottom; ?>
</div>

<?php echo $footer; ?>
