class StocksController < ApplicationController
    def index
    end
    
    def search
        if params[:stock].present?
            @stock = Stock.new_lookup(params[:stock])
            if current_user.buyer?
                stock = Stock.check_db(params[:stock])
                if !stock.blank?
                    @broker_list = stock.users.where(role: 'broker')
                    
                end
            end
            
            if @stock
                respond_to do |format|
                    format.js{ render partial: 'users/result'}
                end
            else
                respond_to do |format|
                    format.js{ render partial: 'users/result'}
                    flash.now[:alert] = "Please enter a valid symbol"
                end
            end
        else
            respond_to do |format|
                format.js{ render partial: 'users/result'}
                flash.now[:alert] = "Please enter a symbol"
            end
        end
    end
  end
  