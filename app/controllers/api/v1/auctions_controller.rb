class Api::V1::AuctionsController < ApplicationController
  before_action :set_auction, only: %i[show update destroy]
  before_action :authenticate_user!, only: %i[create update destroy]

  # GET api/v1/auctions
  def index
    @auctions = Auction.all
  end

  # GET api/v1/auctions/1
  def show; end

  # POST api/v1/auctions
  def create
    @auction = Auction.new(auction_params)
    @auction.user = current_user

    if assign_auction_start_date
      render :show, status: :created
      StartAuctionJob.set(wait_until: @auction.start_date).perform_later(@auction) if @auction.scheduled?
      EndAuctionJob.set(wait_until: @auction.end_date).perform_later(@auction)
    else
      render json: { success: false, messages: @auction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE api/v1/auctions/1
  def destroy
    authorize_current_user(@auction&.art&.owner) do
      @auction.destroy
    end
  end

  private

  def set_auction
    @auction = Auction.find(params[:id])
  end

  def auction_params
    params.require(:auction).permit(:art_id, :minimal_bid, :start_date, :end_date)
  end

  def assign_auction_start_date
    if @auction.start_date
      @auction.update(status: :scheduled)
    else
      @auction.update(status: :in_progress, start_date: Time.zone.now)
    end
  end
end
