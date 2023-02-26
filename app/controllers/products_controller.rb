class ProductsController < ApplicationController
  def index
    # para mostrar todo los productos
    @products = Product.all
  end
  
  def show
    # para buscar por id
    @product = Product.find(params[:id])
    # esto es lo mismo a hacer desde sql esto
    # SELECT "products".* FROM "products" WHERE "products"."id" = $1 LIMIT $2  [["id", 3], ["LIMIT", 1]]
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: 'tu producto se a creado correctamente'
    else 
      render :new,  status: :unprocessable_entity   
    end
    
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to products_path, notice: "Producto actualizado correctamente" 
    else
      render :edit, status: :unprocessable_entity
    end
    
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path, notice: "se elimino correctamente el producto", status: :see_other
  end
  
  
  

  private 
  def product_params
    params.require(:product).permit(:title, :description, :price, :photo)
    
  end
end