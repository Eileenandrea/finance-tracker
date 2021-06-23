class User < ApplicationRecord
  enum role: [:broker, :buyer, :admin]
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :broker_transactionrecords, class_name: 'Transactionrecord', foreign_key: 'broker_id'
  has_many :buyer_transactionrecords, class_name: 'Transactionrecord', foreign_key: 'buyer_id'
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  after_create :sign_up_proccess
  before_create :approve_buyer
  def approve_buyer
    if self.buyer?
      self.approved = true
    end
  end

  def sign_up_proccess
    if self.buyer?
      WelcomeMailer.welcome_send(self).deliver
    else
      WelcomeMailer.welcome_send(self).deliver
      AdminMailer.new_user_waiting_for_approval(email).deliver
    end
  end
  
  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    return false unless stock
    stocks.where(id: stock.id).exists?
  end      
    

  def under_stock_limit?
    stocks.count < 10
  end
  
  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
    
  end
  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    "Anonymous"
  end
  def total_net_cost
    self.user_stocks.sum("total_shares * average_price")
  end
  
  def active_for_authentication? 
    super && approved? 
  end 
  
  def inactive_message 
    approved? ? super : :not_approved
  end
end
