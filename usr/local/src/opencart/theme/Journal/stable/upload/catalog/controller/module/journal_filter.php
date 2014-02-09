<?php  
class ControllerModuleJournalFilter extends Controller {

	private function loadLanguageVars($vars = array()) {
		foreach ($vars as $var) {
			$this->data[$var] = $this->language->get($var);
		}
	}

	private static function mysort($a, $b) {
		$a = (int)$a['sort_order'];
		$b = (int)$b['sort_order'];
		return $a - $b;
	}

	protected function index($setting) {
		static $module = 0;

		$this->load->model('journal/journal_filter');
		$this->load->model('catalog/product');
		$this->load->model('tool/image');

		$filters = $this->model_journal_journal_filter->getFilter($setting['filter_id']);

		if (count($filters) == 0) {
			return;
		}

		$filters = unserialize($filters['filters']);

		$this->document->addScript('catalog/view/javascript/journal/jquery.isotope.min.js');

		$this->data['filters'] = array();
		$this->data['products'] = array();
		$this->data['default_filter'] = null;
		$this->data['scrolltop'] = $setting['scrolltop'];

		$lang_id = (int)$this->config->get('config_language_id');

		$new_filters = array();

		foreach ($filters as $filter) {
			if ($filter['sort_order']) {
				$new_filters[] = $filter;
			}
			
		}

		usort($new_filters, array("ControllerModuleJournalFilter", "mysort"));

		foreach ($filters as $filter) {
			if (!$filter['sort_order']) {
				$new_filters[] = $filter;
			}

		}

		$filters = $new_filters;

		foreach ($filters as $filter) {
			if (!$filter['status']) continue;

			$lid = isset($filter['filter'][$lang_id]) ? $lang_id : key($filter['filter']);
			
			$this->data['filters'][] = $filter['filter'][$lid];
			
			if (isset($filter['default']) && $filter['default']=='on') {
				$this->data['default_filter'] = $filter['filter'][$lid];
			}
			foreach ($filter['products'] as $prod_id) {
				$this->data['products'][$prod_id]['prod_id'] = $prod_id;
				$this->data['products'][$prod_id]['filters'][] = $filter['filter'][$lid];

				foreach ($this->data['products'][$prod_id]['filters'] as &$value) {
					$value = strtolower(preg_replace("/[^a-zA-Z0-9]/", "_", $value));
					// $value = strtolower(str_replace(' ', '_', $value));
				}

				$this->data['products'][$prod_id]['custom_filters'] = 'filter-' . implode(' filter-', $this->data['products'][$prod_id]['filters']);
			}

		}

		foreach ($this->data['products'] as $key => &$prod) {
			$result = $this->model_catalog_product->getProduct($key);
			
			if ($result['image']) {
				$image = $this->model_tool_image->resize($result['image'], $this->config->get('config_image_product_width'), $this->config->get('config_image_product_height'));
			} else {
				$image = false;
			}
			
			if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
				$price = $this->currency->format($this->tax->calculate($result['price'], $result['tax_class_id'], $this->config->get('config_tax')));
			} else {
				$price = false;
			}
			
			if ((float)$result['special']) {
				$special = $this->currency->format($this->tax->calculate($result['special'], $result['tax_class_id'], $this->config->get('config_tax')));
			} else {
				$special = false;
			}	
			
			if ($this->config->get('config_tax')) {
				$tax = $this->currency->format((float)$result['special'] ? $result['special'] : $result['price']);
			} else {
				$tax = false;
			}				
			
			if ($this->config->get('config_review_status')) {
				$rating = (int)$result['rating'];
			} else {
				$rating = false;
			}

			$prod['details'] = array(
					'product_id'  => $result['product_id'],
					'thumb'       => $image,
					'name'        => $result['name'],
					'description' => utf8_substr(strip_tags(html_entity_decode($result['description'], ENT_QUOTES, 'UTF-8')), 0, 100) . '..',
					'price'       => $price,
					'special'     => $special,
					'tax'         => $tax,
					'rating'      => $result['rating'],
					'reviews'     => sprintf($this->language->get('text_reviews'), (int)$result['reviews']),
					'href'        => $this->url->link('product/product', '&product_id=' . $result['product_id'])
				);
		}

		$this->loadLanguageVars(array(
			'button_wishlist',
			'button_compare',
			'button_cart',
			'text_tax'
		));

		$this->data['module'] = $module++;

		// die($this->data['default_filter']);

		$this->template = $this->config->get('config_template') . '/template/module/journal_filter.tpl';
		
		$this->render();
	}
}
?>