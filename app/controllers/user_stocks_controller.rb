class UserStocksController < ApplicationController
  def order
    stock_query
    @params = order_params
    @total_price = @params[:quantity].to_i * @params[:price].to_d
    if current_user.stock_already_tracked?(params[:user_stocks][:ticker])
      @user_stock = current_user.user_stocks.where(stock_id: @stock.id).first
      if @params[:transactiontype] == 'sell' && @params[:quantity].to_i == @user_stock.total_shares.to_i
        destroy
      else
        update
      end
    else
      if @params[:transactiontype] == 'buy'
        create
      else
        flash[:alert] = "Unsuccessfull Transaction.#{@stock.name} was not found on Your Portfolio"
        redirect_to 'new'
      end
    end 
  end
  
  def create
    if current_user.buyer?
        @user_stock = UserStock.new(user: current_user, stock: @stock, average_price: @params[:price], total_shares: @params[:quantity])
        if @user_stock.save
          save_transaction
          flash[:notice] = 'Successfull Transaction'
          redirect_to my_portfolio_path
        else
          render 'new'
        end 
    else #broker_stocks creation
      stock_query
      @user_stock = UserStock.create(user: current_user, stock: @stock)
      flash[:notice] = "Stock #{@stock.name} was successfully added to your portfolio"
      redirect_to my_portfolio_path
    end
  end
  def update
    if @params[:transactiontype] == 'buy'
      total_shares = @user_stock.total_shares + @params[:quantity].to_d
      total_equity =((@user_stock.average_price *  @user_stock.total_shares) + @total_price)
      average_price =  total_equity / total_shares
    elsif @params[:transactiontype] == 'sell'
      total_shares = @user_stock.total_shares - @params[:quantity].to_d
      average_price = @user_stock.average_price
    end
    if(@user_stock.update(average_price: average_price, total_shares: total_shares))
      save_transaction
      flash[:notice] = 'Successfull Transaction'
      redirect_to my_portfolio_path
    else
      flash[:alert] = 'An error is encounter while procesing your order please try again'
      render 'new'
    end
  end
  def destroy
    if @user_stock
      @user_stock.destroy
      save_transaction
      flash[:notice] = "Successfull Transaction"
      redirect_to my_portfolio_path
    else
      @stock = Stock.find(params[:id])
      user_stock = UserStock.where(user_id: current_user.id, stock_id: @stock.id).first
      user_stock.destroy
      flash[:notice] = "#{@stock.ticker} was successfully remove from the portfolio"
      redirect_to my_portfolio_path
    end
  end
  def new
    @broker = User.find_by_id(params[:broker])
    @user_stock = UserStock.new
    @stock = Stock.check_db(params[:ticker])
    @type = params[:transactiontype]
    byebug
  end
  def user_stocks_params
    params.require[:user_stocks].permit(:user_id,:stock_id,:average_price,:total_shares)
  end
  def save_transaction
    transaction = Transactionrecord.new(stock_price:@params[:price], quantity: @params[:quantity], total_price: @total_price, stock: @stock, buyer_id: current_user.id, broker_id: @params[:broker_id], transactiontype: @params[:transactiontype])
    transaction.save
  end
  def order_params
    oder_params = { :quantity => params[:user_stocks][:quantity],
    :price =>  params[:user_stocks][:stock_price],
    :broker_id => params[:user_stocks][:broker_id],
    :transactiontype => params[:user_stocks][:type] }
  end
  def stock_query
    @stock = Stock.check_db(params[:user_stocks][:ticker])
    if @stock.blank?
      @stock = Stock.new_lookup(params[:ticker])
      @stock.save
    end
  end
end
