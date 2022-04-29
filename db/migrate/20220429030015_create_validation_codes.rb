class CreateValidationCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :validation_codes do |t|
      t.string :email
      # 整数类型  默认值1， 不能为空
      t.integer :kind, default: 1, null: false
      t.string :code, limit: 100
      t.datetime :used_at

      t.timestamps
    end
  end
end
