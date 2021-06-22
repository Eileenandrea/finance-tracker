class UsersController < ApplicationController
  def my_portfolio
      @tracked_stocks = current_user.stocks
      @user_stocks = current_user.user_stocks
  end
  def transactions
    if current_user.buyer?
      @transactions = current_user.buyer_transactionrecords
    elsif current_user.broker?
      @transactions = current_user.broker_transactionrecords
    else current_user.admin?
      @transactions = Transactionrecord.all  
    end
  end
end
