<?php
class ControllerModuleJournalBgslider extends Controller {
	protected function index($setting) {
		static $module = 0;
		static $max = -1;

		$this->load->model('journal/bgslider');
		$this->load->model('tool/image');

		if (isset($setting['banner_id'])) {

			$priority = isset($setting['global']) && $setting['global'] == 1 ? 0 : 1;

			$results = $this->model_journal_bgslider->getBanner($setting['banner_id']);

			if (!isset($results['options']) || !isset($results['images'])) {
				return;
			}

			$options = unserialize($results['options']);
			$images = unserialize($results['images']);

			$imgs = array();

			foreach ($images as $image) {
				if (file_exists(DIR_IMAGE . $image['image'])) {
					$imgs[] = 'image/' . $image['image'];
				}
			}

			if (!count($imgs)) return;

			if ($priority < $max) return;

			$max = $priority;

			$this->document->addScript('catalog/view/javascript/journal/jquery.maximage.min.js');

			$this->document->journal_bgslider = array(
				'images' 	=> $imgs,
				'options' 	=> array(
					'cycleOptions' => array(
						'fx'				=> $options['fx'],
						'speed'				=> (int)$options['time'],
						'timeout'			=> $options['autoAdvance'] !== 'y' ? 0 : (int)$options['transPeriod'],
					)
				),
				'disabled'	=> isset($options['disable_mobile']) && $options['disable_mobile'] === 'y'
			);
		}
	}
}
?>