<?php
  // echo "<pre>" . print_r($journal_settings['menus']['subcategories']['categories_menu'], TRUE) . "</pre>"; die();
  function generate_text($setting) {
    /* $value = $setting['value'] ? $setting['value'] : $setting['default_value']; */ $value = $setting['value'];
    echo '<input type="text" name="journal_settings[' . $setting['name'] . ']" value="' . $value . '" data-default="' . htmlspecialchars($setting['default_value']) . '" />';
  }

  function generate_select($setting) {
    /* $value = $setting['value'] ? $setting['value'] : $setting['default_value']; */ $value = $setting['value'];
    $cls = count($setting['options']) === 2 ? 'class="yes_no"' : '';
    echo '<select ' . $cls . ' name="journal_settings[' . $setting['name'] . ']" data-default="' . htmlspecialchars($setting['default_value']) . '">' ."\n";
    foreach($setting['options'] as $option_key => $option_value) {
      if ($setting['value'] == $option_key) {
        echo '<option value="' . $option_key . '" selected="selected">' . $option_value . '</option>' ."\n";
      } else {
        echo '<option value="' . $option_key . '">' . $option_value . '</option>' ."\n";
      }
    }
    echo '</select>' ."\n";
  }

  function generate_color($setting) {
    /* $value = $setting['value'] ? $setting['value'] : $setting['default_value']; */ $value = $setting['value'];
    echo '<input type="text" name="journal_settings[' . $setting['name'] . ']" value="' . $value . '" class="color {required:false}" data-default="' . htmlspecialchars($setting['default_value']) . '" />';
  }

  function generate_textarea($setting) {
    /* $value = $setting['value'] ? $setting['value'] : $setting['default_value']; */ $value = $setting['value'];
    echo '<textarea name="journal_settings[' . $setting['name'] . ']" data-default="' . htmlspecialchars($setting['default_value']) . '">' . $value . '</textarea>';
  }

  function generate_upload($setting) {
    /* $value = $setting['value'] ? $setting['value'] : $setting['default_value']; */ $value = $setting['value'];
    echo '<input type="hidden" id="image_' . $setting['name'] . '" name="journal_settings[' . $setting['name'] . ']" value="' . $value . '" data-default="' . htmlspecialchars($setting['default_value']) . '" />';
    echo '<img src="' . $setting['thumb'] . '" id="thumb_' . $setting['name'] . '" alt="' . $setting['label'] . '" class="upload-thumb" data-default="' . htmlspecialchars($setting['default_thumb']) . '" />';
    echo '<a href="#" class="choose-img">Browse</a><a href="#" class="clear-img">Clear</a>';
  }

  function generate_font($setting) {
    $fonts = $setting['font_families'];
    $sizes = range(8, 48);
    $weights = array('bold', 'normal');
    $transforms = array('none', 'uppercase', 'lowercase');

    $first_font = reset($fonts);

    if (!isset($setting['default_value']['font-family'])) $setting['default_value']['font-family'] = $first_font[0]['font_name'];
    if (!isset($setting['default_value']['font-size'])) $setting['default_value']['font-size'] = $sizes[0];
    if (!isset($setting['default_value']['font-weight'])) $setting['default_value']['font-weight'] = $weights[0];
    if (!isset($setting['default_value']['text-transform'])) $setting['default_value']['text-transform'] = $transforms[0];

    echo '<select name="journal_settings[' . $setting['name'] . '][font-family]" data-default="' . $setting['default_value']['font-family'] . '">';

    foreach ($fonts as $label => $font_group) {
      echo '<optgroup label="' . ucfirst($label) . '">';
      foreach ($font_group as $font) {

        if ($setting['value']['font-family'] == $font['font_name']) {
          echo '<option value="' . $font['font_name'] . '" selected="selected">' . $font['font_name'] . '</option>';
        } else {
          echo '<option value="' . $font['font_name'] . '">' . $font['font_name'] . '</option>';
        }
      }
      echo '</optgroup>';

    }
    echo '</select>';

    echo '<select name="journal_settings[' . $setting['name'] . '][font-size]" data-default="' . $setting['default_value']['font-size'] . '">';
    foreach ($sizes as $size) {
      if ($setting['value']['font-size'] == $size) {
        echo '<option value="' . $size . '" selected="selected">' . $size . 'px</option>';
      } else {
        echo '<option value="' . $size . '">' . $size . 'px</option>';
      }
    }
    echo '</select>';

    echo '<select name="journal_settings[' . $setting['name'] . '][font-weight]" data-default="' . $setting['default_value']['font-weight'] . '">';
    foreach ($weights as $weight) {
      if ($setting['value']['font-weight'] == $weight) {
        echo '<option value="' . $weight . '" selected="selected">' . ucfirst($weight) . '</option>';
      } else {
        echo '<option value="' . $weight . '">' . ucfirst($weight) . '</option>';
      }
    }
    echo '</select>';

    echo '<select name="journal_settings[' . $setting['name'] . '][text-transform]" data-default="' . $setting['default_value']['text-transform'] . '">';
    foreach ($transforms as $transform) {
      if ($setting['value']['text-transform'] == $transform) {
        echo '<option value="' . $transform . '" selected="selected">' . ucfirst($transform) . '</option>';
      } else {
        echo '<option value="' . $transform . '">' . ucfirst($transform) . '</option>';
      }
    }
    echo '</select>';

  }

  function generate_multiupload($setting) {
    $value = $setting['value'];
    echo '<table class="form multiupload" data-count="' . count($value) . '" data-setting-name="' . $setting['name'] . '" data-default="' . htmlspecialchars(json_encode($setting['default_value'])) . '">';
    echo '<thead><tr>';
    echo '<td>Image</td>';
    echo '<td>Name</td>';
    echo '<td>Link</td>';
    echo '<td>Sort Order</td>';
    echo '<td>Delete</td>';
    echo '</tr></thead>';
    $id = 0;
    foreach ($value as $val) {
      $field_id = "image_" . $setting['name'] . "_" . $id;
      $thumb_id = "thumb_" . $setting['name'] . "_" . $id;
      echo '<tbody><tr>';
      echo '<td><input type="hidden" name="journal_settings[' . $setting['name'] . '][' . $id . '][img]" value="' . $val['img'] . '" id="' . $field_id . '" /><img src="' . $val['thumb'] . '" id="' . $thumb_id . '" class="upload-thumb choose-img" /></td>';
      echo '<td><input class="name" type="text" name="journal_settings[' . $setting['name'] . '][' . $id . '][name]" value="' . $val['name'] . '" /></td>';
      echo '<td><input type="text" name="journal_settings[' . $setting['name'] . '][' . $id . '][link]" value="' . $val['link'] . '" /></td>';
      echo '<td><input type="text" name="journal_settings[' . $setting['name'] . '][' . $id . '][sort_order]" value="' . $val['sort_order'] . '" /></td>';
      echo '<td><a href="#" class="remove-image button">Remove</a></td>';
      echo '</tr></tbody>';
      $id++;
    }
    echo '<tfoot>';
    echo '</tfoot>';
    echo '</table>';
    echo '<a href="#" class="add-image button">Add item</a>';
  }

  function generate_editor($setting) {
    /* $value = $setting['value'] ? $setting['value'] : $setting['default_value']; */ $value = $setting['value'];
    echo '<textarea id="editor_' . $setting['name'] . '" name="journal_settings[' . $setting['name'] . ']" data-default="' . htmlspecialchars($setting['default_value']) . '">' . $value . '</textarea>';
  }

  function generate_menu($setting, $languages) {
    $value = $setting['value'];
    echo '<table class="form menu" data-count="' . count($value) . '" data-setting-name="' . $setting['name'] . '" data-default="' . htmlspecialchars(json_encode($setting['default_value'])) . '">';
    echo '<thead><tr>';
    echo '<td>Icon</td>';
    echo '<td>Name</td>';
    echo '<td>Link</td>';
    echo '<td>Sort</td>';
    echo '<td>New Tab</td>';
    echo '<td>Delete</td>';
    echo '</tr></thead>';
    $id = 0;
    foreach ($value as $val) {
      $field_id = "image_" . $setting['name'] . "_" . $id;
      $thumb_id = "thumb_" . $setting['name'] . "_" . $id;

      $val['name'] = get_object_vars($val['name']);

      echo '<tbody><tr>';
      echo '<td><input type="hidden" name="journal_settings[' . $setting['name'] . '][' . $id . '][img]" value="' . $val['img'] . '" id="' . $field_id . '" /><img src="' . $val['thumb'] . '" id="' . $thumb_id . '" class="upload-thumb choose-img" /></td>';
      echo '<td>';
      foreach ($languages as $language):
        $value = isset($val['name'][$language['language_id']]) ? $val['name'][$language['language_id']] : '';
        echo '<div class="menu-name"><input type="text" name="journal_settings[' . $setting['name'] . '][' . $id . '][name][' . $language['language_id'] . ']" value="' . $value . '"/>';
        echo '<img src="view/image/flags/' . $language['image'] . '" title="' . $language['name'] . '" /></div>';
      endforeach;
      echo '</td>';
      echo '<td><input type="text" name="journal_settings[' . $setting['name'] . '][' . $id . '][link]" value="' . $val['link'] . '"/></td>';
      echo '<td><input class="small" type="text" name="journal_settings[' . $setting['name'] . '][' . $id . '][sort_order]" value="' . $val['sort_order'] . '"/></td>';
      echo '<td><select class="yes_no" name="journal_settings[' . $setting['name'] . '][' . $id . '][new_window]" value="' . $val['new_window'] . '">';
      $selected1 = $val['new_window'] ? 'selected="selected"' : '';
      $selected0 = !$val['new_window'] ? 'selected="selected"' : '';
      echo '<option value="1"' . $selected1 . '>Yes</option>';
      echo '<option value="0"' . $selected0 . '>No</option>';
      echo '</select></td>';
      echo '<td><a href="#" class="remove-image button">Remove</a></td>';
      echo '</tr></tbody>';
      $id++;
    }
    echo '<tfoot>';
    echo '</tfoot>';
    echo '</table>';
    echo '<a href="#" class="add-top-menu-item button">Add menu item</a>';
  }

  function generate_categ_menu($setting, $languages) {
    $value = $setting['value'];
    echo '<table class="form menu" data-count="' . count($value) . '" data-setting-name="' . $setting['name'] . '" data-default="' . htmlspecialchars(json_encode($setting['default_value'])) . '">';
    echo '<thead><tr>';
    echo '<td>Sub</td>';
    echo '<td>Name</td>';
    echo '<td>Link</td>';
    echo '<td>Sort</td>';
    echo '<td>New Tab</td>';
    echo '<td>Delete</td>';
    echo '</tr></thead>';
    $id = 0;
    foreach ($value as $val) {
      $val = get_object_vars($val);
      if (isset($val['subcategs']) && is_object($val['subcategs'])) $val['subcategs'] = get_object_vars($val['subcategs']);

      $val['name'] = get_object_vars($val['name']);

      $count = isset($val['subcategs']) && is_array($val['subcategs']) ? count($val['subcategs']) : 0;

      echo '<tbody class="main-categ-' . $id . '" data-class="' . $id . '" data-count="' . $count . '" data-setting-name="' . $setting['name'] . '"><tr>';
      echo '<td><a href="#" class="add-categ-sub-menu button">+</a></td>';
      echo '<td>';
      foreach ($languages as $language):
        $value = isset($val['name'][$language['language_id']]) ? $val['name'][$language['language_id']] : '';
        echo '<div class="menu-name"><input type="text" name="journal_settings[' . $setting['name'] . '][' . $id . '][name][' . $language['language_id'] . ']" value="' . $value . '"/>';
        echo '<img src="view/image/flags/' . $language['image'] . '" title="' . $language['name'] . '" /></div>';
      endforeach;
      echo '</td>';
      echo '<td><input type="text" name="journal_settings[' . $setting['name'] . '][' . $id . '][link]" value="' . $val['link'] . '"/></td>';
      echo '<td><input class="small" type="text" name="journal_settings[' . $setting['name'] . '][' . $id . '][sort_order]" value="' . $val['sort_order'] . '"/></td>';
      echo '<td><select class="yes_no" name="journal_settings[' . $setting['name'] . '][' . $id . '][new_window]" value="' . $val['new_window'] . '">';
      $selected1 = $val['new_window'] ? 'selected="selected"' : '';
      $selected0 = !$val['new_window'] ? 'selected="selected"' : '';
      echo '<option value="1"' . $selected1 . '>Yes</option>';
      echo '<option value="0"' . $selected0 . '>No</option>';
      echo '</select></td>';
      echo '<td><a href="#" class="remove-image button">Remove</a></td>';
      echo '</tr></tbody>';

      /*generate subcategs*/
      if (isset($val['subcategs'])) {
        $sub_id = 0;
        foreach ($val['subcategs'] as $subval) {
          $subval = get_object_vars($subval);

          $last_child = $sub_id === count($val['subcategs']) - 1 ? 'subcateg-last' : '';

          $subval['name'] = get_object_vars($subval['name']);

          echo '<tbody class="subcateg subcateg_' . $id . ' ' . $last_child . '" data-parent-categ="' . $id . '"><tr>';
          echo '<td><span class="button" style="display: none;"></span></td>';
          echo '<td>';
          foreach ($languages as $language):
            $value = isset($subval['name'][$language['language_id']]) ? $subval['name'][$language['language_id']] : '';
            echo '<div class="menu-name"><input type="text" name="journal_settings[' . $setting['name'] . '][' . $id . '][subcategs][' . $sub_id . '][name][' . $language['language_id'] . ']" value="' . $value . '"/>';
            echo '<img src="view/image/flags/' . $language['image'] . '" title="' . $language['name'] . '" /></div>';
          endforeach;
          echo '</td>';
          echo '<td><input type="text" name="journal_settings[' . $setting['name'] . '][' . $id . '][subcategs][' . $sub_id . '][link]" value="' . $subval['link'] . '"/></td>';
          echo '<td><input class="small" type="text" name="journal_settings[' . $setting['name'] . '][' . $id . '][subcategs][' . $sub_id . '][sort_order]" value="' . $subval['sort_order'] . '"/></td>';
          echo '<td><select class="yes_no" name="journal_settings[' . $setting['name'] . '][' . $id . '][subcategs][' . $sub_id . '][new_window]" value="' . $subval['new_window'] . '">';
          $selected1 = $subval['new_window'] ? 'selected="selected"' : '';
          $selected0 = !$subval['new_window'] ? 'selected="selected"' : '';
          echo '<option value="1"' . $selected1 . '>Yes</option>';
          echo '<option value="0"' . $selected0 . '>No</option>';
          echo '</select></td>';
          echo '<td><a href="#" class="remove-image button">Remove</a></td>';
          echo '</tr></tbody>';
          $sub_id++;
        }
      }
      /*end of generate subcategs*/
      $id++;
    }
    echo '<tfoot>';
    echo '</tfoot>';
    echo '</table>';
    echo '<a href="#" class="add-categ-menu-item button">Add menu item</a>';
  }

  function generate_html($settings, $categ, $subcateg = NULL) {
    if (in_array($categ, array('fonts'))) return;
    $db_settings = NULL;
    if ($subcateg == NULL && isset($settings[$categ])) {
      $db_settings = $settings[$categ];
    }
    if ($subcateg != NULL && isset($settings[$categ]) && isset($settings[$categ]['subcategories'][$subcateg])) {
      $db_settings = $settings[$categ]['subcategories'][$subcateg];
    }
    if ($db_settings == NULL) {
      echo '<div>No options avaliable!</div>';
      return;
    }
    echo '<table class="form">' . "\n";
    $index = 0;
    foreach ($db_settings as $setting) { $index++;
      $cls = array('categ_' . $setting['category'], 'setting_' . $setting['name'], 'input_' . $setting['input']);
      if ($subcateg) {
        $cls[] = 'subcateg_' . $setting['subcategory'];
      }
      echo '<tr class="' . implode(' ', $cls) . '"><td align="right" class="label">' . $setting['label'] . ': </td><td class="value"><div>';
      switch ($setting['input']) {
        case 'select'     : generate_select($setting);      break;
        case 'color'      : generate_color($setting);       break;
        case 'textarea'   : generate_textarea($setting);    break;
        case 'upload'     : generate_upload($setting);      break;
        case 'font'       : generate_font($setting);        break;
        case 'multiupload': generate_multiupload($setting); break;
        case 'editor'     : generate_editor($setting);      break;
        case 'menu'       : generate_menu($setting, $settings['all_languages']);        break;
        case 'categ_menu' : generate_categ_menu($setting, $settings['all_languages']);        break;
        default           : generate_text($setting);        break;
      }
      if ($setting['tip']) {
        echo '<a class="journal-tip" target="_blank" href="http://journal.digital-atelier.com/tips/' . $setting['tip'] . '"></a>';
      } else {
        $tip = $setting['category'];
        if ($setting['category'] === 'colors') {
          $tip = 'colors_' . $setting['subcategory'] . '_' . $index;
        } else {
          $tip = $setting['category'] . '_' . $setting['subcategory'] . '_' . $index;
        }
        echo '<a class="journal-tip" target="_blank" href="http://journal.digital-atelier.com/tips/' . $tip . '.jpg"></a>';
      }
      echo '</div></td></tr>';
    }
    echo '</table>' . "\n";
  }
?>
<?php echo $header; ?>
<div class="loader"> Loading...</div>
<!-- Modal -->
<div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="myModalLabel">Save Skin As:</h3>
  </div>
  <div class="modal-body">
    Skin name: <input class="name" type="text" name="" value="" />
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
    <button class="btn btn-primary do-save-btn">Save Changes</button>
  </div>
</div>
<!-- End Modal -->
<div id="content" class="cp">
      <div class="heading">
        <h1><?php echo $doc_title; ?> <small>v.<?php echo $journal_version; ?></small></h1>
      <div class="links">
          <a href="http://journal.digital-atelier.com/" class="demo-link" target="_blank">Journal Demo</a> &nbsp; | &nbsp;
          <a href="http://journal.digital-atelier.com/docs" class="docs-link" target="_blank">Documentation</a>
      </div>
          <div class="buttons">
            <?php if ($update_avaliable): ?>
            <a onclick="$(this).html('<?php echo $text_update_in_progress; ?>');location = '<?php echo $update; ?>';" class="btn btn-info"><?php echo $button_update; ?></a>
            <?php endif; ?>
            <a onclick="check_form()" class="btn btn-success"><?php echo $button_save; ?></a>
            <a onclick="location = '<?php echo $cancel; ?>';" class="btn btn-danger"><?php echo $button_cancel; ?></a>
          </div>
      </div>
    <?php if ($error_warning) { ?>
    <div class="warning"><?php echo $error_warning; ?></div>
    <?php } ?>
    <?php if ($success) { ?>
    <div class="success"><?php echo $success; ?></div>
    <?php } ?>
    <script>
    $(document).ready(function(){
      setTimeout(function() {
        $('.success').delay(3000).fadeOut('slow');
      }, 1000);
    });
    </script>
  	<div class="box">

	    <div class="content">
        <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
        <!-- subheader -->
  			<div id="subheader">
          <table class="form">
            <tr>
              <td class="stats" style="width:130px" align="right">
                Control panel status:
              </td>
              <td align="left" class="td2" style="width:120px">
                <select class="yes_no" name="journal_theme_status">
                <?php if ($theme_status): ?>
                <option value="1" selected="selected">On</option>
                <option value="0">Off</option>
                <?php else: ?>
                <option value="1">On</option>
                <option value="0" selected="selected">Off</option>
                <?php endif; ?>
                </select>
              </td>

              <td class="stats" style="width:92px; text-align:right">
                Active Skin:
              </td>
              <td style="width:92px">
                <select id="journal-theme-selector" name="journal_theme" data-href="<?php echo $action; ?>">
                <?php foreach ($themes as $categ_name => $themes): ?>
                <optgroup label="<?php echo $themes['category']; ?>">
                  <?php foreach ($themes['themes'] as $theme): ?>
                  <option value="<?php echo $theme['theme_id']; ?>" <?php if($theme['theme_id'] === $current_theme) echo 'selected="selected"'; ?>><?php echo $theme['theme_name']; ?></option>
                  <?php endforeach; ?>
                </optgroup>
                <?php endforeach; ?>
                </select>
              </td>

              <?php /*
                <option value="<?php echo $theme['theme_id']; ?>" <?php if($theme['theme_id'] === $current_theme) echo 'selected="selected"'; ?>><?php echo $theme['theme_name']; ?></option>

              */?>

              <td>
                <?php if (!$core_theme): ?>
                <a href="#" class="btn delete-theme" data-href="<?php echo $delete; ?>">Delete Skin</a>
                <?php endif; ?>
                <!-- <a href="#" class=" save-theme">Save theme as</a> -->
                <!-- Button to trigger modal -->
                <a href="#myModal" role="button" class="btn" data-toggle="modal">Save Custom Skin</a>


              </td>
            </tr>
          </table>
        </div>

        <a href="#" class="btn btn-primary reset-theme">Reset Section to Defaults</a>

        <!-- horizontal tabs -->
        <div class="htabs main-tabs ui-tabs">
          <?php foreach ($tabs as $category => $subcategories): ?>
          <a href="#main-tabs-<?php echo $category; ?>"><?php echo $tabs_labels['htab_' . $category]; ?></a>
          <?php endforeach;?>
        </div>
        <!-- horizontal tabs content -->
        <?php foreach ($tabs as $category => $subcategories): ?>
          <div id="main-tabs-<?php echo $category; ?>" class="ui-tabs-hide">
            <!-- vertical tabs -->
            <?php if ($subcategories): ?>
            <div class="vtabs sec-tabs ui-tabs">
            <?php foreach ($subcategories as $subcategory): ?>
              <a href="#sec-tab-<?php echo $category; ?>-<?php echo $subcategory; ?>"><?php echo $tabs_labels['vtab_' . $subcategory]; ?></a>
            <?php endforeach; ?>
            </div>
            <?php endif; ?>
            <!-- vertical tabs content -->
            <?php if ($subcategories): ?>
            <?php foreach ($subcategories as $subcategory): ?>
            <div id="sec-tab-<?php echo $category; ?>-<?php echo $subcategory; ?>" class="vtabs-content ui-tabs-hide">
              <?php echo generate_html($journal_settings, $category, $subcategory); ?>
            </div>
            <?php endforeach; ?>
            <?php else: ?>
            <?php echo generate_html($journal_settings, $category); ?>
            <?php endif; ?>
          </div>
        <?php endforeach; ?>
        </form>
		</div>
	</div>
</div>
<script type="text/javascript" src="view/javascript/journal/jscolor.js"></script>
<script type="text/javascript" src="view/javascript/ckeditor/ckeditor.js"></script>
<script type="text/javascript">

function check_form() {

  var error = false;

  // $('#sec-tab-menus-top_menu .menu-name input[type=text]').each(function(){
  //   var $this = $(this);
  //   if ($this.val().trim().length === 0) {
  //     $('a[href=#main-tabs-menus]').click();
  //     $('a[href=#sec-tab-menus-top_menu]').click();
  //     $this.focus();
  //     alert('<?php echo $error_menu_name; ?>');
  //     error = true;
  //     return false;
  //   }
  // });

  if (error) {
    return false;
  }

  $('#sec-tab-menus-categories_menu .menu-name input[type=text]').each(function(){
    var $this = $(this);
    if ($this.val().trim().length === 0) {
      $('a[href=#main-tabs-menus]').click();
      $('a[href=#sec-tab-menus-categories_menu]').click();
      $this.focus();
      alert('<?php echo $error_menu_name; ?>');
      error = true;
      return false;
    }
  });

  if (error) {
    return false;
  }

  $('#sec-tab-footer-contacts .setting_contact_methods table.multiupload input.name').each(function(){
    var $this = $(this);
    if ($this.val().trim().length === 0) {
      $('a[href=#main-tabs-footer]').click();
      $('a[href=#sec-tab-footer-contacts]').click();
      $this.focus();
      alert('<?php echo $error_contact_method_name; ?>');
      error = true;
      return false;
    }
  });

  if (error) {
    return false;
  }

  $('#form').submit();
}

(function(){
  $('.main-tabs a').tabs();
  $('.sec-tabs a').tabs();
  $('.main-tabs a').click(function(){
      var tab = $(this).attr("href");
      $(tab + ' .sec-tabs a').first().click();
  });
  $('.ui-tabs-hide').removeClass('ui-tabs-hide');
  // $('a[href=#main-tabs-menus]').click();
  // $('a[href=#sec-tab-menus-categories_menu]').click();
})();

(function($){

  function image_upload(field, thumb) {
    $('#dialog').remove();

    $('#content').prepend('<div id="dialog" style="padding: 3px 0px 0px 0px;"><iframe src="index.php?route=common/filemanager&token=<?php echo $token; ?>&field=' + encodeURIComponent(field) + '" style="padding:0; margin: 0; display: block; width: 100%; height: 100%;" frameborder="no" scrolling="auto"></iframe></div>');

    $('#dialog').dialog({
      title: '<?php echo $text_image_manager; ?>',
      close: function (event, ui) {
        if ($('#' + field).attr('value')) {
          $.ajax({
            url: 'index.php?route=common/filemanager/image&token=<?php echo $token; ?>&image=' + encodeURIComponent($('#' + field).attr('value')),
            dataType: 'text',
            success: function(data) {
              $('#' + thumb).attr('src', data);
            }
          });
        }
      },
      bgiframe: false,
      width: 700,
      height: 400,
      resizable: false,
      modal: false
    });
  };

  function add_image($table, defaults) {
    if (!defaults) defaults = {};
    if (!defaults.img) defaults.img = '';
    if (!defaults.thumb) defaults.thumb = '<?php echo $no_image; ?>';
    if (!defaults.name) defaults.name = '';
    if (!defaults.link) defaults.link = '';
    if (!defaults.sort_order) defaults.sort_order = '';
    var id = parseInt($table.attr("data-count")) + 1;
    $table.attr("data-count", id);
    var name = $table.attr('data-setting-name');

    var field_id = "image_" + name + "_" + id;
    var thumb_id = "thumb_" + name + "_" + id;

    var html = '<tbody><tr>';
    html += '<td><input type="hidden" name="journal_settings[' + name + '][' + id + '][img]" id="' + field_id + '" value="' + defaults.img + '" /><img src="' + defaults.thumb + '" id="' + thumb_id + '" class="upload-thumb choose-img" /></td>';
    html += '<td><input type="text" class="name" name="journal_settings[' + name + '][' + id + '][name]" value="' + defaults.name + '"/></td>';
    html += '<td><input type="text" name="journal_settings[' + name + '][' + id + '][link]" value="' + defaults.link + '"/></td>';
    html += '<td><input type="text" name="journal_settings[' + name + '][' + id + '][sort_order]" value="' + defaults.sort_order + '"/></td>';
    html += '<td><a href="#" class="remove-image button">Remove</a></td>';
    html += '</tr></tbody>';

    $table.parent().find('table tfoot').before(html);
    is_empty();
  }

  function is_empty() {
    if ($('.input_multiupload table tbody').length == 0) {
      $('.input_multiupload .add-image').before('<div class="no-images"><?php echo $no_images; ?></div>');
    } else {
      $('.no-images').remove();
    }
  }

  function add_top_menu_item($table, defaults) {
    if (!defaults) defaults = {};
    if (!defaults.img) defaults.img = '';
    if (!defaults.thumb) defaults.thumb = '<?php echo $no_image; ?>';
    if (!defaults.name) defaults.name = '';
    if (!defaults.link) defaults.link = '';
    if (!defaults.sort_order) defaults.sort_order = '';
    var id = parseInt($table.attr("data-count")) + 1;
    $table.attr("data-count", id);
    var name = $table.attr('data-setting-name');

    var field_id = "image_" + name + "_" + id;
    var thumb_id = "thumb_" + name + "_" + id;

    var html = '<tbody><tr>';
    html += '<td><input type="hidden" name="journal_settings[' + name + '][' + id + '][img]" id="' + field_id + '" value="' + defaults.img + '" /><img src="' + defaults.thumb + '" id="' + thumb_id + '" class="upload-thumb choose-img" /></td>';
    html += '<td>';
    <?php foreach ($journal_settings['all_languages'] as $language): ?>
    html += '<div class="menu-name"><input type="text" name="journal_settings[' + name + '][' + id + '][name][<?php echo $language['language_id']; ?>]" value="' + defaults.name + '"/>';
    html += '<img src="view/image/flags/<?php echo $language['image']; ?>" title="<?php echo $language['name']; ?>" /></div>';
    <?php endforeach; ?>
    html += '</td>';
    html += '<td><input type="text" name="journal_settings[' + name + '][' + id + '][link]" value="' + defaults.link + '"/></td>';
    html += '<td><input class="small" type="text" name="journal_settings[' + name + '][' + id + '][sort_order]" value="' + defaults.sort_order + '"/></td>';
    html += '<td><select class="yes_no" name="journal_settings[' + name + '][' + id + '][new_window]" value="' + defaults.sort_order + '">';
    html += '<option value="1"><?php echo $text_yes; ?></option>';
    html += '<option value="0" selected="selected"><?php echo $text_no; ?></option>';
    html += '</select></td>';
    html += '<td><a href="#" class="remove-image button">Remove</a></td>';
    html += '</tr></tbody>';

    $table.parent().find('table tfoot').before(html);
    $table.find('.yes_no').switchify();
  }

  function add_categ_menu_item($table, defaults) {
    if (!defaults) defaults = {};
    if (!defaults.img) defaults.img = '';
    if (!defaults.thumb) defaults.thumb = '<?php echo $no_image; ?>';
    if (!defaults.name) defaults.name = '';
    if (!defaults.link) defaults.link = '';
    if (!defaults.sort_order) defaults.sort_order = '';
    var id = parseInt($table.attr("data-count")) + 1;
    $table.attr("data-count", id);
    var name = $table.attr('data-setting-name');

    var field_id = "image_" + name + "_" + id;
    var thumb_id = "thumb_" + name + "_" + id;

    var html = '<tbody class="main-categ-' + id + '" data-class="' + id + '" data-count="0" data-setting-name="' + name + '"><tr>';
    html += '<td><a href="#" class="add-categ-sub-menu button">+</a></td>';
    html += '<td>';
    <?php foreach ($journal_settings['all_languages'] as $language): ?>
    html += '<div class="menu-name"><input type="text" name="journal_settings[' + name + '][' + id + '][name][<?php echo $language['language_id']; ?>]" value="' + defaults.name + '"/>';
    html += '<img src="view/image/flags/<?php echo $language['image']; ?>" title="<?php echo $language['name']; ?>" /></div>';
    <?php endforeach; ?>
    html += '</td>';
    html += '<td><input type="text" name="journal_settings[' + name + '][' + id + '][link]" value="' + defaults.link + '"/></td>';
    html += '<td><input class="small" type="text" name="journal_settings[' + name + '][' + id + '][sort_order]" value="' + defaults.sort_order + '"/></td>';
    html += '<td><select class="yes_no" name="journal_settings[' + name + '][' + id + '][new_window]" value="' + defaults.sort_order + '">';
    html += '<option value="1"><?php echo $text_yes; ?></option>';
    html += '<option value="0" selected="selected"><?php echo $text_no; ?></option>';
    html += '</select></td>';
    html += '<td><a href="#" class="remove-image button">Remove</a></td>';
    html += '</tr></tbody>';

    $table.parent().find('table tfoot').before(html);
    $table.find('.yes_no').switchify();
  }

  function add_categ_sub_menu($table, defaults) {
    if (!defaults) defaults = {};
    if (!defaults.img) defaults.img = '';
    if (!defaults.thumb) defaults.thumb = '<?php echo $no_image; ?>';
    if (!defaults.name) defaults.name = '';
    if (!defaults.link) defaults.link = '';
    if (!defaults.sort_order) defaults.sort_order = '';
    var id = parseInt($table.attr("data-count")) + 1;
    $table.attr("data-count", id);
    var name = $table.attr('data-setting-name');

    var categ_id = parseInt($table.attr("data-class"));

    var field_id = "image_" + name + "_" + id;
    var thumb_id = "thumb_" + name + "_" + id;

    var html = '<tbody class="subcateg subcateg-last subcateg_' + categ_id + '" data-parent-categ="' + categ_id + '"><tr>';
    html += '<td><span class="button" style="display: none;"></span></td>';
    html += '<td>';
    <?php foreach ($journal_settings['all_languages'] as $language): ?>
    html += '<div class="menu-name"><input type="text" name="journal_settings[' + name + '][' + categ_id + '][subcategs][' + id + '][name][<?php echo $language['language_id']; ?>]" value="' + defaults.name + '"/>';
    html += '<img src="view/image/flags/<?php echo $language['image']; ?>" title="<?php echo $language['name']; ?>" /></div>';
    <?php endforeach; ?>
    html += '</td>';
    html += '<td><input type="text" name="journal_settings[' + name + '][' + categ_id + '][subcategs][' + id + '][link]" value="' + defaults.link + '"/></td>';
    html += '<td><input class="small" type="text" name="journal_settings[' + name + '][' + categ_id + '][subcategs][' + id + '][sort_order]" value="' + defaults.sort_order + '"/></td>';
    html += '<td><select class="yes_no" name="journal_settings[' + name + '][' + categ_id + '][subcategs][' + id + '][new_window]" value="' + defaults.sort_order + '">';
    html += '<option value="1"><?php echo $text_yes; ?></option>';
    html += '<option value="0" selected="selected"><?php echo $text_no; ?></option>';
    html += '</select></td>';
    html += '<td><a href="#" class="remove-image button">Remove</a></td>';
    html += '</tr></tbody>';

    var $pos = $table;

    for (var i=0; i<$table.attr('data-count'); i++) {
      $pos.removeClass('subcateg-last');
      $pos = $pos.next();
    }

    $pos.before(html);
    $table.find('.yes_no').switchify();

  }


  $(function(){

    // image upload
    (function(){

      $('.choose-img').live('click', function(){
        console.log($(this).parent());
        var field = $(this).parent().find('input').attr("id");
        var thumb = $(this).parent().find('img').attr("id");
        console.log(field + ' - ' + thumb);
        image_upload(field, thumb);
        return false;
      });

      $('.clear-img').click(function(){
        $(this).parent().find('input').val('');
        $(this).parent().find('img').attr('src', '<?php echo $no_image; ?>');

        return false;
      });
    })();

    // editor
    (function(){
      $('.input_editor textarea').each(function(){
        CKEDITOR.replace($(this).attr('id'), {
          filebrowserBrowseUrl: 'index.php?route=common/filemanager&token=<?php echo $token; ?>',
          filebrowserImageBrowseUrl: 'index.php?route=common/filemanager&token=<?php echo $token; ?>',
          filebrowserFlashBrowseUrl: 'index.php?route=common/filemanager&token=<?php echo $token; ?>',
          filebrowserUploadUrl: 'index.php?route=common/filemanager&token=<?php echo $token; ?>',
          filebrowserImageUploadUrl: 'index.php?route=common/filemanager&token=<?php echo $token; ?>',
          filebrowserFlashUploadUrl: 'index.php?route=common/filemanager&token=<?php echo $token; ?>'
        });
      });
    })();

    // multi upload
    (function(){

      $('.add-image').click(function(){
        var $table = $(this).parent().find('table');
        add_image($table);
        return false;
      });

      $('.remove-image').live('click', function(){
        var $parent = $(this).parent().parent().parent();
        var sub_categs = $parent.attr('data-class');
        if (sub_categs) {
          $('.subcateg_' + sub_categs).remove();
        }
        var parent_categ = $parent.attr('data-parent-categ');
        $parent.remove();
        if ($.isNumeric(parent_categ)) {
          var parent_class = $('.main-categ-' + parent_categ).attr('data-class');
          $('.subcateg_' + parent_class).removeClass('subcateg-last').last().addClass('subcateg-last');
          $('.main-categ-' + parent_categ).attr('data-count', $('.subcateg_' + parent_class).length);
        }
        is_empty();
        return false;
      });

      is_empty();

    })();

    // menus
    (function(){
      $('.add-top-menu-item').click(function(){
        var $table = $(this).parent().find('table');
        add_top_menu_item($table);
        return false;
      });

      // $('.add-top-menu-item').live('click', function(){
      //   $(this).parent().parent().parent().remove();
      //   // is_empty();
      //   return false;
      // });

      $('.add-categ-menu-item').click(function(){
        var $table = $(this).parent().find('table');
        add_categ_menu_item($table);
        return false;
      });

      // $('.add-categ-menu-item').live('click', function(){
      //   $(this).parent().parent().parent().remove();
      //   // is_empty();
      //   return false;
      // });

      $('.add-categ-sub-menu').live('click', function(){
        // console.log($(this).parent().parent().parent());
        var $table = $(this).parent().parent().parent();
        add_categ_sub_menu($table);
        $('.yes_no').switchify();
        return false;
      });

      // is_empty();
    })();

    // theme management
    (function(){
      $("#journal-theme-selector").change(function(){
        location = $(this).attr("data-href") + "&theme=" + $(this).val();
      });

      $(".reset-theme").click(function() {
        if (!confirm('Confirm reset?')) return false;
        var category = $('.main-tabs a.selected').attr('href');
        var subcategory = $(category + ' .sec-tabs a.selected').attr('href');
        var selector = subcategory ? category + ' ' + subcategory : category;
        $(selector + ' .value').each(function(){

          // reset selects, inputs, textarea
          $(this).find('select,input,textarea').each(function(){
            if (!$(this).attr('data-default')) return;
            $(this).val($(this).attr('data-default'));
            if ($(this).hasClass('color')) {
              $(this)[0].color.fromString($(this).attr('data-default'));
            }
          });

          $(this).find('select').not($('.yes_no')).each(function(){
            var select = $(this);
            var wrap = select.prev();
            wrap.text($('option:selected', this).text());
          });

          $(this).find('.yes_no').each(function(){
            var $controls = $(this).data('switch').data('controls');
            if ($(this).val() === 'on') {
              $controls.on();
            } else {
              $controls.off();
            }
          });

          // reset images
          $(this).find('img.upload-thumb').each(function(){
            if (!$(this).attr('data-default')) return;
            $(this).attr("src", $(this).attr('data-default'));
          });

          // reset multiupload
          $(this).find('table.multiupload').each(function(){
            $(this).find('tbody').remove();
            is_empty();
            if (!$(this).attr('data-default')) return;
            var def = $.parseJSON($(this).attr('data-default'));
            var $table = $(this).parent().find('table');
            // console.log(def);
            $.each(def, function(index, value){
              // console.log($table);
              // console.log(value);
              add_image($table, value);
            });
          });
        });
        return false;
      });

      $(".delete-theme").click(function() {
        if (!confirm('Confirm delete?')) return false;
        location = $(this).attr("data-href");
        return false;
      });

      $('.do-save-btn').click(function(){
        $("#form").prepend('<input type="hidden" name="journal_new_theme" value="' + $("#myModal .name").val() + '" />');
        $("#form").submit();
        return false;
      });
    })();

    (function(){
      var fonts_url = '<?php echo str_replace("&amp;", "&", $fonts_url); ?>';
      $('#main-tabs-fonts').load(fonts_url, function(){
        var sel = $('#main-tabs-fonts select');
        var wrap = sel.parent();
        sel.css('opacity', 0);
        sel.wrap('<div class="select-wrap" />');
        $('<span class="val"></span>').prependTo($('.select-wrap'));
        sel.each(function(){
          var select = $(this);
            var wrap = select.prev();
            select.change(function () {
                wrap.text($('option:selected', this).text());
            });
        }).trigger('change');

        var html = '<thead><tr>';
        html += '<td><?php echo $th_var_name; ?></td><td>';
        html += '<span class="th-font-name"><?php echo $th_font_name; ?></span>';
        html += '<span class="th-font-size"><?php echo $th_font_size; ?></span>';
        // html += '<span class="th-line-height"><?php echo $th_line_height; ?></span>';
        html += '<span class="th-font-weight"><?php echo $th_font_weight; ?></span>';
        html += '<span class="th-font-style"><?php echo $th_font_style; ?></span>';
        html += '<span class="th-font-transform"><?php echo $th_font_transform; ?></span>';

        html += '</td></tr></thead>';
        $('#main-tabs-fonts table.form').prepend(html);
      });
    })();
  });

})(jQuery);
</script>
<?php echo $footer; ?>