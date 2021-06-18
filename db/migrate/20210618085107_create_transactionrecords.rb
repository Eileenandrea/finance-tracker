class CreateTransactionrecords < ActiveRecord::Migration[6.1]
  def change
    create_table :transactionrecords do |t|
      t.references :stock, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :stock_price
      t.decimal :total_price
      t.timestamps
    end
  end
end
