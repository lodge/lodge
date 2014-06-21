class StocksController < ApplicationController
  before_action :set_stock, only: [:destroy]

  def index
    @stocks = Stock.all
  end

  # POST /stocks
  # POST /stocks.json
  def create
    @stock = Stock.new(stock_params.merge :user_id => current_user.id)
    respond_to do |format|
      if @stock.save
        format.html { redirect_to :back, notice: 'Stock was successfully created.' }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { redirect_to :back, alert: 'Already stocked.' }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Stock was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_stock
    @stock = Stock.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def stock_params
    params.permit(:user_id, :article_id)
  end
end
