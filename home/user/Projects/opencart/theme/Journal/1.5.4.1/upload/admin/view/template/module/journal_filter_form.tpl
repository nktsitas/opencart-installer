<?php echo $header; ?>
<div id="content" class="create-filter">
         <!--   <div class="loader"> <p>Loading...</p></div> -->
    <div class="heading">
      <h1> <?php echo $doc_title; ?></h1>
      <div class="links">
          <a href="http://journal.digital-atelier.com/" class="demo-link" target="_blank">Journal Demo</a> &nbsp; | &nbsp; 
          <a href="http://journal.digital-atelier.com/docs" class="docs-link" target="_blank">Documentation</a> 
      </div>
      <div class="buttons"><a onclick="check_form();" class="btn btn-success"><?php echo $button_save; ?></a><a onclick="location = '<?php echo $cancel; ?>';" class="btn btn-danger"><?php echo $button_cancel; ?></a></div>
    </div>
  <?php if ($error_warning) { ?>
  <div class="warning"><?php echo $error_warning; ?></div>
  <?php } ?>
  <div class="box">

    <div class="content">

      <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">

        <table class="form new-filter">
          <tr>
            <td><span class="required">*</span> Module Name</td>
            <td>
              <input type="text" name="journal_filter_name" value="<?php echo $journal_filter_name; ?>" size="100" />
              <?php if ($error_name) { ?>
              <span class="error" style="display: inline-block;"><?php echo $error_name; ?></span>
              <?php } ?>
            </td>
          </tr>
        </table>

        <div class="vtabs">
          <?php $module_row = 1; $image_row = 1; ?>
          <?php foreach ($journal_filter as $module) { ?>
          <a href="#tab-module-<?php echo $module_row; ?>" id="module-<?php echo $module_row; ?>"><?php echo $tab_module . ' ' . $module_row; ?>&nbsp;<img src="view/image/delete.png" alt="" onclick="$('.vtabs a:first').trigger('click'); $('#module-<?php echo $module_row; ?>').remove(); $('#tab-module-<?php echo $module_row; ?>').remove(); return false;" /></a>
          <?php $module_row++; ?>
          <?php } ?>
          <span id="module-add"><?php echo $button_add_filter; ?>&nbsp;<img src="view/image/add.png" alt="" onclick="addModule();" /></span> </div>
        <?php $module_row = 1; ?>
        <?php foreach ($journal_filter as $module) { ?>


        <div id="tab-module-<?php echo $module_row; ?>" class="vtabs-content">
          <table class="form">
            <tr>
              <td><?php echo $entry_name; ?></td>
              <td><?php foreach ($languages as $language) { $value = isset($module['filter'][$language['language_id']]) ? $module['filter'][$language['language_id']] : '';?>
                <input type="text" class="med" name="journal_filter[<?php echo $module_row; ?>][filter][<?php echo $language['language_id']; ?>]" value="<?php echo $value; ?>" /> <img class="flag" src="view/image/flags/<?php echo $language['image']; ?>" title="<?php echo $language['name']; ?>" /><br />
                <?php } ?>
              </td>
            </tr>
            <tr>
              <td><?php echo $entry_status; ?></td>

              <td><select class="yes_no" name="journal_filter[<?php echo $module_row; ?>][status]">
                  <?php if ($module['status']) { ?>
                  <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                  <option value="0"><?php echo $text_disabled; ?></option>
                  <?php } else { ?>
                  <option value="1"><?php echo $text_enabled; ?></option>
                  <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                  <?php } ?>
                </select></td>

            </tr>
            <tr>
              <td><?php echo $entry_sort_order; ?></td>
              <td><input type="text" class="short" name="journal_filter[<?php echo $module_row; ?>][sort_order]" value="<?php echo $module['sort_order']; ?>" size="3" /></td>
            </tr>
            <tr>
              <td><?php echo $entry_default_section; ?></td>
              <td>
                <?php if (isset($module['default']) && $module['default']): ?>
                <input type="checkbox" class="check" name="journal_filter[<?php echo $module_row; ?>][default]" checked="checked" /></td>
                <?php else: ?>
                <input type="checkbox" class="check" name="journal_filter[<?php echo $module_row; ?>][default]" /></td>
                <?php endif; ?>
            </tr>
            <?php foreach ($module['products'] as $product) : ?>
            <tbody id="image-row<?php echo $image_row; ?>">
              <tr>
                <td class="left">
                  <input type="text" class="autocomplete" value="<?php echo $product['name']; ?>" /><input type="hidden" name="journal_filter[<?php echo $module_row; ?>][products][]" value="<?php echo $product['id']; ?>" /></td>
                <td class="right"><a onclick="$('#image-row<?php echo $image_row; ?>').remove();" class="btn"><?php echo $button_remove; ?></a></td>
              </tr>
            </tbody>
            <?php $image_row++; endforeach; ?>
            <tfoot><tr>
              <td colspan="2"><a onclick="addProduct(<?php echo $module_row; ?>);" class="btn btn-primary"><?php echo $button_add_product; ?></a></td>
            </tr></tfoot>
          </table>
        </div>
        <?php $module_row++; ?>
        <?php } ?>
      </form>
    </div>
  </div>
</div>

<script type="text/javascript"><!--

$('input[type=checkbox]').live('click', function(){
  $('input[type=checkbox]').not(this).removeAttr('checked');
});

function check_form() {
  if ($('.vtabs-content').length === 0) {
    alert('<?php echo $error_no_section; ?>');
    return false;
  }

  var error = false;

  $('.vtabs-content').each(function(){

    var $a = $('a[href=#' + $(this).attr('id') + ']');

    $(this).find('.autocomplete').each(function(){
      if ($(this).val().trim().length === 0) {        
        $a.click();
        alert('<?php echo $error_invalid_product_name; ?>');
        error = true;
        $(this).focus();
        return false;
      }
    });

    if (error) return false;

    $(this).find('input.med').each(function(){
      if ($(this).val().trim().length === 0) {
        $a.click();
        alert('<?php echo $error_no_section_name; ?>');
        error = true;
        $(this).focus();
        return false;
      }
    });

    if (error) return false;

    if($(this).find('tbody').length < 2) {
      $('a[href=#' + $(this).attr('id') + ']').click();
      alert('<?php echo $error_no_products_added; ?>');
      error = true;
      return false;
    }

  });
  if (error) return false;
  $('#form').submit();
}


var module_row = <?php echo $module_row; ?>;

function addModule() {  
  html  = '<div id="tab-module-' + module_row + '" class="vtabs-content">';
  html += '  <table class="form">';
  html += '    <tr>';
  html += '      <td><?php echo $entry_name; ?></td>';
  html += '      <td>';
  <?php foreach ($languages as $language) { ?>
  html += '<input class="med" type="text" name="journal_filter[' + module_row + '][filter][<?php echo $language['language_id']; ?>]" value="" /> <img class="flag" src="view/image/flags/<?php echo $language['image']; ?>" title="<?php echo $language['name']; ?>" /><br />';
  <?php } ?>
  html += '    </tr>';
  html += '    <tr>';
  html += '      <td><?php echo $entry_status; ?></td>';
  html += '      <td><select class="yes_no" name="journal_filter[' + module_row + '][status]">';
  html += '        <option value="1"><?php echo $text_enabled; ?></option>';
  html += '        <option value="0"><?php echo $text_disabled; ?></option>';
  html += '      </select></td>';
  html += '    </tr>';
  html += '    <tr>';
  html += '      <td><?php echo $entry_sort_order; ?></td>';
  html += '      <td><input class="short" type="text" name="journal_filter[' + module_row + '][sort_order]" value="" size="3" /></td>';
  html += '    </tr>'; 
  html += '    <tr>';
  html += '      <td><?php echo $entry_default_section; ?></td>';
  html += '      <td><input type="checkbox" class="check" name="journal_filter[' + module_row + '][default]" /></td>';
  html += '    </tr>'; 
  html += '    <tfoot><tr>';
  html += '      <td colspan="2"><a onclick="addProduct(' + module_row + ');" class="btn btn-primary"><?php echo $button_add_product; ?></a></td>';
  html += '    </tr></tfoot>';
  html += '  </table>'; 
  html += '</div>';
  
  $('#form').append(html);

  $('.check').prettyCheckable();
  
    
  $('#module-add').before('<a href="#tab-module-' + module_row + '" id="module-' + module_row + '"><?php echo $tab_module; ?> ' + module_row + '&nbsp;<img src="view/image/delete.png" alt="" onclick="$(\'.vtabs a:first\').trigger(\'click\'); $(\'#module-' + module_row + '\').remove(); $(\'#tab-module-' + module_row + '\').remove(); return false;" /></a>');
  
  $('.vtabs a').tabs();
  
  $('#module-' + module_row).trigger('click');
  
  module_row++;
}

var image_row = <?php echo $image_row; ?>;

function addProduct(id) {
  html  = '<tbody id="image-row' + image_row + '">';
  html += '<tr>';
  html += '<td class="left">';
  html += '<input type="text" class="autocomplete" value="" /><input type="hidden" name="journal_filter[' + id + '][products][]" value="" /></td>'; 
  html += '<td class="right"><a onclick="$(\'#image-row' + image_row  + '\').remove();" class="btn"><?php echo $button_remove; ?></a></td>';
  html += '</tr>';
  html += '</tbody>'; 
  
  $("#tab-module-" + id + " table tfoot").before(html);
  
  image_row++;

  addAutoComplete();
}

function addAutoComplete() {
$('.autocomplete').autocomplete({
  delay: 0,
  source: function(request, response) {
    $.ajax({
      url: 'index.php?route=catalog/product/autocomplete&token=<?php echo $token; ?>&filter_name=' +  encodeURIComponent(request.term),
      dataType: 'json',
      success: function(json) { 
        response($.map(json, function(item) {
          return {
            label: item.name,
            value: item.product_id,
            model: item.model
          }
        }));
      }
    });
  }, 
  select: function(event, ui) {
    $(this).attr('value', ui.item.label);
    $(this).siblings('input').first().attr('value', ui.item.value);
    return false;
  },
  focus: function(event, ui) {
        return false;
    }
});
}
addAutoComplete();
//--></script> 
<script type="text/javascript"><!--
$('.vtabs a').tabs();
//--></script> 
<script type="text/javascript"><!--

<?php echo $footer; ?>