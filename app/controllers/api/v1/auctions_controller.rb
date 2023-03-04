class Api::V1::AuctionsController < ApplicationController
  before_action :set_auction, only: %i[show update destroy bids]

  # GET api/v1/auctions
  # GET api/v1//auctions.json
  def index
    @auctions = Auction.all
  end

  # GET api/v1/auctions/1
  # GET api/v1/auctions/1.json
  def show; end

  # POST api/v1/auctions
  # POST v/auctions.json
  def create
    @auction = Auction.new(auction_params)

    if @auction.save
      render :show, status: :created
    else
      render json: @auction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT api/v1/auctions/1
  # PATCH/PUT api/v1/auctions/1.json
  def update
    if @auction.update(auction_params)
      render :show, status: :ok, location: @auction
    else
      render json: @auction.errors, status: :unprocessable_entity
    end
  end

  # DELETE api/v1/auctions/1
  # DELETE api/v1/auctions/1.json
  def destroy
    @auction.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_auction
    @auction = Auction.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def auction_params
    params.require(:auction).permit(:art_id, :minimal_bid, :status, :start_date, :end_date)
  end
end
