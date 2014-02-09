<?php
class ModelJournalSlider extends Model {

	public function getBanner($id) {
		$filters = $this->db->query("SELECT * FROM " . DB_PREFIX . "journal_banners WHERE id = '" . (int)$id . "'");
		return $filters->row;	
	}

}
?>