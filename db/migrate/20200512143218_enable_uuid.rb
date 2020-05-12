class EnableUuid < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')
  end
end
