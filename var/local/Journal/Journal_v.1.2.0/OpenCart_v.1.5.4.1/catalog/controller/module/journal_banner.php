<?php
class ControllerModuleJournalBanner extends Controller {

	private function url($new_image) {
		if (isset($this->request->server['HTTPS']) && (($this->request->server['HTTPS'] == 'on') || ($this->request->server['HTTPS'] == '1'))) {
			return $this->config->get('config_ssl') . 'image/' . $new_image;
		} else {
			return $this->config->get('config_url') . 'image/' . $new_image;
		}
	}

	protected function index($setting) {
		static $module = 0;

		$this->load->model('journal/banner');
		$this->load->model('tool/image');

		$this->data['height'] = $setting['height'];

		$this->data['images'] = array();

		if (isset($setting['banner_id'])) {

			$results = $this->model_journal_banner->getBanner($setting['banner_id']);

			if (!isset($results['images'])) {
				return;
			}

			$images = unserialize($results['images']);

			foreach ($images as $image) {

				if (file_exists(DIR_IMAGE . $image['image'])) {
					$this->data['images'][] = array(
						'link'  => $image['link'],
						'new_window'  => $image['new_window'],
						'image' => $this->url($image['image'])
					);
				}
			}

			if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/module/journal_banner.tpl')) {
				$this->template = $this->config->get('config_template') . '/template/module/journal_banner.tpl';
			} else {
				$this->template = 'default/template/module/journal_banner.tpl';
			}

		}

		$this->data['module'] = $module++;

		$this->render();

	}
}
?>