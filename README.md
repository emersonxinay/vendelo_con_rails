# Proyecto vende

## versiones de ruby y rails 
ruby 3.2.1
rails 7.0.2.4

## creando el proyecto con rails y usando postgresql 
```bash 
rails new nombre_proyecto -d postgresql
```
## ingresamos a la carpeta que creamos y abrimod visual estudio code 
```bash 
cd nombre_proyecto
```
```bash 
code .
```
## creamos nuestra base de datos, en este caso es necesario ya que no estamos trabajando por defecto con el sql3 sino con postgresql
```bash 
rails db:create 
```

## corremos nuestro proyecto para ver que todo este okey
```bash 
rails server
```
o 
```bash 
rails s 
```

## creando rutas 
```ruby 
# ./config/routes.rb
Rails.application.routes.draw do
  
  root "products#index"
  get '/products', to: 'products#index'
end
```
## entendiendo MVC 
```code 
MODELO: esta relacionado con la base de datos, y aqui haces consultas,validaciones, relaciones
VISTA: mostrar en html, pdf, csv, json 
CONTROLADOR: La logica 
```

## creando Controladores -creamos un archivo products_controllers.rb
```ruby
# ./app/controllers/products_controller.rb
# creamos nuestra clase con el mismo nombre del archivo y tenemos que eredar de applicationController
class ProductsControllers < ApplicationController

end
```
## creando la Vista - creamos una carpeta y por dentro archivo app/views/products/index.html.erb
```html
<!-- la extención .erb se usa para que se utilize también codigo ruby dentro del html -->
<h1>Productos: <%= Date.today%> </h1>
```

## creando el Modelo 
```text
Recordar la convención de ruby: los modelos son en singulos y los controllers en plural
```
```bash 
rails generate model Product title:string description:text price:integer
```
### al crear el modelo se genera una migración de datos, por tanto migramos
```bash
rails db:migrate
```
### para verificar si se creo correctamente verificamos desde la consola de rails 
```bash 
rails console 
```
### y desde consola creamos un nuevo producto, recuerda que tiene que ver tal cual creaste tu modelo
```bash 
Product.create(title: "Laptop", description: "Laptops de ultimo modelo", price: 200)
```
### y desde la consola deberia crearse los datos que se ingreso y ahora para consultarlo es:
```bash 
Product.all
```

### sin el active record se hubise hecho esto con sql: 
```sql
INSERT INTO "products" ("title", "description", "price", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5) RETURNING "id"  [["title", "Tablets"], ["description", "Tablets de ultimo modelos"], ["price", 300], ["created_at", "2023-02-25 22:40:01.715569"], ["updated_at", "2023-02-25 22:40:01.715569"]]
```

## mostrar los datos de la base de datos en el html
### primero nos vamos al controller para hacer la logica 
```ruby 
# app/controllers/products_controller.rb
# dentro del metodo 
def index
  @products = Product.all
end
```
### ahora nos vamos a la vista para mostrar
```ruby
# app/views/products/index.html.erb 
<% @products.each do |products| %>
  <h2> <%= products.title%> </h2>
  <p> <%= products.price%> </p>

<%end%>
```


## ahora modificamos agregando una nueva ruta para el detalle de cada producto 
## nos vamos a routes.rb

```ruby 
# app/config/routes.rb
Rails.application.routes.draw do
  # ruta inicio por defecto 
  root "products#index"
  # ruta para ver todos los productos
  get '/products', to: 'products#index'
  # ruta para ir al id de cada producto
  get '/products/:id', to: 'products#show', as: :product 
  
end

```

### recordar que las rutas que se puso en routes te genera mas rutas pero estan ocultas, para mostrarlo desde el navegador :
```text
https://localhost:3000/rails/info/routes
```
o
```text
https://127.0.0.1:3000/rails/info/routes
```

# ahora creamos para la vista show, incluir un metodo en el controller
```ruby
# app/controllers/products_controller.rb
def show
    # para buscar por id
    @product = Product.find(params[:id])
    # esto es lo mismo a hacer desde sql esto
    # SELECT "products".* FROM "products" WHERE "products"."id" = $1 LIMIT $2  [["id", 3], ["LIMIT", 1]]
end
```
## creamos el archivo en la carpeta show.html.erb
```ruby
<h1>Detalle de Productos:</h1>
<h2> <%= @product.title %> </h2>
<p> <%= @product.description%> </p>
<span> <%= @product.price %> </span>

```

# creanod partials
```text
apps/views/layouts/partials/_navbar.erb
```
## crea una nueva carpeta donde crearas todos los archivos que necesites mostrar en todos lados desde el layouts 
```html
<body>
    # apunta al partial que creaste
    <%= render  'partials/navbar' %>
    <%= yield %>
  </body>
```


# creando test, nos vamos a la carpete test
```text
Creamos uno del mismo nombre de nuestro controller agregando la palabra test
test/controllers/products_controller_test.rb
```
```ruby
# test/controllers/products_controller_test.rb
# y  ahora hacemos lo siguiente: 
# requiere hace incluir todo  lo que tenga test_helper
require 'test_helper'
class ProductsControllerTest < ActionDispatch::IntegrationTest
  # esto renderiza toda la lista del producto
  test 'render a list of products' do
    get products_path
    assert_response :success
    assert_select '.product', 2
  end
  # esto renderiza todo el detalle de product
  test 'render a detailed product page' do
    
  end
end
```

```text
recordar que todo el test depende del test_helper
test/test_helper.rb
```

# para crear prueba test mas detallado irse a fixtures
```text
test/fixtures/products.yml
```
```yml
# test/fixtures/products.yml
# Aqui se pone todos los datos que quieres que se pruebe

tablet:
  title: tablets
  description: las mejores tablets
  price: 100

laptop:
  title: laptos
  description: las mejores laptops
  price: 200
```

## para ejecutar el test 
```bash
rails test 
```

## validaciones se hace en el model 
```ruby 
# apps/models/product.rb
class Product < ApplicationRecord
  validates :title, presence :true
  validates :description, presence :true
  validates :price, presence :true

end
```
### para manejar sus errores desde el formulario 
```ruby
# apps/views/products/new.html.erb
<% @product.errors.full_messages.each do |error|%>
    <%= error%>
  <%end%>
```
### corregir el redirecnto desde el controller
```ruby
# apps/controllers/products_controller.rb
def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path 
    else 
      render :new,  status: :unprocessable_entity   
    end
    
  end
```

# Validación para la base  de datos 
```bash 
rails generate migration addNullFalseToProductFields
```
### luego revisar el codigo de la migracion que se genero antes de hacer la migracion y dentro del archivo agregar lo siguiente
```ruby
# db/migrate/xxxxxxxx
# esto nos asegura que desde la base de datos no se permite datos vacios para almacenar
def change
    change_column_null :products, :title, false 
    change_column_null :products, :description, false 
    change_column_null :products, :price, false 

  end
```
### ahora si hacer la migración para asegurar nuestra base de datos
```bash
rails db:migrate 
```
## test para probar 
```ruby
# test para saber que no debe ingresar datos vacios desde el formulario 
test 'does not allow to create a new product with emty fields' do
    post products_path, params: {
      product:{
        title: '',
        description: 'carga rapida',
        price: 20
      }
    }
    # esto es para que me de un error 402 
    assert_response :unprocessable_entity
  end
```

# Notificaciones de Alerta

### lo hare primero desde mi controller 
```ruby
def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: 'tu producto se a creado correctamente'
    else 
      render :new,  status: :unprocessable_entity  
    end
    
  end
```

## agregar desde layouts/application.html.erb 
```ruby
    <%= notice %>
    <%= alert %>
    <%= yield %>

```

# para editar un producto 
## desde el controller creamos un metodo 

```ruby 

```

# para subir imagenes 
```bash 
rails active_storage:install
```
```bash
rails db:migrate
```

# refactorizando codigo
de esto 
```ruby 

# apps/config/routes.rb
# ruta inicio por defecto 
  
  root "products#index"
  delete 'products/:id', to: 'products#destroy'
  patch 'products/:id', to: 'products#update'
  post 'products', to: 'products#create'
  get 'products/new', to: 'products#new', as: :new_product
  # ruta para ver todos los productos
  get '/products', to: 'products#index'
  # ruta para ir al id de cada producto
  get '/products/:id', to: 'products#show', as: :product 
  get '/products/:id/edit', to: 'products#edit', as: :edit_product 
```
a esto: 
```ruby
  # el path: '/' es como agregar el root "products#index"
  resources :products, path: '/'
```

## refactorizando el controller 
de esto:
```ruby
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
```

a esto: 
```ruby
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
```

# no hacer consultas repetidas con respecto a imagenes 
modificamos nuestro controller de esto que hace mas de dos consultas: 
```ruby
def index
    # para mostrar todo los productos
    @products = Product.all
end
```
a esto que lo reduce: 
```ruby
def index
    # para mostrar todo los productos
    @products = Product.all.with_attached_photo
end
```

# refactorizar archivos html
de esto: 
```html
<!-- la extención .erb se usa para que se utilize también codigo ruby dentro del html -->
<h1>Productos: <%= Date.today%> </h1>

  <% @products.each do |product| %>

  <%= link_to product_path(product.id), class: "product" do %>
  <%= image_tag product.photo, width: 100 if product.photo.attached? %>
  <h2 > <%= product.title%> </h2>
  <h2 > <%= product.description%> </h2>
  <p > <%= product.price%> </p>
  <%end%>

<%end%>
```
a esto:
```html 
<!-- la extención .erb se usa para que se utilize también codigo ruby dentro del html -->
<h1>Productos: <%= Date.today%> </h1>

<%= render partial: 'product', collection: @products %>
```




























