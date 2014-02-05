<?php
class ModelJournalCp extends Model {

	private static $VERSION = '1.2.0';

	// PRIMARY METHODS
	public function getThemes() {
		$sql = "SELECT * FROM " . DB_PREFIX . "journal_cp_themes";
		$query = $this->db->query($sql);
		return $query->rows;
	}

	public function getSettings() {
		$sql = "SELECT name, category, subcategory, input, options, is_serialized, sort_order FROM " . DB_PREFIX . "journal_cp_settings ORDER BY COALESCE(sort_order, 999999) ASC";
		$query = $this->db->query($sql);
		return $query->rows;
	}

	public function getSettings_v2() {
		$sql = "SELECT name, category, subcategory, input, options, is_serialized, sort_order FROM " . DB_PREFIX . "journal_cp_settings ORDER BY COALESCE(sort_order, 999999) ASC";
		$query = $this->db->query($sql);
		$data = array();
		foreach ($query->rows as $row) {
			$data[$row['name']] = $row;
		}
		return $data;
	}

	public function getCategories() {
		$sql = "SELECT category_name FROM " . DB_PREFIX . "journal_cp_categories ORDER BY sort_order ASC";
		$query = $this->db->query($sql);
		return $query->rows;
	}

	public function getSubcategories($category_name) {
		$sql = "SELECT subcategory_name FROM " . DB_PREFIX . "journal_cp_subcategories WHERE category_name = '" . $category_name . "' ORDER BY COALESCE(sort_order, 999999) ASC";
		$query = $this->db->query($sql);
		return $query->rows;
	}

	public function getFonts() {
		$sql = "SELECT * FROM " . DB_PREFIX . "journal_cp_fonts ORDER BY font_name ASC";
		$query = $this->db->query($sql);
		$data = array();
		// ---- make sure system fonts are first
		$data['system'] = array();
		$data['google'] = array();
		// ----
		foreach ($query->rows as $row) {
			$data[$row['group']][] = $row;
		}
		return $data;
	}

	// THEME SETTINGS
	public function addTheme($theme_id, $theme_name) {
		$sql = "UPDATE " . DB_PREFIX . "journal_cp_themes SET active = 'no'";
		$this->db->query($sql);
		$sql = "INSERT INTO " . DB_PREFIX . "journal_cp_themes (theme_id, theme_name) VALUES ('" . mysql_real_escape_string($theme_id) . "', '" . mysql_real_escape_string($theme_name) . "')";
		$this->db->query($sql);
	}

	public function removeTheme($theme_id) {
		$active = $this->getActiveTheme() == $theme_id;
		$sql = "DELETE FROM " . DB_PREFIX . "journal_cp_themes WHERE theme_id = '" . mysql_real_escape_string($theme_id) . "'";
		$this->db->query($sql);
		$sql = "DELETE FROM " . DB_PREFIX . "journal_cp_theme_settings WHERE theme_id = '" . mysql_real_escape_string($theme_id) . "'";
		$this->db->query($sql);
		if ($active) {
			$sql = "SELECT theme_id FROM " . DB_PREFIX . "journal_cp_themes WHERE core = 1 LIMIT 0, 1";
			$id = $this->db->query($sql)->row['theme_id'];
			$this->setActiveTheme($id);
		}
	}

	public function getActiveTheme() {
		$sql = "SELECT theme_id FROM " . DB_PREFIX . "journal_cp_themes WHERE active = 'yes'";
		return $this->db->query($sql)->row['theme_id'];
	}

	public function isCoreTheme($theme_id) {
		$sql = "SELECT core FROM " . DB_PREFIX . "journal_cp_themes WHERE theme_id = '" . mysql_real_escape_string($theme_id) . "'";
		return $this->db->query($sql)->row['core'] == 1;
	}

	public function setActiveTheme($theme_id) {
		$sql = "UPDATE " . DB_PREFIX . "journal_cp_themes SET active = 'yes' WHERE theme_id = '" . mysql_real_escape_string($theme_id) . "'";
		$this->db->query($sql);
		$sql = "UPDATE " . DB_PREFIX . "journal_cp_themes SET active = 'no' WHERE theme_id <> '" . mysql_real_escape_string($theme_id) . "'";
		$this->db->query($sql);
	}

	public function setThemeStatus($theme_id, $status) {
		$sql = "UPDATE " . DB_PREFIX . "journal_cp_themes SET status = '" . $status . "' WHERE theme_id = '" . mysql_real_escape_string($theme_id) . "'";
		$this->db->query($sql);
	}

	public function getThemeStatus($theme_id) {
		$sql = "SELECT status FROM " . DB_PREFIX . "journal_cp_themes WHERE theme_id = '" . mysql_real_escape_string($theme_id) . "'";
		return $this->db->query($sql)->row['status'];
	}

	public function getThemeSettings($theme_id) {
		$sql = "SELECT setting_name, value, default_value FROM " . DB_PREFIX . "journal_cp_theme_settings WHERE theme_id = '" . $theme_id . "'";
		$query = $this->db->query($sql);
		return $query->rows;
	}

	public function saveThemeSettings($theme_id, $settings, $update_defaults) {
		foreach ($settings as $key => $value) {
			$sql = "INSERT INTO " . DB_PREFIX . "journal_cp_theme_settings (theme_id, setting_name, value) VALUES('" .
				$theme_id . "', '" . $key . "', '" . mysql_real_escape_string($value) . "') ON DUPLICATE KEY UPDATE value = '" . mysql_real_escape_string($value) . "'";
			$this->db->query($sql);
			if ($update_defaults) {
				$sql = "UPDATE " . DB_PREFIX . "journal_cp_theme_settings SET default_value = value WHERE theme_id= '" . mysql_real_escape_string($theme_id)  . "'";
				$this->db->query($sql);
			}

		}
	}

	private function dump($sql_file) {
		$file = DIR_APPLICATION . 'model/journal/' . $sql_file;

		if (!file_exists($file)) {
			exit('Could not load sql file: ' . $file);
		}

		$lines = file($file);

		if ($lines) {
			$sql = '';

			foreach($lines as $line) {
				if ($line && (substr($line, 0, 2) != '--') && (substr($line, 0, 1) != '#')) {
					$sql .= $line;

					if (preg_match('/;\s*$/', $line)) {
						$sql = str_replace("`dev_1551_1_", "`" . DB_PREFIX, $sql);

						$this->db->query($sql);

						$sql = '';
					}
				}
			}
		}
	}

	public function install() {
		$this->dump('journal_install.sql');
		$this->load->model('setting/setting');
		$this->model_setting_setting->editSetting('journal', array('journal_version' => self::$VERSION));
	}

	public function uninstall() {
		$this->dump('journal_uninstall.sql');
	}

	public function update_journal() {
		$current_themes = $this->db->query('SELECT * FROM ' . DB_PREFIX . 'journal_cp_themes')->rows;
		$current_theme_settings = $this->db->query('SELECT * FROM ' . DB_PREFIX . 'journal_cp_theme_settings')->rows;
		$current_settings = array();

		foreach ($current_theme_settings as $setting) {
			$current_settings[$setting['theme_id'] . '-' . $setting['setting_name']] = $setting['value'];
		}

		$this->uninstall();
		$this->install();

		$new_theme_settings = $this->db->query('SELECT * FROM ' . DB_PREFIX . 'journal_cp_theme_settings')->rows;
		$new_settings = array();

		foreach ($new_theme_settings as $setting) {
			$new_settings[$setting['theme_id'] . '-' . $setting['setting_name']] = $setting['value'];
		}

		foreach ($current_themes as $theme) {
			$this->db->query('INSERT INTO ' . DB_PREFIX . 'journal_cp_themes (theme_id, theme_name, status, active, core) VALUES ("' . $theme['theme_id'] . '", "' . $theme['theme_name'] . '", "' . $theme['status'] . '", "' . $theme['active'] . '", "' . $theme['core'] .
				'") ON DUPLICATE KEY UPDATE theme_name="' . $theme['theme_name'] . '", status="' . $theme['status'] . '", active="' . $theme['active'] . '", core="' . $theme['core'] . '"');
		}


		foreach($current_theme_settings as $setting) {
			$key = $setting['theme_id'] . '-' . $setting['setting_name'];
			if (isset($current_settings[$key]) && !isset($new_settings[$key])) {
				$sql = "INSERT INTO " . DB_PREFIX . "journal_cp_theme_settings (theme_id, setting_name, value, default_value) VALUES('" .
				$setting['theme_id'] . "', '" . $setting['setting_name'] . "', '" . mysql_real_escape_string($setting['value']) . "', '" . mysql_real_escape_string($setting['default_value']) . "') ON DUPLICATE KEY UPDATE value = '" . mysql_real_escape_string($setting['value']) . "', default_value = '" . mysql_real_escape_string($setting['default_value']) . "'";
				$this->db->query($sql);
			}
			if (isset($current_settings[$key]) && isset($new_settings[$key]) && $current_settings[$key] != $new_settings[$key]) {
				$sql = 'UPDATE ' . DB_PREFIX . 'journal_cp_theme_settings SET value="' . mysql_real_escape_string($setting['value']) . '" WHERE theme_id="' . $setting['theme_id'] . '" AND setting_name = "' . $setting['setting_name'] . '"';
				$this->db->query($sql);
			}
		}

		$this->load->model('setting/setting');
		$this->model_setting_setting->editSetting('journal', array('journal_version' => self::$VERSION));
	}

	public function update_avaliable() {
		return strcmp(self::$VERSION, $this->config->get('journal_version')) > 0;
	}

	public function getCurrentVersion() {
		return $this->config->get('journal_version') ? $this->config->get('journal_version') : '1.0.0';
	}

}
?>