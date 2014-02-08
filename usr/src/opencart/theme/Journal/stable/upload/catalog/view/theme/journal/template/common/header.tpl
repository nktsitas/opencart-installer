<?php if(!isset($this->document->journal_install)) die('Journal not installed'); ?>
<!DOCTYPE html>
<html dir="<?php echo $direction; ?>" lang="<?php echo $lang; ?>" class="theme_<?php echo $this->document->journal_active_theme; ?>">
<head>
<?php if (isset($this->document->journal_responsive_design) && $this->document->journal_responsive_design === 'yes'): ?>
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
<meta name="format-detection" content="telephone=no">
<?php endif; ?>
<meta charset="UTF-8" />
<title><?php echo $title; ?></title>
<base href="<?php echo $base; ?>" />
<?php if ($description) { ?>
  <meta name="description" content="<?php echo $description; ?>"/>
<?php } ?>
<?php if ($keywords) { ?>
  <meta name="keywords" content="<?php echo $keywords; ?>"/>
<?php } ?>
<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1"/>
<?php if ($icon) { ?>
  <link href="<?php echo $icon; ?>" rel="icon"/>
<?php } ?>
<?php foreach ($links as $link) { ?>
  <link href="<?php echo $link['href']; ?>" rel="<?php echo $link['rel']; ?>" />
<?php } ?>
<?php foreach ($styles as $style) { ?>
  <link rel="<?php echo $style['rel']; ?>" type="text/css" href="<?php echo $style['href']; ?>" media="<?php echo $style['media']; ?>" />
<?php } ?>

<link rel="stylesheet" type="text/css" href="catalog/view/theme/journal/stylesheet/style.css">
<?php if (isset($this->document->journal_responsive_design) && $this->document->journal_responsive_design === 'yes'): ?>
<link rel="stylesheet" type="text/css" href="catalog/view/theme/journal/stylesheet/responsive.css">
<script type="text/javascript">
var responsive_design = true;
</script>
<?php else: ?>
  <script type="text/javascript">
var responsive_design = false;
</script>
<?php endif; ?>
<?php if (isset($this->document->journal_header_type) && $this->document->journal_header_type === 'yes'): ?>
<link rel="stylesheet" type="text/css" href="catalog/view/theme/journal/stylesheet/header_ii.css">
<?php endif; ?>
<link rel="stylesheet" type="text/css" href="catalog/view/theme/journal/stylesheet/blog_journal.css">

<?php if (isset($this->document->journal_custom_css_file)) echo $this->document->journal_custom_css_file . "\n"; ?>

<link rel="stylesheet" type="text/css" href="catalog/view/javascript/jquery/ui/themes/ui-lightness/jquery-ui-1.8.16.custom.css" />
<link rel="stylesheet" type="text/css" href="catalog/view/javascript/jquery/colorbox/colorbox.css" media="screen" />

<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.8/jquery.min.js"></script>

<script>
$('html').css('display', 'none');
$(document).ready(function() {
  $('html').show();
  window.scrollTo(0, 0);
});
</script>

<script type="text/javascript" src="catalog/view/javascript/jquery/ui/jquery-ui-1.8.16.custom.min.js"></script>
<script type="text/javascript" src="catalog/view/javascript/jquery/ui/external/jquery.cookie.js"></script>
<script type="text/javascript" src="catalog/view/javascript/jquery/colorbox/jquery.colorbox.js"></script>
<script type="text/javascript" src="catalog/view/javascript/jquery/tabs.js"></script>
<script type="text/javascript" src="catalog/view/javascript/common.js"></script>
<script type="text/javascript" src="catalog/view/javascript/journal/plugins.js"></script>

<!--[if lt IE 9]><script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE9.js"></script><![endif]-->

<?php foreach ($scripts as $script) { ?>
<script type="text/javascript" src="<?php echo $script; ?>"></script>
<?php } ?>

<script type="text/javascript" src="catalog/view/javascript/journal/journal.js"></script>

<?php echo $google_analytics; ?>

<?php if (isset($this->document->journal_css)): ?>
<style type="text/css">
/* Control Panel Generated Style */
<?php echo $this->document->journal_css; ?>
</style>
<?php endif; ?>

<?php if(isset($this->document->journal_product_hover) && $this->document->journal_product_hover === 'none'):?>
<style>
  .product-over{
    display:none;
  }
</style>
<?php unset($this->document->journal_product_hover); endif; ?>

<?php if(isset($this->document->journal_product_hover) && $this->document->journal_product_hover === 'hover1'):?>
<style>
  .product-over{
      transform: scaleY(1);
  }
</style>
<?php unset($this->document->journal_product_hover); endif; ?>

<?php if(isset($this->document->journal_product_hover) && $this->document->journal_product_hover === 'hover2'):?>
<style>
  .product-over{
      transform: scaleY(0);
  }
</style>
<?php unset($this->document->journal_product_hover); endif; ?>

</head>
<body>

<?php if (isset($this->document->journal_bgslider)): ?>
<div id="bgslider">
  <?php foreach ($this->document->journal_bgslider['images'] as $img): ?>
  <img src="<?php echo $img; ?>" alt="" />
  <?php endforeach; ?>
</div>
<?php if ($this->document->journal_bgslider['disabled']): ?>
<style type="text/css"> .mobile #bgslider{display: none !important;} </style>
<?php endif; ?>
<script type="text/javascript">
(function($){
  $(function(){
    var bgslider = $.parseJSON('<?php echo json_encode($this->document->journal_bgslider["options"]); ?>');
      bgslider.cssTransitions = false;
      bgslider.cycleOptions.easing = 'easeInOutQuart';
      bgslider.cycleOptions.prev = '#bgslider_left';
      bgslider.cycleOptions.next = '#bgslider_right';
    $('#bgslider').maximage(bgslider);
  });
})(jQuery);
</script>
<?php endif; ?>
<div class="loader"> </div>
<header <?php echo isset($this->document->journal_header_type) && $this->document->journal_header_type === 'yes' ? 'class="header_ii"' : ''; ?>>
  <div class="top-header"></div>
  <div id="journal-header">
        <?php if ($logo) { ?>
        <div id="logo"><a href="<?php echo $home; ?>">
          <img src="<?php echo $logo; ?>" title="<?php echo $name; ?>" alt="<?php echo $name; ?>" /></a>
        </div>
        <?php } ?>

        <div class="top-links">
          <?php if(isset($this->document->journal_top_menu)): ?>
          <?php foreach ($this->document->journal_top_menu as $menu_item): ?>
          <?php $target = $menu_item['new_window'] ? 'target="_blank"' : ''; ?>
          <?php $img = $menu_item['img'] ? '<img src="' . $menu_item['img'] .'" title="' . $menu_item['name'] .'" alt="' . $menu_item['name'] .'" />' : ''; ?>
          <?php if ($menu_item['href']): ?>
          <a class="link" href="<?php echo $menu_item['href']; ?>" <?php echo $target; ?>><?php echo $img . '<span>' . $menu_item['name'] . '</span>'; ?></a>
          <?php else: ?>
          <a class="no-link"><?php echo $img . '<span>' . $menu_item['name'] . '</span>'; ?></a>
          <?php endif; ?>
          <?php endforeach; ?>
          <?php endif; ?>

          <?php if (!isset($this->document->journal_top_menu) || count($this->document->journal_top_menu) === 0): ?>
          <a class="link" href="<?php echo $home; ?>"><?php echo $text_home; ?></a>
          <a class="link" href="<?php echo $wishlist; ?>" id="wishlist-total"><?php echo $text_wishlist; ?></a>
          <a class="link" href="<?php echo $account; ?>"><?php echo $text_account; ?></a>
          <a class="link" href="<?php echo $shopping_cart; ?>"><?php echo $text_shopping_cart; ?></a>
          <a class="link" href="<?php echo $checkout; ?>"><?php echo $text_checkout; ?></a>
          <?php endif; ?>
        </div>

        <section class="cart">
            <?php echo $cart; ?>
        </section>

        <section class="welcome">
            <?php if (strlen($language) > 0): ?>
            <?php echo $language; ?>
            <?php else: ?>
            <style type="text/css">
              @media only screen and (max-width: 470px) {
                #journal-header .welcome form {
                  text-align: center;
                  width: 100%;
                }
                #journal-header .welcome form div {
                  display: inline-block;
                }
              }
             </style>
            <?php endif; ?>
            <?php echo $currency; ?>
          <div id="welcome">
            <?php if (!$logged) { ?>
            <?php echo $text_welcome; ?>
            <?php } else { ?>
            <?php echo $text_logged; ?>
            <?php } ?>
          </div>
        </section>


        <div id="search">
           <div class="button-search"></div>
          <?php if (isset($filter_name)): ?>

            <?php if ($filter_name) { ?>
            <input type="text" name="filter_name" value="<?php echo $filter_name; ?>" />
            <?php } else { ?>
            <input type="text" name="filter_name" value="<?php echo $text_search; ?>" onclick="this.value = '';" onkeydown="this.style.color = '#000000';" />
            <?php } ?>

          <?php else: ?>

          <input type="text" name="search" placeholder="<?php echo $text_search; ?>" value="<?php echo $search; ?>" />

          <?php endif; ?>
        </div>

      <nav class="menu">
      <?php if ($categories) { ?>
      <div id="menu">
        <ul>
          <li class="open">
           <span class="menu-icon">
              <span></span>
              <span></span>
              <span></span>
            </span>
            <?php echo isset($this->document->journal_mobile_menu_title) ? $this->document->journal_mobile_menu_title : 'Categories'; ?>
          </li>
          <?php foreach ($categories as $category) { ?>
          <li>
            <a href="<?php echo $category['href']; ?>"><?php echo $category['name']; ?></a>
            <?php if ($category['children']) { ?>
            <div>
              <?php for ($i = 0; $i < count($category['children']);) { ?>
              <ul>
                <?php $j = $i + ceil(count($category['children']) / $category['column']); ?>
                <?php for (; $i < $j; $i++) { ?>
                <?php if (isset($category['children'][$i])) { ?>
                <li>
                  <a href="<?php echo $category['children'][$i]['href']; ?>">
                    <?php echo $category['children'][$i]['name']; ?>
                  </a>
                </li>
                <?php } ?>
                <?php } ?>
              </ul>
              <?php } ?>
            </div>
            <?php } ?>

          </li>
          <?php } ?>
          <?php if(isset($this->document->journal_categories_menu)): ?>
          <?php foreach ($this->document->journal_categories_menu as $menu_item): ?>
          <li>
          <?php $target = $menu_item['new_window'] ? 'target="_blank"' : ''; ?>
          <?php if ($menu_item['href']): ?>
          <a href="<?php echo $menu_item['href']; ?>" <?php echo $target; ?>><?php echo $menu_item['name']; ?></a>
          <?php else: ?>
          <a><?php echo $menu_item['name']; ?></a>
          <?php endif; ?>

          <?php if (count($menu_item['subcategs'])): ?>
          <div>
            <ul>
            <?php foreach ($menu_item['subcategs'] as $submenu_item): ?>
              <li>
              <?php $target = $submenu_item['new_window'] ? 'target="_blank"' : ''; ?>
              <?php if ($submenu_item['href']): ?>
              <a href="<?php echo $submenu_item['href']; ?>" <?php echo $target; ?>> <?php echo $submenu_item['name']; ?></a>
              <?php else: ?>
              <a> <?php echo $submenu_item['name']; ?></a>
              <?php endif; ?>
            </li>
            <?php endforeach; ?>
            </ul>
          </div>
          <?php endif; ?>

          </li>
          <?php endforeach; ?>
          <?php endif; ?>
        </ul>
      </div>
      <?php } ?>
</nav>
</div>
</header>
<div id="container">
<div id="notification"></div>
