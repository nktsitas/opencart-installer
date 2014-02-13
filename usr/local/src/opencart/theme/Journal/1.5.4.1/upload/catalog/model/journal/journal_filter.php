<?php
class ModelJournalJournalFilter extends Model {

	public function getFilter($id) {
		$filters = $this->db->query("SELECT * FROM " . DB_PREFIX . "journal_filter WHERE id = '" . (int)$id . "'");
		return $filters->row;	
	}

}
?>