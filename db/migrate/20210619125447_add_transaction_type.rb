class AddTransactionType < ActiveRecord::Migration[6.1]
  def change
    add_column :transactionrecords, :type, :integer
  end
end
