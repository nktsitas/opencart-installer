<?php echo $header; ?>
<div id="content">
       <!-- <div class="loader"> <p>Loading...</p></div> -->
    <div class="heading">
      <h1> <?php echo $doc_title; ?></h1>
      <div class="links">
          <a href="http://journal.digital-atelier.com/" class="demo-link" target="_blank">Journal Demo</a> &nbsp; | &nbsp; 
          <a href="http://journal.digital-atelier.com/docs" class="docs-link" target="_blank">Documentation</a> 
      </div>
      <div class="buttons"><a onclick="$('#form').submit();" class="btn btn-success"><?php echo $button_save; ?></a><a onclick="location = '<?php echo $cancel; ?>';" class="btn btn-danger"><?php echo $button_cancel; ?></a></div>
    </div>
  <?php if ($error_warning) { ?>
  <div class="warning"><?php echo $error_warning; ?></div>
  <?php } ?>
  <div class="box">

    <div class="content">
      <div id="tabs" class="htabs">
        <a href="#tab-general" data-url="<?php echo $url_settings; ?>"><?php echo $tab_settings; ?></a>
        <a href="#tab-data" data-url="<?php echo $url_filters; ?>"><?php echo $tab_filters; ?></a>
      </div>      
      <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
        <table id="module" class="list">
          <thead>
            <tr>
              <td class="left"><?php echo $entry_banner; ?></td>
              <td class="left"><?php echo $entry_layout; ?></td>
              <td class="left"><?php echo $entry_position; ?></td>
              <td class="left"><?php echo $entry_status; ?></td>
              <td class="left"><?php echo $entry_scroll_top;?></td>
              <td class="right"><?php echo $entry_sort_order; ?></td>
              <td class="left">Remove</td>
            </tr>
          </thead>
          <?php $module_row = 0; ?>
          <?php foreach ($modules as $module) { ?>
          <tbody id="module-row<?php echo $module_row; ?>">
            <tr>
              <td class="left"><select class="selbox" name="journal_filter_module[<?php echo $module_row; ?>][filter_id]">
                  <?php foreach ($filters as $banner) { ?>
                  <?php if ($banner['id'] == $module['filter_id']) { ?>
                  <option value="<?php echo $banner['id']; ?>" selected="selected"><?php echo $banner['name']; ?></option>
                  <?php } else { ?>
                  <option value="<?php echo $banner['id']; ?>"><?php echo $banner['name']; ?></option>
                  <?php } ?>
                  <?php } ?>
                </select></td>               
              <td class="left"><select name="journal_filter_module[<?php echo $module_row; ?>][layout_id]">
                  <?php foreach ($layouts as $layout) { ?>
                  <?php if ($layout['layout_id'] == $module['layout_id']) { ?>
                  <option value="<?php echo $layout['layout_id']; ?>" selected="selected"><?php echo $layout['name']; ?></option>
                  <?php } else { ?>
                  <option value="<?php echo $layout['layout_id']; ?>"><?php echo $layout['name']; ?></option>
                  <?php } ?>
                  <?php } ?>
                </select></td>
              <td class="left"><select name="journal_filter_module[<?php echo $module_row; ?>][position]">
                  <?php if ($module['position'] == 'content_top') { ?>
                  <option value="content_top" selected="selected"><?php echo $text_content_top; ?></option>
                  <?php } else { ?>
                  <option value="content_top"><?php echo $text_content_top; ?></option>
                  <?php } ?>
                  <?php if ($module['position'] == 'content_bottom') { ?>
                  <option value="content_bottom" selected="selected"><?php echo $text_content_bottom; ?></option>
                  <?php } else { ?>
                  <option value="content_bottom"><?php echo $text_content_bottom; ?></option>
                  <?php } ?>

                <!--  
                  <?php if ($module['position'] == 'column_left') { ?>
                  <option value="column_left" selected="selected"><?php echo $text_column_left; ?></option>
                  <?php } else { ?>
                  <option value="column_left"><?php echo $text_column_left; ?></option>
                  <?php } ?>
                  <?php if ($module['position'] == 'column_right') { ?>
                  <option value="column_right" selected="selected"><?php echo $text_column_right; ?></option>
                  <?php } else { ?>
                  <option value="column_right"><?php echo $text_column_right; ?></option>
                  <?php } ?> 
                -->

                </select></td>
              <td class="left"><select class='yes_no' name="journal_filter_module[<?php echo $module_row; ?>][status]">
                  <?php if ($module['status']) { ?>
                  <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                  <option value="0"><?php echo $text_disabled; ?></option>
                  <?php } else { ?>
                  <option value="1"><?php echo $text_enabled; ?></option>
                  <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                  <?php } ?>
                </select></td>
              <td class="left"><select  class="yes_no" name="journal_filter_module[<?php echo $module_row; ?>][scrolltop]">
                  <?php if ($module['scrolltop']) { ?>
                  <option value="1" selected="selected"><?php echo $text_yes; ?></option>
                  <option value="0"><?php echo $text_no; ?></option>
                  <?php } else { ?>
                  <option value="1"><?php echo $text_yes; ?></option>
                  <option value="0" selected="selected"><?php echo $text_no; ?></option>
                  <?php } ?>
                </select></td>           
              <td class="right"><input class="short" type="text" name="journal_filter_module[<?php echo $module_row; ?>][sort_order]" value="<?php echo $module['sort_order']; ?>" size="3" /></td>
              <td class="left"><a onclick="$('#module-row<?php echo $module_row; ?>').remove();" class="btn"><?php echo $button_remove; ?></a></td>
            </tr>
          </tbody>
          <?php $module_row++; ?>
          <?php } ?>
          <tfoot>
            <tr>
              <td colspan="6"></td>
              <td class="left"><a onclick="addModule();" class="btn btn-primary"><?php echo $button_add; ?></a></td>
            </tr>
          </tfoot> 
        </table>
      </form>
    </div>
  </div>
</div>
<script type="text/javascript"><!--
var module_row = <?php echo $module_row; ?>;

function addModule() {  
  if (<?php echo count($filters); ?> == 0) {
    alert('<?php echo $no_modules_created; ?>');
    return false;
  }
  html  = '<tbody id="module-row' + module_row + '">';
  html += '  <tr>';
  html += '    <td class="left"><select name="journal_filter_module[' + module_row + '][filter_id]">';
  <?php foreach ($filters as $banner) { ?>
  html += '      <option value="<?php echo $banner['id']; ?>"><?php echo addslashes($banner['name']); ?></option>';
  <?php } ?>
  html += '    </select></td>';    
  html += '    <td class="left"><select name="journal_filter_module[' + module_row + '][layout_id]">';
  <?php foreach ($layouts as $layout) { ?>
  html += '      <option value="<?php echo $layout['layout_id']; ?>"><?php echo addslashes($layout['name']); ?></option>';
  <?php } ?>
  html += '    </select></td>';
  
  html += '    <td class="left"><select name="journal_filter_module[' + module_row + '][position]">';
  html += '      <option value="content_top"><?php echo $text_content_top; ?></option>';
  html += '      <option value="content_bottom"><?php echo $text_content_bottom; ?></option>';
  html += '    </select></td>';
  html += '    <td class="left"><select class="yes_no" name="journal_filter_module[' + module_row + '][status]">';
  html += '      <option value="1" selected="selected"><?php echo $text_enabled; ?></option>';
  html += '      <option value="0"><?php echo $text_disabled; ?></option>';
  html += '    </select></td>';
  html += '    <td class="left"><select class="yes_no" name="journal_filter_module[' + module_row + '][scrolltop]">';
  html += '      <option value="1" selected="selected"><?php echo $text_yes; ?></option>';
  html += '      <option value="0"><?php echo $text_no; ?></option>';
  html += '    </select></td>';
  html += '    <td class="right"><input type="text" name="journal_filter_module[' + module_row + '][sort_order]" value="" size="3" /></td>';
  html += '    <td class="left"><a onclick="$(\'#module-row' + module_row + '\').remove();" class="btn"><?php echo $button_remove; ?></a></td>';
  html += '  </tr>';
  html += '</tbody>';
  
  $('#module tfoot').before(html);

  $('.yes_no').switchify();
  
  module_row++;
}
//--></script> 
<script type="text/javascript">
$('#tabs a').tabs();

$("#tabs a").click(function(){
  top.location.href = $(this).attr("data-url");
});
</script>
<?php echo $footer; ?>