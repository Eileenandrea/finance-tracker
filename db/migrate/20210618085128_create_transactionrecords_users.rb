class CreateTransactionrecordsUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :transactionrecords_users do |t|
      t.references :transactionrecord, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
