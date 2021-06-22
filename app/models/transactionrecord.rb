class Transactionrecord < ApplicationRecord
    enum transactiontype: [:buy, :sell, :add, :remove]
    belongs_to :broker, class_name: 'User'
    belongs_to :buyer, class_name: 'User'
    belongs_to :stock

end
