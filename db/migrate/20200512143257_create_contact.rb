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
