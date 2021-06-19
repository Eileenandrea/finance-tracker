class AddFieldsToUserStocks < ActiveRecord::Migration[6.1]
  def change
    add_column :user_stocks, :average_price, :decimal
    add_column :user_stocks, :total_shares, :integer
  end
end
