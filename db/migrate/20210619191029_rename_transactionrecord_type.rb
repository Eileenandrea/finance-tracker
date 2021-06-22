class RenameTransactionrecordType < ActiveRecord::Migration[6.1]
  def change
    rename_column :transactionrecords, :type, :transactiontype
  end
end
