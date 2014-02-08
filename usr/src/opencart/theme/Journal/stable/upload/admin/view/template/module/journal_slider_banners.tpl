<?php echo $header; ?>
<div id="content">
        <!--    <div class="loader"> <p>Loading...</p></div> -->
    <div class="heading">
      <h1> <?php echo $doc_title; ?></h1>
      <div class="links">
          <a href="http://journal.digital-atelier.com/" class="demo-link" target="_blank">Journal Demo</a> &nbsp; | &nbsp; 
          <a href="http://journal.digital-atelier.com/docs" class="docs-link" target="_blank">Documentation</a> 
      </div>
      <div class="buttons"><a onclick="location = '<?php echo $insert; ?>'" class="btn btn-success">Create New</a><a onclick="$('form').submit();" class="btn btn-danger"><?php echo $button_delete; ?></a></div>
    </div>
  <div class="box">

    <div class="content">
      <div id="tabs" class="htabs">
        <a href="#tab-general" data-url="<?php echo $url_active; ?>"><?php echo $tab_active; ?></a>
        <a href="#tab-data" data-url="<?php echo $url_list; ?>"><?php echo $tab_list; ?></a>
      </div>
      <form action="<?php echo $delete; ?>" method="post" enctype="multipart/form-data" id="form">
        <table class="list">
          <thead>
            <tr>
              <td width="1" style="text-align: center;">
                Delete
                <!-- <input class="check" type="checkbox" onclick="$('input[name*=\'selected\']').attr('checked', this.checked);" /> -->
              </td>
              <td class="left"><?php echo $column_category; ?> </td>
              <td class="right"><?php echo $column_action; ?></td>
            </tr>
          </thead>
          <tbody>
            <?php if ($banners_list) { ?>
            <?php foreach ($banners_list as $banner) { ?>
            <tr>
              <td class="left" style="text-align: center;">
                <input class="check" type="checkbox" name="selected[]" value="<?php echo $banner['id']; ?>" />
              </td>
              <td class="left" style=" font-weight: bold; font-size: 13px "><?php echo $banner['name']; ?></td>
              <td class="right" style="width:100px">
               <a class="btn" href="<?php echo $action . '&banner_id=' . $banner['id']; ?>"><?php echo $button_edit; ?></a>
              </td>
            </tr>
            <?php } ?>
            <?php } else { ?>
            <tr>
              <td class="center no_modules" colspan="4"><?php echo $text_no_results; ?></td>
            </tr>
            <?php } ?>
          </tbody>
        </table>
      </form>
    </div>
  </div>
</div>
<script type="text/javascript">
$('#tabs a').tabs();
$("#tabs a").removeClass("selected");
$("#tabs > a + a").addClass("selected");
$("#tabs a").click(function(){
  top.location.href = $(this).attr("data-url");
});
</script>
<?php echo $footer; ?>