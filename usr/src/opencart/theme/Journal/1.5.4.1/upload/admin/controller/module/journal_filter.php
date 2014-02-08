<?php
class ControllerModuleJournalFilter extends Controller {
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
		
		$this->load->language('module/journal_filter');
		$this->load->model('journal/filter');
		$this->load->model('catalog/product');
		
		$this->document->setTitle($this->language->get('doc_title'));
		
		$this->addBreadcrumbs();
		
		$this->loadLanguageVars(array(
			'tab_settings', 
			'tab_filters',
			'no_modules_created'
		));

		$this->data['token'] = $this->session->data['token'];
		
		$this->data['url_settings'] = $this->url->link('module/journal_filter', 'token=' . $this->session->data['token'], 'SSL');
		$this->data['url_filters'] = $this->url->link('module/journal_filter/filters', 'token=' . $this->session->data['token'], 'SSL');
	}

	public function install() {
		$this->model_journal_filter->create_table();
	}

	public function uninstall() {
		$this->model_journal_filter->delete_table();
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
			'href'      => $this->url->link('module/journal_filter', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);
	}

	private function loadLanguageVars($vars = array()) {
		foreach ($vars as $var) {
			$this->data[$var] = $this->language->get($var);
		}
	}

	public function index() {
		$this->data['action'] = $this->url->link('module/journal_filter', 'token=' . $this->session->data['token'], 'SSL');
		$this->data['cancel'] = $this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL');

		$this->load->model('setting/setting');
				
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateSettings()) {			
			$this->model_setting_setting->editSetting('journal_filter', $this->request->post);	

			$this->session->data['success'] = $this->language->get('text_success');
						
			$this->redirect($this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL'));
		}

		$this->loadLanguageVars(array(
			'heading_title',
			'doc_title',
			'button_save',
			'button_cancel',
			'button_add',
			'button_remove',

			'column_category',
			'column_action',

			'text_content_top',
			'text_content_bottom',
			'text_column_left',
			'text_column_right',
			'text_enabled',
			'text_disabled',

			'text_no_results',

			'text_layout',
			'text_position',
			'text_status',
			'text_yes',
			'text_no',
			
			'entry_banner',
			'entry_dimension',
			'entry_layout',
			'entry_position',
			'entry_extended',
			'entry_status',
			'entry_scroll_top',
			'entry_sort_order',			
		));	

		$this->load->model('design/layout');

		if (isset($this->error['warning'])) {
			$this->data['error_warning'] = $this->error['warning'];
		} else {
			$this->data['error_warning'] = '';
		}

		if (isset($this->request->post['journal_filter_module'])) {
			$this->data['modules'] = $this->request->post['journal_filter_module'];
		} elseif ($this->config->get('journal_filter_module')) { 
			$this->data['modules'] = $this->config->get('journal_filter_module');
		} else {
			$this->data['modules'] = array();
		}

		
		$this->data['layouts'] = $this->model_design_layout->getLayouts();
		$this->data['filters'] = $this->model_journal_filter->getFilters();

		$this->template = 'module/journal_filter.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
	}

	public function filters() {   
		// action buttons
		$this->data['insert'] = $this->url->link('module/journal_filter/insert', 'token=' . $this->session->data['token'], 'SSL');
		$this->data['delete'] = $this->url->link('module/journal_filter/delete', 'token=' . $this->session->data['token'], 'SSL');
		$this->data['action'] = $this->url->link('module/journal_filter/update', 'token=' . $this->session->data['token'], 'SSL');

		// get db filters
		$this->data['filters'] = $this->model_journal_filter->getFilters();

		$this->loadLanguageVars(array(
			'heading_title',
			'doc_title',
			'button_insert',
			'button_delete',
			'button_edit',

			'column_category',
			'column_action',

			'text_no_results'
		));	

		$this->template = 'module/journal_filter_filters.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
	}		

	public function insert() {
		// echo "<pre>" . print_r($this->request->post, TRUE) . "</pre>";
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
			// echo "<pre>" . print_r($this->request->post, TRUE) . "</pre>"; return;
			$this->model_journal_filter->addFilter($this->request->post['journal_filter_name'], $this->request->post['journal_filter']);
			$this->redirect($this->url->link('module/journal_filter/filters', 'token=' . $this->session->data['token'], 'SSL'));
		}

		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('heading_title_insert'),
			'href'      => $this->url->link('module/journal_filter/insert', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);

		$this->getForm();
	}

	public function update() {
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
			// echo "<pre>" . print_r($this->request->post, TRUE) . "</pre>"; return;
			$this->model_journal_filter->editFilter($this->request->get['filter_id'], $this->request->post['journal_filter_name'], $this->request->post['journal_filter']);
			$this->redirect($this->url->link('module/journal_filter/filters', 'token=' . $this->session->data['token'], 'SSL'));
		}
        
        $this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('heading_title_edit'),
			'href'      => $this->url->link('module/journal_filter/update', 'token=' . $this->session->data['token'] . '&filter_id=' . (int)$this->request->get['filter_id'], 'SSL'),
      		'separator' => ' :: '
   		);

		$this->getForm();
	}

	public function delete() {
		if ($this->request->server['REQUEST_METHOD'] == 'POST') {
			$selected = $this->request->post['selected'];
			foreach ($selected as $sel) {
				$this->model_journal_filter->deleteFilter($sel);
			}
		}
		$this->redirect($this->url->link('module/journal_filter/filters', 'token=' . $this->session->data['token'], 'SSL'));
	}

	private function getForm() {
		// action buttons
		
		if (isset($this->request->get['filter_id'])) {
			$this->data['action'] = $this->url->link('module/journal_filter/update', 'token=' . $this->session->data['token'] . '&filter_id=' . (int)$this->request->get['filter_id'], 'SSL');
		} else {
			$this->data['action'] = $this->url->link('module/journal_filter/insert', 'token=' . $this->session->data['token'], 'SSL');
		}
		$this->data['cancel'] = $this->url->link('module/journal_filter', 'token=' . $this->session->data['token'], 'SSL');

		$this->loadLanguageVars(array(
			'heading_title',
			'doc_title',

			'entry_name',
			'entry_status',
			'entry_sort_order',
			'entry_title',
			'entry_default_section',

			'button_save',
			'button_cancel',
			'button_remove',
			'button_add_product',
			'button_add_filter',

			'text_enabled',
			'text_disabled',

			'tab_module',


			'error_no_section',
			'error_no_products_added',
			'error_no_section_name',
			'error_invalid_product_name',			

		));	

		$this->load->model('localisation/language');

		$this->data['languages'] = $this->model_localisation_language->getLanguages();

		if (isset($this->request->get['filter_id']) && ($this->request->server['REQUEST_METHOD'] != 'POST')) {
			$journal_filter = $this->model_journal_filter->getFilter($this->request->get['filter_id']);
			$journal_filter['filters'] = unserialize($journal_filter['filters']);
		} else {
			$journal_filter = array();	
		}

		if (isset($this->error['warning'])) {
			$this->data['error_warning'] = $this->error['warning'];
		} else {
			$this->data['error_warning'] = '';
		}

		if (isset($this->error['name'])) {
			$this->data['error_name'] = $this->error['name'];
		} else {
			$this->data['error_name'] = '';
		}

		if (isset($this->error['no_products'])) {
			$this->data['error_no_products'] = $this->error['no_products'];
		} else {
			$this->data['error_no_products'] = '';
		}

		if (isset($this->error['invalid_product'])) {
			$this->data['error_invalid_product'] = $this->error['invalid_product'];
		} else {
			$this->data['error_invalid_product'] = '';
		}

		if (isset($this->request->post['journal_filter_name'])) {
			$this->data['journal_filter_name'] = $this->request->post['journal_filter_name'];
		} elseif (!empty($journal_filter)) {
			$this->data['journal_filter_name'] = $journal_filter['name'];
		} else {
			$this->data['journal_filter_name'] = '';
		}

		if (isset($this->request->post['journal_filter'])) {
			$this->data['journal_filter'] = $this->request->post['journal_filter'];
		} elseif (!empty($journal_filter)) {
						
			$this->data['journal_filter'] = $journal_filter['filters'];
		} else {
			$this->data['journal_filter'] = array();
		}		

		foreach ($this->data['journal_filter'] as &$filter) {
			if (!isset($filter['products'])) {
				$filter['products'] = array();
			}
		
			foreach ($filter['products'] as $k => &$product) {
				$info = $this->model_catalog_product->getProduct($product);
				if ($info) {
					$product = array(
			 			'id' => $product,
			 			'name' => $info['name']
		 			);	
				} else {
					unset($filter['products'][$k]);
				}
			 	
			}
		}

		$this->template = 'module/journal_filter_form.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
	}

	private function validateForm() {
		if (!$this->user->hasPermission('modify', 'module/journal_filter')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}

		if (!isset($this->request->post['journal_filter_name']) || utf8_strlen($this->request->post['journal_filter_name']) === 0) {
			$this->error['name'] = $this->language->get('error_name');
		}

		if (!$this->error) {
			return true;
		} else {
			return false;
		}	
	}

	private function validateSettings() {
		
		return true;
	}

}
?>