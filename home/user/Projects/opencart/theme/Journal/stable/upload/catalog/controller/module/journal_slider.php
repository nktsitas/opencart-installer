<?php
class ControllerModuleJournalSlider extends Controller {
	protected function index($setting) {
		static $module = 0;

		$this->load->model('journal/slider');
		$this->load->model('tool/image');

		$lang_id = (int)$this->config->get('config_language_id');

		$this->data['width'] = $setting['width'];
		$this->data['height'] = $setting['height'];
		$this->data['images'] = array();

		if (isset($setting['banner_id'])) {
			$results = $this->model_journal_slider->getBanner($setting['banner_id']);

			if (!isset($results['options']) || !isset($results['images'])) {
				return;
			}

			$options = unserialize($results['options']);
			$images = unserialize($results['images']);

			foreach ($images as $image) {

				$lid = isset($image['banner_image_description'][$lang_id]) ? $lang_id : key($image['banner_image_description']);

				if (file_exists(DIR_IMAGE . $image['image'])) {
					$this->data['images'][] = array(
						'title' => $image['banner_image_description'][$lid]['title'],
						'link'  => $image['link'],
						'image' => $this->model_tool_image->resize($image['image'], $setting['width'], $setting['height'])
					);
				}
			}

			$this->data['options'] = array(
				'fx'				=> $options['fx'],
				'time'				=> (int)$options['time'],
				'transPeriod'		=> (int)$options['transPeriod'],
				'autoAdvance'		=> $options['autoAdvance'] === 'y',
				'navigation'		=> $options['navigation'] === 'y' || $options['navigation'] === 'h',
				'pagination'		=> $options['pagination'] === 'y',
				'hover'				=> $options['hover'] === 'y',
				'loader'			=> isset($options['bar']) && $options['bar'] === 'y' ? 'bar' : 'none'
			);

			$this->data['show_on_hover'] = $options['navigation'] === 'h';
			$this->data['arrows_position'] = $options['outside_nav'] === 'y';

			$this->document->addStyle('catalog/view/theme/journal/stylesheet/camera.css', 'stylesheet prefetch');
			$this->document->addScript('catalog/view/javascript/journal/camera.min.js');
			$this->template = $this->config->get('config_template') . '/template/module/journal_slider.tpl';

		}

		$this->data['module'] = $module++;

		$this->render();

	}
}
?>