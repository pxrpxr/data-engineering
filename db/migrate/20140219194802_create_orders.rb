class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :purchase_count
      t.references :user, index: true
      t.references :merchant, index: true
      t.references :product, index: true

      t.timestamps
    end
  end
end
