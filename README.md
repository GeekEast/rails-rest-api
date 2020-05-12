### Create Project
```sh
rails new rails-api -T --api --database=postgresql
```

### Config Postgres
- start up a postgres container
```sh
docker pull postgres
# single db
docker run --name testing-pg-db -e POSTGRES_PASSWORD=password -e POSTGRES_DB=ebdb -e POSTGRES_USER=postgres -d -p 5432:5432 postgres
# remove
docker stop testing-pg-db && docker rm testing-pg-db
```

## Table Schema and Model
```sh
rails g resource contact
```

### Migrate: create table
- enable `uuid` `rails g migration enable_uuid`
```ruby
class EnableUuid < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')
  end
end
```
- create 1st table: `rails g migration create_contact`
```ruby
# db/migrate/xxx_create_contacts.rb
class CreateContact < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
        t.string :first_name
        t.string :last_name
        t.string :email
  
        t.timestamps
    end
  end
end
```
- apply changes to database
```sh
rails db:migrate
```
- generate `structure.sql`
```sh
rake db:structure:dump
```

### Seed: initialize table
- generate some initial data to table
```ruby
Contact.create({
    first_name: "James",
    last_name: "Tan",
    email: "example@app.com"
})
```
- apply to database
```sh
rails db:seed
```

### Controller
> [HTTP Code in Rails](http://www.railsstatuscodes.com/)
- list items under `/items/`
```ruby
# !put under controllers/api/v1
module Api
    module V1
        class ContactsController < ApplicationController
            def index
                @contacts = Contact.all
                render json: @contacts, status: :ok
            end
        end
    end
end
```
- create item under `/items/`
- show item under `/item/`
- update item under `/item/`
- destroy item under `/item/`

### Route
- add `v1` namespace
```ruby
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :contacts
    end
  end
```
- to see all the routes
```sh
rails routes
```