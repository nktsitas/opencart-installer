<?php 
class ModelJournalCp extends Model {

	public function is_installed() {
		$tables = array(
			'journal_cp_categories',
			'journal_cp_fonts',
			'journal_cp_settings',
			'journal_cp_subcategories',
			'journal_cp_themes',
			'journal_cp_theme_settings',
		);
		// check if journal cp tables are created
		foreach ($tables as $table) {
			$sql = "SHOW TABLES LIKE '" . DB_PREFIX . $table ."'";
			$query = $this->db->query($sql);
			if ($query->num_rows == 0) {
				return false;
			}
		}
		return true;
	}

	public function getActiveTheme() {
		$query = $this->db->query("SELECT theme_id, status FROM " . DB_PREFIX . "journal_cp_themes WHERE active = 'yes'");
		return $query->row;
	}

	public function getThemeId($theme_name) {
		$query = $this->db->query("SELECT theme_id FROM " . DB_PREFIX . "journal_cp_themes WHERE theme_id = '" . mysql_real_escape_string($theme_name) . "'");
		return $query->row;	
	}

	public function getThemeSettings($theme_id) {
		$sql = "SELECT name, type, value, input, default_value, css_selector, css_property, is_serialized FROM " 
		. DB_PREFIX . "journal_cp_theme_settings INNER JOIN ". DB_PREFIX . "journal_cp_settings "
		. " on (" . DB_PREFIX . "journal_cp_theme_settings.setting_name = " . DB_PREFIX . "journal_cp_settings.name) "
		. " WHERE theme_id = '" . $theme_id . "'";
		$query = $this->db->query($sql);		
		return $query->rows;
	}

	public function getFontInfo($font_name) {
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "journal_cp_fonts WHERE font_name = '" . mysql_real_escape_string($font_name) . "'");
		return $query->row;
	}

}
?>