class UsersController < ApplicationController
  def my_portfolio
      @tracked_stocks = current_user.stocks
      @user_stocks = current_user.user_stocks
  end
end
