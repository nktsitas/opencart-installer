<?php
  
  $journal_fonts = $journal_settings['fonts'];

  function generate_font($setting) {
    $fonts = $setting['font_families'];
    $sizes = range(8, 60);
    $line_height = range(1.1, 2.0, 0.1);
    $weights = array('bold', 'normal');
    $styles = array('normal', 'italic', 'oblique');
    $transforms = array('none', 'uppercase', 'lowercase');

    $first_font = reset($fonts);

    if (!isset($setting['default_value']['font-family'])) $setting['default_value']['font-family'] = $first_font[0]['font_name'];
    if (!isset($setting['default_value']['font-size'])) $setting['default_value']['font-size'] = $sizes[0];
    // if (!isset($setting['default_value']['line-height'])) $setting['default_value']['line-height'] = $line_height[0];
    if (!isset($setting['default_value']['font-weight'])) $setting['default_value']['font-weight'] = $weights[0];
    if (!isset($setting['default_value']['font-style'])) $setting['default_value']['font-style'] = $styles[0];
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

    // echo '<select name="journal_settings[' . $setting['name'] . '][line-height]" data-default="' . $setting['default_value']['line-height'] . '">';
    // foreach ($line_height as $size) {
    //   if ($setting['value']['line-height'] == $size) {
    //     echo '<option value="' . $size . '" selected="selected">' . $size . 'px</option>';
    //   } else {
    //     echo '<option value="' . $size . '">' . $size . 'px</option>';
    //   }   
    // }
    // echo '</select>';

    echo '<select name="journal_settings[' . $setting['name'] . '][font-weight]" data-default="' . $setting['default_value']['font-weight'] . '">';
    foreach ($weights as $weight) {
      if ($setting['value']['font-weight'] == $weight) {
        echo '<option value="' . $weight . '" selected="selected">' . ucfirst($weight) . '</option>';
      } else {
        echo '<option value="' . $weight . '">' . ucfirst($weight) . '</option>';
      }   
    }
    echo '</select>';

    echo '<select name="journal_settings[' . $setting['name'] . '][font-style]" data-default="' . $setting['default_value']['font-style'] . '">';
    foreach ($styles as $style) {
      if ($setting['value']['font-style'] == $style) {
        echo '<option value="' . $style . '" selected="selected">' . ucfirst($style) . '</option>';
      } else {
        echo '<option value="' . $style . '">' . ucfirst($style) . '</option>';
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

  echo '<table class="form">' . "\n";
  $index = 0;
    foreach ($journal_fonts as $setting) {
      $index++;
      $cls = array('categ_' . $setting['category'], 'setting_' . $setting['name'], 'input_' . $setting['input']);
      if (isset($subcateg)) {
        $cls[] = 'subcateg_' . $setting['subcategory'];
      }
      echo '<tr class="' . implode(' ', $cls) . '"><td align="right" class="label">' . $setting['label'] . ': </td><td class="value">';
      switch ($setting['input']) {
        case 'font'       : generate_font($setting);        break;
      }
      echo '<a class="journal-tip" target="_blank" href="http://journal.digital-atelier.com/tips/font_' . $index . '.jpg"></a></td></tr>';
    }
    echo '</table>' . "\n";