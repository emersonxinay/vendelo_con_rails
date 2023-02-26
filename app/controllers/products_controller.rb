class ProductsController < ApplicationController
  def index
    # para mostrar todo los productos
    @products = Product.all
  end
  
  def show
    product
  end

  def new
    @product = Product.new
  end

  def create
    if product.save
      redirect_to products_path, notice: 'tu producto se a creado correctamente'
    else 
      render :new,  status: :unprocessable_entity   
    end
    
  end

  def edit
    product
  end

  def update
    if product.update(product_params)
      redirect_to products_path, notice: "Producto actualizado correctamente" 
    else
      render :edit, status: :unprocessable_entity
    end
    
  end

  def destroy
    product.destroy
    redirect_to products_path, notice: "se elimino correctamente el producto", status: :see_other
  end
  
  def product
    @product = Product.find(params[:id])
  end
  
  

  private 
  def product_params
    params.require(:product).permit(:title, :description, :price, :photo)
    
  end
end