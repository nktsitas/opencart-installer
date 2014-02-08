<?php
class ControllerModuleJournalCp extends Controller {

	private function extend_css($css, $preety_print = true) {
		$this->document->journal_css = '';
		foreach ($css as $selector) {
			$this->document->journal_css .= "{$selector['selector']} {" . ($preety_print ? "\n" : "");
			foreach ($selector['rules'] as $rule) {
				$rule = str_replace('url()', 'none', $rule);
				$this->document->journal_css .= ($preety_print ? "\t" : "") . $rule . ($preety_print ? "\n" : "");
			}
			$this->document->journal_css .= "} " . ($preety_print ? "\n" : "");
		}
	}

	private function extend_vars($vars) {
		foreach ($vars as $key => $value) {
			$this->document->{$key} = $value;
		}
	}

	private function extend_payment_images() {
		if (!isset($this->document->journal_payment_images)) return;

		$images = (array)json_decode($this->document->journal_payment_images);

		if (!is_array($images)) {
			unset($this->document->journal_payment_images);
			return;
		}

		$data = array();

		$lang_id = (int)$this->config->get('config_language_id');

		foreach ($images as $k => $v) {
			$v = (array)$v;

			if (!$v['img'] || !file_exists(DIR_IMAGE . $v['img'])) continue;

			$v['name'] = get_object_vars($v['name']);

			$data[] = array(
				'img'			=> 'image/' . $v['img'],
				'href'			=> $v['link'],
				'new_window'	=> $v['new_window'],
				'name'			=> isset($v['name'][$lang_id]) ? $v['name'][$lang_id] : 'Not trans',
				'sort_order'	=> $v['sort_order']
			);
		}

		$this->sort($data);

		$this->document->journal_payment_images = $data;
	}

	private function extend_contact_methods() {

		if (!isset($this->document->journal_contact_methods)) return;

		$contact_methods = (array)json_decode($this->document->journal_contact_methods);

		if (!is_array($contact_methods)) {
			unset($this->document->journal_contact_methods);
			return;
		}

		$data = array();

		$lang_id = (int)$this->config->get('config_language_id');

		foreach ($contact_methods as $k => $v) {
			$v = (array)$v;

			$href = $v['link'];

			if (strlen($href) > 0 && strpos($href, 'http') !== 0) {
				$href = $this->url->link($v['link']);
			}

			$v['name'] = get_object_vars($v['name']);

			$data[] = array(
				'img'			=> $this->model_tool_image->resize($v['img'], 20, 20),
				'href'			=> $href,
				'new_window'	=> $v['new_window'],
				'name'			=> isset($v['name'][$lang_id]) ? $v['name'][$lang_id] : 'Not trans',
				'sort_order'	=> $v['sort_order']
			);
		}

		$this->sort($data);

		$this->document->journal_contact_methods = $data;
	}

	private function extend_top_menu() {
		if (!isset($this->document->journal_top_menu)) return;

		$top_menu = (array)json_decode($this->document->journal_top_menu);

		if (!is_array($top_menu)) {
			unset($this->document->journal_top_menu);
			return;
		}

		$data = array();

		$lang_id = (int)$this->config->get('config_language_id');

		foreach ($top_menu as $k => $v) {
			$v = (array)$v;

			$href = $v['link'];

			if (strlen($href) > 0 && strpos($href, 'http') !== 0) {
				$href = $this->url->link($v['link']);
			}

			$v['name'] = get_object_vars($v['name']);

			$data[] = array(
				'img'			=> $this->model_tool_image->resize($v['img'], 20, 20),
				'href'			=> $href,
				'new_window'	=> $v['new_window'],
				'name'			=> isset($v['name'][$lang_id]) ? $v['name'][$lang_id] : 'Not trans',
				'sort_order'	=> $v['sort_order']
			);
		}

		$this->sort($data);

		$this->document->journal_top_menu = $data;
	}

	private function extend_categories_menu() {
		if (!isset($this->document->journal_categories_menu)) return;

		$categories_menu = (array)json_decode($this->document->journal_categories_menu);

		if (!is_array($categories_menu)) {
			unset($this->document->journal_categories_menu);
			return;
		}

		$data = array();

		$lang_id = (int)$this->config->get('config_language_id');

		foreach ($categories_menu as $k => $v) {
			$v = (array)$v;

			$href = $v['link'];

			if (strlen($href) > 0 && strpos($href, 'http') !== 0) {
				$href = $this->url->link($v['link']);
			}

			$v['name'] = get_object_vars($v['name']);

			$data_subcategs = array();

			if (isset($v['subcategs'])) {
				foreach ($v['subcategs'] as $sk => $sv) {
					$sv = (array)$sv;

					$shref = $sv['link'];

					if (strlen($shref) > 0 && strpos($shref, 'http') !== 0) {
						$shref = $this->url->link($sv['link']);
					}

					$sv['name'] = get_object_vars($sv['name']);


					$data_subcategs[] = array(
						'href'			=> $shref,
						'new_window'	=> $sv['new_window'],
						'name'			=> isset($sv['name'][$lang_id]) ? $sv['name'][$lang_id] : 'Not trans',
						'sort_order'	=> $sv['sort_order']
					);
				}

				$this->sort($data_subcategs);
			}

			$data[] = array(
				'href'			=> $href,
				'new_window'	=> $v['new_window'],
				'name'			=> isset($v['name'][$lang_id]) ? $v['name'][$lang_id] : 'Not trans',
				'sort_order'	=> $v['sort_order'],
				'subcategs'		=> $data_subcategs
			);
		}

		$this->sort($data);

		$this->document->journal_categories_menu = $data;
	}

	private function sort(&$array, $desc = FALSE) {
		$tmp_array = array();

		foreach ($array as $k => $v) {
			if ($v['sort_order']) {
				$tmp_array[] = $v;
			}
		}

		usort($tmp_array, array("ControllerModuleJournalCp", $desc ? 'sort_desc' : 'sort_asc'));

		foreach ($array as $k => $v) {
			if (!$v['sort_order']) {
				$tmp_array[] = $v;
			}
		}

		$array = $tmp_array;
	}

	private static function sort_asc($a, $b) {
		$a = (int)$a['sort_order'];
		$b = (int)$b['sort_order'];
		return $a - $b;
	}

	private static function sort_desc($a, $b) {
		$a = (int)$a['sort_order'];
		$b = (int)$b['sort_order'];
		return $b - $a;
	}

	private function is_installed() {
		$is_installed = $this->model_journal_cp->is_installed();
		if (!$is_installed) {
			echo 'Journal modules are not enabled!';
		} else {
			$this->document->journal_install = true;
		}
		return $is_installed;
	}


	public function index() {
		$this->load->model('journal/cp');
		$this->load->model('tool/image');
		$this->load->model('catalog/product');

		/* check journal is installed */
		if (!$this->is_installed()) {
			die();
		}

		// echo "<pre>" . print_r($this->request->get, TRUE) . "</pre>";

		/* quick seo url fix */
		$temp_route = '';

		if (isset($this->request->get['_route_'])) {
			$parts = explode('/', $this->request->get['_route_']);

			foreach ($parts as $part) {
				$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "url_alias WHERE keyword = '" . $this->db->escape($part) . "'");

				if ($query->num_rows) {
					$url = explode('=', $query->row['query']);

					// if ($url[0] == 'product_id') {
					// 	$this->request->get['product_id'] = $url[1];
					// }

					if ($url[0] == 'category_id') {
						if (!isset($temp_path)) {
							$temp_path = $url[1];
						} else {
							$temp_path .= '_' . $url[1];
						}
					}

					// if ($url[0] == 'manufacturer_id') {
					// 	$this->request->get['manufacturer_id'] = $url[1];
					// }

					// if ($url[0] == 'information_id') {
					// 	$this->request->get['information_id'] = $url[1];
					// }
				} else {
					$temp_route = 'error/not_found';
				}
			}

			if (isset($this->request->get['product_id'])) {
				$temp_route = 'product/product';
			} elseif (isset($this->request->get['path'])) {
				$temp_route = 'product/category';
			} elseif (isset($this->request->get['manufacturer_id'])) {
				$temp_route = 'product/manufacturer/info';
			} elseif (isset($this->request->get['information_id'])) {
				$temp_route = 'information/information';
			}

			// if (isset($this->request->get['route'])) {
			// 	return $this->forward($this->request->get['route']);
			// }
		}

		// echo "<pre>" . print_r($temp_route, TRUE) . "</pre>";

		/* get subcateg pictures */
		$is_categ_route = isset($this->request->get['route']) && $this->request->get['route'] === 'product/category';
		$categ_path	= isset($this->request->get['path']) ? $this->request->get['path'] : false;
		if (isset($temp_path) && $temp_path) {
			$categ_path = $temp_path;
			$is_categ_route = true;
		}
		if ($is_categ_route && $categ_path) {
			$this->load->model('catalog/category');

			$parts = explode('_', (string)$categ_path);
			$category_id = (int)array_pop($parts);

			$categories = $this->model_catalog_category->getCategories($category_id);
			$data = array();

			$width = $this->config->get('config_image_additional_width');
			$height = $this->config->get('config_image_additional_height');

			foreach ($categories as $subcateg) {
				$filters = array(
					'filter_category_id'  => $subcateg['category_id'],
					'filter_sub_category' => true
				);

				$product_total = $this->model_catalog_product->getTotalProducts($filters);

				$data[] = array(
					'name'  => $subcateg['name'] . ($this->config->get('config_product_count') ? ' (' . $product_total . ')' : ''),
					'href'  => $this->rewrite($this->url->link('product/category', 'path=' . $categ_path . '_' . $subcateg['category_id'])),
					'thumb'	=> $this->model_tool_image->resize($subcateg['image'] ? $subcateg['image'] : 'no_image.jpg', $width, $height)
				);
			}

			$this->document->journal_image_subcategories = $data;
		}
		/* end get subcateg pictures */

		$active_theme = $this->model_journal_cp->getActiveTheme();
		$this->document->journal_active_theme = $active_theme['theme_id'];

		if (!$active_theme['status']) return;

		if (isset($this->session->data['theme'])) {
			$sess_theme_id = $this->model_journal_cp->getThemeId($this->session->data['theme']);
		}

		if (isset($sess_theme_id) && is_array($sess_theme_id)) {
			$active_theme = $sess_theme_id;
		}

		$settings = $this->model_journal_cp->getThemeSettings($active_theme['theme_id']);

		$vars = array();
		$css = array();

		foreach ($settings as &$setting) {
			if (is_array($setting['value'])) {
				$setting['value'] = (array)json_decode($setting['value']);
			} else {
				$setting['value'] = html_entity_decode($setting['value']);
			}

			if ($setting['type'] === 'css') {
				// apply all css properties
				$selector = $setting['css_selector'];
				$property = $setting['css_property'];
				$value = $setting['value'];

				switch ($setting['input']) {
					case 'font'		: $value = (array)json_decode($value); break;
					case 'upload'	: $value = is_file(DIR_IMAGE . $value) ? 'image/' . $value : null; break;
					case 'color'	: $value = $value ? '#' . $value : 'transparent'; break;
				}

				$css[md5($selector)]['selector'] = $selector;

				if (is_array($value)) {
					$rules = array();
					foreach ($value as $k => $v) {
						if ($k == 'font-size' || $k == 'line-height') $v .= 'px';
						if ($k == 'font-family') {
							$font_info = $this->model_journal_cp->getFontInfo($v);
							$v = $font_info['font_family'];
							if ($font_info['group'] == 'google') {
								$this->document->addStyle('//fonts.googleapis.com/css?family=' . $font_info['css_name'], 'stylesheet prefetch');
								$v = '"' . $v . '"';
							}
						}
						$css[md5($selector)]['rules'][] = "{$k}:{$v};";
					}
				} else {
					$css[md5($selector)]['rules'][] = strpos($property, '%s') === FALSE ? "{$property}:{$value};" : sprintf($property, $value) . ";";
				}
			} else {
				$value = $setting['value'] ? $setting['value'] : NULL;
				if ($value) {
					$vars['journal_' . $setting['name']] = $value;
				}
			}

		}
		$this->extend_css($css);
		$this->extend_vars($vars);
		$this->extend_payment_images();
		$this->extend_contact_methods();
		$this->extend_top_menu();
		$this->extend_categories_menu();

		$custom_css_file = $this->config->get('config_template') . '/stylesheet/' . $active_theme['theme_id'] . '_theme.css';
		$this->document->journal_custom_css_file = '<link rel="stylesheet" type="text/css" href="catalog/view/theme/' . $custom_css_file . '" />';
		if (!file_exists(DIR_TEMPLATE . $custom_css_file)) {
			unset($this->document->journal_custom_css_file);
		}

	}

	public function rewrite($link) {
		$url_info = parse_url(str_replace('&amp;', '&', $link));

		$url = '';

		$data = array();

		parse_str($url_info['query'], $data);

		foreach ($data as $key => $value) {
			if (isset($data['route'])) {
				if (($data['route'] == 'product/product' && $key == 'product_id') || (($data['route'] == 'product/manufacturer/info' || $data['route'] == 'product/product') && $key == 'manufacturer_id') || ($data['route'] == 'information/information' && $key == 'information_id')) {
					$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "url_alias WHERE `query` = '" . $this->db->escape($key . '=' . (int)$value) . "'");

					if ($query->num_rows) {
						$url .= '/' . $query->row['keyword'];

						unset($data[$key]);
					}
				} elseif ($key == 'path') {
					$categories = explode('_', $value);

					foreach ($categories as $category) {
						$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "url_alias WHERE `query` = 'category_id=" . (int)$category . "'");

						if ($query->num_rows) {
							$url .= '/' . $query->row['keyword'];
						}
					}

					unset($data[$key]);
				}
			}
		}

		if ($url) {
			unset($data['route']);

			$query = '';

			if ($data) {
				foreach ($data as $key => $value) {
					$query .= '&' . $key . '=' . $value;
				}

				if ($query) {
					$query = '?' . trim($query, '&');
				}
			}

			return $url_info['scheme'] . '://' . $url_info['host'] . (isset($url_info['port']) ? ':' . $url_info['port'] : '') . str_replace('/index.php', '', $url_info['path']) . $url . $query;
		} else {
			return $link;
		}
	}

}
?>