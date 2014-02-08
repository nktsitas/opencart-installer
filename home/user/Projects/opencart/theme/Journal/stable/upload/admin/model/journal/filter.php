<?php
class ModelJournalFilter extends Model {

	public function create_table() {
		$this->db->query('CREATE TABLE IF NOT EXISTS `' . DB_PREFIX . 'journal_filter` (
		   	`id` int(11) NOT NULL AUTO_INCREMENT,
  			`name` text COLLATE utf8_bin NOT NULL,
  			`filters` text COLLATE utf8_bin NOT NULL,
  			PRIMARY KEY (`id`)
		) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=5');
	}

	public function delete_table() {
		$this->db->query('DROP TABLE IF EXISTS `' . DB_PREFIX . 'journal_filter`');
	}

	public function addFilter($name, $filters) {
		$this->db->query("INSERT INTO " . DB_PREFIX . "journal_filter
                          SET `name` = '{$name}', `filters` = '" . serialize($filters) . "'");
	}

	public function getFilters() {
		$filters = $this->db->query("SELECT id, name FROM " . DB_PREFIX . "journal_filter");
		return $filters->rows;
	}

	public function getFilter($id) {
		$filters = $this->db->query("SELECT * FROM " . DB_PREFIX . "journal_filter WHERE id = '" . (int)$id . "'");
		return $filters->row;	
	}

	public function deleteFilter($id) {
		$this->db->query("DELETE FROM " . DB_PREFIX . "journal_filter WHERE id = '" . (int)$id . "'");
	}

	public function editFilter($id, $name, $filters) {		
		$this->db->query("UPDATE " . DB_PREFIX . "journal_filter
                          SET `name` = '{$name}', `filters` = '" . serialize($filters) . "' WHERE id = '" . (int)$id . "'");
	}

}
?>