class AddCodeToValidationCode < ActiveRecord::Migration[7.0]
  def change
    add_column :validation_codes, :code, :string, limit: 100
  end
end
