require 'test_helper'
class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'render a list of products' do
    get products_path
    assert_response :success
    assert_select '.product', 2
    
  end

  test 'render a detailed product page' do
    get product_path(products(:laptop))
    assert_response :success
    assert_select '.title', 'Nombre: laptops'
  end

  test 'render a new product form' do
    get new_product_path
    assert_response :success
    assert_select 'form'
  end

  test 'allow to create a new product' do
    post product_path, params: {
      product:{
        title: 'cargador',
        description: 'carga rapida',
        price: 20
      }
    }
    assert_redirected_to products_path
    
  end

  test 'does not allow to create a new product with emty fields' do
    post product_path, params: {
      product:{
        title: '',
        description: 'carga rapida',
        price: 20
      }
    }
    assert_response :unprocessable_entity
  end
end