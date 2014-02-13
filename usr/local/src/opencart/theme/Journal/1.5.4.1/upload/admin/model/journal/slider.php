<?php
class ModelJournalSlider extends Model {

	public function install() {
		$sql = 'CREATE TABLE IF NOT EXISTS`' . DB_PREFIX . 'journal_banners` (
		  `id` int(11) NOT NULL AUTO_INCREMENT,
		  `options` text COLLATE utf8_bin NOT NULL,
		  `images` text COLLATE utf8_bin NOT NULL,
		  PRIMARY KEY (`id`)
		)';
		$this->db->query($sql);
	}

	public function uninstall() {
		$sql = 'DROP TABLE IF EXISTS `' . DB_PREFIX . 'journal_banners`';
		$this->db->query($sql);
	}

	public function addBanner($options, $images) {
		foreach ($options as &$opt) {
			$opt = htmlentities($opt);
		}
		$options = mysql_real_escape_string(serialize($options));
		$images = mysql_real_escape_string(serialize($images));
		$this->db->query("INSERT INTO " . DB_PREFIX . "journal_banners
                          SET `options` = '{$options}', `images` = '{$images}'");
	}

	public function getBanners() {
		$filters = $this->db->query("SELECT * FROM " . DB_PREFIX . "journal_banners");
		return $filters->rows;
	}

	public function getBanner($id) {
		$filters = $this->db->query("SELECT * FROM " . DB_PREFIX . "journal_banners WHERE id = '" . (int)$id . "'");
		return $filters->row;	
	}

	public function deleteBanner($id) {
		$this->db->query("DELETE FROM " . DB_PREFIX . "journal_banners WHERE id = '" . (int)$id . "'");
	}

	public function editbanner($id, $options, $images) {
		foreach ($options as &$opt) {
			$opt = htmlentities($opt);
		}
		$options = mysql_real_escape_string(serialize($options));
		$images = mysql_real_escape_string(serialize($images));
		$this->db->query("UPDATE " . DB_PREFIX . "journal_banners
                          SET `options` = '{$options}', `images` = '{$images}' WHERE id = '" . (int)$id . "'");
	}

}
?>