<?php
class ModelJournalBanner extends Model {

	public function getBanner($id) {
		$filters = $this->db->query("SELECT * FROM " . DB_PREFIX . "journal_banner WHERE id = '" . (int)$id . "'");
		return $filters->row;
	}

}
?>