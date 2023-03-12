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

# configuraciòn de idioma para la aplicacón config/application.rb
de esto: 
```ruby 
# config/application.rb
require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Vende
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
```
a esto: 
```ruby 
require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Vende
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.i18n.available_locales = [:en, :es]
    config.i18n.default_locale = :es
  end
end
```
y en la carpeta config/locales creamos un nuevo archivo para el idioma españo es.yml y por dentro agregamos lo siguiente:
en el html:
```erb
  <h1><%= t('.title') %></h1>

```

en el archivo config/locales/es.yml: 
```yml
es:
  products:
    new:
      title: 'Agregar Nuevo Producto'
    edit:
      title: 'Editar Producto'
```

## en caso de los turbos 
en el html:
```html
<%= link_to "eliminar", product_path(@product), data: {turbo_method: :delete, turbo_confirm: t('common.confirm')}%>

```
y en el archivo config/locales/es.yml deberia quedar así agregando
```yml
es:
  common:
    confirm: '¿Esta seguro de eliminar?'
  products:
    new:
      title: 'Agregar Nuevo Producto'
    edit:
      title: 'Editar Producto'
```

# traduciendo desde los controladores 
de esto: 
```ruby
def create
    if product.save
      redirect_to products_path, notice: 'tu producto se a creado correctamente'
    else 
      render :new,  status: :unprocessable_entity   
    end
    
  end
```

a esto: 
```ruby
def create
    if product.save
      redirect_to products_path, notice: t('.created')
    else 
      render :new,  status: :unprocessable_entity   
    end
    
  end
```

# Usando scaffold para hacer con una linea de comando casi todo lo que se hizo anteriormente
```bash
rails g scaffold Category name:string
```
luego hacer la migración
```bash
rails db:migrate
```

# relacionando products con category 

```bash
rails generate migration AddCategoryToProducts category:references
```
aplicamos los cambios 
```bash
rails db:migrate
```
como he creado anteriormente datos nullos y ahora en la relacion le estoy diciendo que no tiene que estar null, entonces tengo que resetear los datos anteriores
```bash
rails db:reset
```
y nuevamente ahora si migramos
```bash
rails db:migrate
```
# relacionando desde le modelo de products y catergory
en product.rb
```ruby
# en apps/models/product.rb
  belongs_to :category
```
y en category.rb
```ruby
# en apps/models/category.rb
  has_many :products
```

# rellenando datos desde la fixtures
para categories
```ruby 
# test/fixtures/categories.rb

videogames:
  name: Videojuegos

computers:
  name: Informatica

clothes:
  name: Ropa

```
para product
```ruby
# test/fixtures/product.rb
ps4:
  title: ps4 Fast
  description: Ps4 en buen estado
  price: 150
  category: videogames

switch:
  title: Nintendo Switch
  description: le falta el lector de tarjeta sd
  price: 195
  category: videogames

air:
  title: Macbook Air
  description: Le falla la batería
  price: 250
  category: computers
```
Ahora corremos desde la terminal
```bash 
rails db:fixtures:load
```

# para agregar un select desde html para seleccionar una categoria 
```ruby
# apps/views/products/_form.html.erb
<div>
    <%= form.label :category_id %>
    <%= form.collection_select :category_id, Category.all.order(name: :asc), :id, :name %>
  </div>

```

# si quieres que las consultas se cargen en paralelo
agregar .load_async
```ruby
@categories = Category.all.order(name: :asc).load_async
@products = Product.all.with_attached_photo.order(created_at: :desc).load_async
```
y desde application.rb agregar 
```ruby 
# config/application.rb
 # allow multiquery - ejecutar query al mismo tiempo
    config.active_record.async_query_executor = :global_thread_pool
```

# 28. agregando gema para hacer consulta de producto
link de documentación: https://github.com/Casecommons/pg_search

```bash 
bundle  add pg_search
```
o desde el mismo documento Gemfile
```Gemfile
gem pg_search
```
y agregamos lo siguiente al model
```ruby
# apps/model/product.rb
include PgSearch::Model
  pg_search_scope :search_full_text, against: {
    #para saber el orden de prioridad de arriba hacia abajo
    title: 'A',
    description: 'B'
  }
```
Haciendo pruebas desde la consola de rails
```bash
rails c
```
```bash
Product.search_full_text('texto a buscar')
```

# para hacer un select form son ruby on rails 
## options_for_select 
visitar la pagina de documentación
https://apidock.com/rails/v5.2.3/ActionView/Helpers/FormOptionsHelper/options_for_select

para reemplazar html con rails

https://apidock.com/rails/ActionView/Helpers/FormOptionsHelper/select


# 29. pagina infinita con hotwire

cargar datos desde la fixtures en categories y products, recuerda agregar primero lo datos para correrlo desde la terminal
```bash
rails db:fixtures:load
```
agregar gema para la paginaación 
```bash
bundle add pagy
```
desde application_controller.rb agregamos al inicio

```rb
  include Pagy::Backend
```
y para iniciar con las vistas tambien agregamos en applicationo_helper.rb
```rb
  include Pagy::Frontend
```
ahora creamos un nuevo archivo en config/initializers/pagy.rb
```rb
require 'pagy/extras/countless'
```
y en products_controller dentro del index pero al final
```rb
@pagy, @products = pagy_countless(products, items: 12)
```

y desde views/products/index.html modificar la paginación

```rb
<%= link_to t('.all'), products_path %>
  <%= render partial: 'category', collection: @categories %>
  <%= turbo_frame_tag "products-#{@pagy.page}", class: 'products' do %>
    <%= render partial: 'product', collection: @products %>
    <%= turbo_frame_tag "products-#{@pagy.next}", class: 'products', src: pagy_url_for(@pagy, @pagy.next), loading: :lazy if @pagy.next %>
  <% end %>
<% end %>
```

# 30 haciendo refactorización 
creamos una nueva carpeta y archivo app/queries/find_products.rb
y por dentro refactorizamos el controller de products pero especificamente el metodo index

```rb
#app/queries/find_products.rb
class FindProducts
  attr_reader :products

  def initialize(products = initial_scope)
    @products = products
  end

  def call(params = {})
    scoped = products
    scoped = filter_by_category_id(scoped, params[:category_id])
    scoped = filter_by_min_price(scoped, params[:min_price])
    scoped = filter_by_max_price(scoped, params[:max_price])
    scoped = filter_by_query_text(scoped, params[:query_text])
    sort(scoped, params[:order_by])
  end

  private

  def initial_scope
    Product.with_attached_photo
  end

  def filter_by_category_id(scoped, category_id)
    return scoped unless category_id.present?

    scoped.where(category_id: category_id)
  end

  def filter_by_min_price(scoped, min_price)
    return scoped unless min_price.present?

    scoped.where("price >= ?", min_price)
  end

  def filter_by_max_price(scoped, max_price)
    return scoped unless max_price.present?

    scoped.where("price <= ?", max_price)
  end

  def filter_by_query_text(scoped, query_text)
    return scoped unless query_text.present?

    scoped.search_full_text(query_text)
  end

  def sort(scoped, order_by)
    order_by_query = Product::ORDER_BY.fetch(order_by&.to_sym, Product::ORDER_BY[:newest])
    scoped.order(order_by_query)
  end
end
```
y ahora el controller deberia quedar así 
```rb
def index
    @categories = Category.order(name: :asc).load_async
    @pagy, @products = pagy_countless(FindProducts.new.call(params).load_async, items: 12)
    
  end 
```
# 31 actualizando y mejorando el codigo 
vamos actualizar nuestro modelo de category
```rb
#agregar en app/model/category
validates :name, presence: true
```
hacer una actualización de la base de datos
```bash
rails g migration AddNotNullToCategoryName
```
y en el nuevo archivo que se crea agregar lo sigueinte
```rb
#migrations/
change_column_null :categories, :name, false
```


# 32 registro de usuarios 
no se va usar devise, por tanto vamos a crear un modelo
recuerda que el email y username deben ser unicos 
```bash
rails g model User email:string:uniq username:string:uniq password_digest:string 
```
y desde el archivo de migración que se genero tratar de comparar con este codigo
```rb
 def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :username, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
  end
```
por convención se a utilizado password_digest por la documentación de rails 
https://api.rubyonrails.org/v7.0.4/classes/ActiveModel/SecurePassword/ClassMethods.html 

creamos la migración ahora 
```bash
rails db:migrate
```

# 33 Login de usuario 

# 34 Protegiendo nuestra pagina 

# 35 asignando productos a usuarios
vamos hacer migración 
```bash 
rails g migration addUserToProduct user:references
```
y ahora nos vamos a la migración que genero 
```rb

```
y en caso salga error 

```bash
rail db:reset
```
y ahora arreglar el prellenado de datos
y para volver a cargar las fixtures 
```bash
rails db:fixtures:load 
```

primera forma para crear productos asignado al usuario que lo crea, desde products_controller.rb y dentro del metodo create
```rb
  
    @product = Current.user.products.new(product_params)
```
segunda forma desde el modelo product agregamos lo siguiente
```rb 
belongs_to :user, default: -> {Current.user}
```
# 36 mejorando nuestra app




































