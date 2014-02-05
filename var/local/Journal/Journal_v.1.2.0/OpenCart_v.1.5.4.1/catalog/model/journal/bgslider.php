<?php
class ModelJournalBgslider extends Model {

	public function getBanner($id) {
		$filters = $this->db->query("SELECT * FROM " . DB_PREFIX . "journal_bgslider WHERE id = '" . (int)$id . "'");
		return $filters->row;	
	}

}
?>