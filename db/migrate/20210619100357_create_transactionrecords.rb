class CreateTransactionrecords < ActiveRecord::Migration[6.1]
  def change
    create_table :transactionrecords do |t|
      t.decimal :stock_price
      t.integer :quantity
      t.decimal :total_price
      t.references :stock, null: false, foreign_key: true
      t.references :broker, null: false,  foreign_key: { to_table: :users }
      t.references :buyer, null: false,  foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
