class StocksController < ApplicationController
    def search
        if params[:stock].present?
            @stock = Stock.new_lookup(params[:stock])
            
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
  