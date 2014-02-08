<?php
class ControllerModuleJournalSlider extends Controller {
	private $error = array(); 

	public function __construct($reg) {
		parent::__construct($reg);

		// add imports
		$this->document->addStyle('//fonts.googleapis.com/css?family=Oswald', 'stylesheet prefetch');

		$this->document->addScript('view/javascript/journal/journal.js');
		$this->document->addStyle('view/stylesheet/journal/journal.css');

		$this->document->addStyle('view/bootstrap/css/bootstrap.css');
		$this->document->addScript('view/bootstrap/js/bootstrap.min.js');
		$this->document->addStyle('view/javascript/journal/jquery.switch/jquery.switch.css');
		$this->document->addScript('view/javascript/journal/jquery.switch/jquery.switch.min.js');

		$this->document->addStyle('view/javascript/journal/jquery.switch/prettyCheckable.css');
		$this->document->addScript('view/javascript/journal/jquery.switch/prettyCheckable.js');
		$this->document->addScript('view/javascript/journal/plugins.js');

		$this->document->addScript('view/javascript/journal/journal.js');

		$this->load->language('module/journal_slider');
		$this->load->model('journal/slider');
		$this->document->setTitle($this->language->get('doc_title'));
		$this->addBreadcrumbs();
		$this->data['token'] = $this->session->data['token'];

		$this->data['url_active'] = $this->url->link('module/journal_slider', 'token=' . $this->session->data['token'], 'SSL');
		$this->data['url_list'] = $this->url->link('module/journal_slider/banners', 'token=' . $this->session->data['token'], 'SSL');

		$this->loadLanguageVars(array(
			'tab_active',
			'tab_list',
			'no_modules_created'
		));

		$this->data['error_warning'] = false;
	}

	public function install() {
		$this->model_journal_slider->install();
	}

	public function uninstall() {
		$this->model_journal_slider->uninstall();
	}

	private function addBreadcrumbs() {
		$this->data['breadcrumbs'] = array();

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('module/journal_slider', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);
	}

	private function loadLanguageVars($vars = array()) {
		foreach ($vars as $var) {
			$this->data[$var] = $this->language->get($var);
		}
	}

	public function index() {   

		$this->load->model('setting/setting');
				
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
			$this->model_setting_setting->editSetting('journal_slider', $this->request->post);		
					
			$this->session->data['success'] = $this->language->get('text_success');

			$this->redirect($this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL'));
		}

		$this->loadLanguageVars(array(
			'heading_title',
			'doc_title',
			
			'button_cancel',
			'button_save',
			'button_view_banners',

			'entry_banner',
			'entry_dimension',
			'entry_layout',
			'entry_position',
			'entry_status',
			'entry_sort_order',

			'text_content_top',
			'text_column_left',
			'text_column_right',
			'text_content_bottom',

			'text_enabled',
			'text_disabled',

			'button_remove',
			'button_add_banner'
		));	

		$this->data['action'] = $this->url->link('module/journal_slider', 'token=' . $this->session->data['token'], 'SSL');
		$this->data['cancel'] = $this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL');
		$this->data['new_banner'] = $this->url->link('module/journal_slider/new_banner', 'token=' . $this->session->data['token'], 'SSL');
		$this->data['view_banners'] = $this->url->link('module/journal_slider/banners', 'token=' . $this->session->data['token'], 'SSL');

		$this->data['modules'] = array();

		if (isset($this->error['dimension'])) {
			$this->data['error_dimension'] = $this->error['dimension'];
		} else {
			$this->data['error_dimension'] = array();
		}
		
		if (isset($this->request->post['journal_slider_module'])) {
			$this->data['modules'] = $this->request->post['journal_slider_module'];
		} elseif ($this->config->get('journal_slider_module')) { 
			$this->data['modules'] = $this->config->get('journal_slider_module');
		}	

		$this->load->model('design/layout');
		
		$this->data['layouts'] = $this->model_design_layout->getLayouts();

		$banners = $this->model_journal_slider->getBanners();

		$this->data['banners'] = array();

		foreach ($banners as $banner) {
			$opts = unserialize($banner['options']);
			$this->data['banners'][] = array(
				'name' => $opts['name'],
				'banner_id'	=> $banner['id']
			);
		}

		$this->template = 'module/journal_slider.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);	
				
		$this->response->setOutput($this->render());
	}		

	public function new_banner() {
		if ($this->request->server['REQUEST_METHOD'] == 'POST' && $this->validateForm()) {
			$options = $this->request->post['banner_options'];
			$images = $this->request->post['banner_image'];
			$this->model_journal_slider->addBanner($options, $images);
			$this->redirect($this->url->link('module/journal_slider/banners', 'token=' . $this->session->data['token'], 'SSL'));
		}

		$this->getForm();
	}

	public function banners() {

		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('heading_title_banners_list'),
			'href'      => $this->url->link('module/journal_slider/banners', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);

		$this->data['insert'] = $this->url->link('module/journal_slider/new_banner', 'token=' . $this->session->data['token'], 'SSL');
		$this->data['delete'] = $this->url->link('module/journal_slider/delete_banner', 'token=' . $this->session->data['token'], 'SSL');
		$this->data['action'] = $this->url->link('module/journal_slider/update_banner', 'token=' . $this->session->data['token'], 'SSL');
		$this->data['view_active_banners'] = $this->url->link('module/journal_slider', 'token=' . $this->session->data['token'], 'SSL');

		// get db filters
		$all_banners = $this->model_journal_slider->getBanners();
		$this->data['banners_list'] = array(); 

		foreach ($all_banners as $banner) {
			$opt = unserialize($banner['options']);
			$this->data['banners_list'][] = array(
				'id'	=> $banner['id'],
				'name'	=> $opt['name'],
			);
		}

		$this->loadLanguageVars(array(
			'heading_title',
			'doc_title',
			'button_active_banners',
			'button_insert',
			'button_delete',
			'button_edit',

			'column_category',
			'column_action',

			'text_no_results'
		));	

		$this->template = 'module/journal_slider_banners.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
	}

	public function update_banner() {
		if ($this->request->server['REQUEST_METHOD'] == 'POST'  && $this->validateForm()) {
			$options = $this->request->post['banner_options'];
			$images = $this->request->post['banner_image'];
			
			$this->model_journal_slider->editBanner($this->request->get['banner_id'], $options, $images);

			$this->redirect($this->url->link('module/journal_slider/banners', 'token=' . $this->session->data['token'], 'SSL'));
		}

		$this->getForm();
	}

	public function delete_banner() {
		if ($this->request->server['REQUEST_METHOD'] == 'POST') {
			$selected = $this->request->post['selected'];
			foreach ($selected as $sel) {
				$this->model_journal_slider->deleteBanner($sel);
			}
		}
		$this->redirect($this->url->link('module/journal_slider/banners', 'token=' . $this->session->data['token'], 'SSL'));
	}

	private function getForm() {
		$this->loadLanguageVars(array(
			'heading_title_new_banner',
			'doc_title',
			'button_cancel',
			'button_save',
			'button_remove',

			'entry_name',
			'entry_effect',
			'entry_speed',
			'entry_interval',
			'entry_auto_play',
			'entry_show_navigation',
			'entry_show_bullets',
			'entry_show_bar',
			'entry_caption',
			'entry_link',
			'entry_image',
			'button_add_image',

			'text_yes',
			'text_no',
			'text_browse',
			'text_clear',
			'text_always',
			'text_hover',
			'text_never',
			'entry_outside_nav',
			'entry_pause_hover',
			'text_image_manager'
		));	

		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('heading_title_new_banner'),
			'href'      => $this->url->link('module/journal_slider/new_banner', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);

		$this->data['cancel'] = $this->url->link('module/journal_slider', 'token=' . $this->session->data['token'], 'SSL');
		if (isset($this->request->get['banner_id'])) {
			$this->data['action'] = $this->url->link('module/journal_slider/update_banner', 'token=' . $this->session->data['token'] . "&banner_id=" . $this->request->get['banner_id'], 'SSL');	
		} else {
			$this->data['action'] = $this->url->link('module/journal_slider/new_banner', 'token=' . $this->session->data['token'], 'SSL');
		}
		
		$this->data['new_banner'] = $this->url->link('module/journal_slider/new_banner', 'token=' . $this->session->data['token'], 'SSL');



		if (isset($this->error['name'])) {
			$this->data['error_name'] = $this->error['name'];
		} else {
			$this->data['error_name'] = '';
		}

		if (isset($this->error['speed'])) {
			$this->data['error_speed'] = $this->error['speed'];
		} else {
			$this->data['error_speed'] = '';
		}

		if (isset($this->error['interval'])) {
			$this->data['error_interval'] = $this->error['interval'];
		} else {
			$this->data['error_interval'] = '';
		}


		// get db values
		if (isset($this->request->get['banner_id'])) {
			$banner = $this->model_journal_slider->getBanner($this->request->get['banner_id']);
			$options = unserialize($banner['options']);
			$images = unserialize($banner['images']);
		} else {
			$options = array();
			$images = array();
		}

		$banner_defaults = array(
			'name'			=> '', 
			'fx'			=> 'random', 
			'transPeriod'	=> 900, 
			'time'			=> 3500,
			'autoAdvance'	=> 'y', 
			'navigation'	=> 'h', 
			'outside_nav'	=> 'y',
			'hover'	=> 'y',
			'pagination'	=> 'y',
			'bar'			=> 'y'
		);

		foreach ($banner_defaults as $key => $value) {
			if (isset($this->request->post['banner_options']) && isset($this->request->post['banner_options'][$key])) {
				$options[$key] = $this->request->post['banner_options'][$key];
			}
			if (!isset($options[$key])) {
				$options[$key] = $value;
			}
		}

		$default_banner_effects = array(
			'random', 
			'-',
			'simpleFade', 'scrollHorz', 'scrollTop' , 'scrollBottom', 'scrollLeft', 'scrollRight', 'stampede', 
			'--',
			'curtainTopLeft', 'curtainTopRight', 'curtainBottomLeft', 'curtainBottomRight', 'curtainSliceLeft', 'curtainSliceRight',
			'---',
			'blindCurtainTopLeft', 'blindCurtainTopRight', 'blindCurtainBottomLeft', 'blindCurtainBottomRight', 'blindCurtainSliceBottom', 'blindCurtainSliceTop', 
			'----',
			'mosaic', 'mosaicReverse', 'mosaicRandom', 'mosaicSpiral', 'mosaicSpiralReverse', 
			'-----',
			'topLeftBottomRight', 'bottomRightTopLeft', 'bottomLeftTopRight', 'bottomLeftTopRight', 
		);

		$this->data['banner_effects'] = array();

		foreach ($default_banner_effects as $effect) {
			if ($effect[0] === '-') {
				$this->data['banner_effects'][$effect] = '------';
			} else {
				$this->data['banner_effects'][$effect] = $this->language->get('effect_' . $effect);
			}			
		}

		$this->load->model('localisation/language');
		$this->load->model('tool/image');

		$this->data['languages'] = $this->model_localisation_language->getLanguages();

		if (isset($this->request->post['banner_image'])) {
			$banner_images = $this->request->post['banner_image'];
		} elseif (isset($this->request->get['banner_id'])) {
			$banner_images = is_array($images) ? $images : array();
		} else {
			$banner_images = array();
		}

		$this->data['options'] = $options;

		$this->data['banner_images'] = array();
		
		foreach ($banner_images as $banner_image) {
			if ($banner_image['image'] && file_exists(DIR_IMAGE . $banner_image['image'])) {
				$image = $banner_image['image'];
			} else {
				$image = 'no_image.jpg';
			}			
			
			$this->data['banner_images'][] = array(
				'banner_image_description' => $banner_image['banner_image_description'],
				'link'                     => $banner_image['link'],
				'image'                    => $image,
				'thumb'                    => $this->model_tool_image->resize($image, 100, 100)
			);	
		} 

		$this->data['no_image'] = $this->model_tool_image->resize('no_image.jpg', 100, 100);		

		$this->template = 'module/journal_slider_new_banner.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
	}

	private function validateForm() {
		if (!$this->user->hasPermission('modify', 'module/journal_slider')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}

		if (!isset($this->request->post['banner_options']) || utf8_strlen($this->request->post['banner_options']['name']) === 0) {
			$this->error['name'] = $this->language->get('error_name');			
		}

		if (!isset($this->request->post['banner_options']) || utf8_strlen($this->request->post['banner_options']['transPeriod'] === 0) || !is_numeric($this->request->post['banner_options']['transPeriod'])) {
			$this->error['speed'] = $this->language->get('error_speed');			
		}

		if (!isset($this->request->post['banner_options']) || utf8_strlen($this->request->post['banner_options']['time'] === 0)  || !is_numeric($this->request->post['banner_options']['time'])) {
			$this->error['interval'] = $this->language->get('error_interval');			
		}

		if (!$this->error) {
			return true;
		} else {
			return false;
		}	
	}

		private function validate() {
		if (!$this->user->hasPermission('modify', 'module/journal_slider')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}

		if (isset($this->request->post['journal_slider_module'])) {
			foreach ($this->request->post['journal_slider_module'] as $key => $value) {
				if (!$value['width'] || !$value['height']) {
					$this->error['dimension'][$key] = $this->language->get('error_dimension');
				}				
			}
		}	

		if (!$this->error) {
			return true;
		} else {
			return false;
		}	
	}
	
}
?>