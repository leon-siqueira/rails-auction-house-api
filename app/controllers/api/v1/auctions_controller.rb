class Api::V1::AuctionsController < ApplicationController
  before_action :set_auction, only: %i[show destroy]
  before_action :authenticate_user!, only: %i[create destroy]

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
    authorize_current_user(@auction&.art&.owner) do
      if assign_auction_start_date
        render :show, status: :created
        StartAuctionJob.set(wait_until: @auction.start_date).perform_later(@auction) if @auction.scheduled?
        EndAuctionJob.set(wait_until: @auction.end_date).perform_later(@auction)
      else
        render json: { success: false, messages: @auction.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  # DELETE api/v1/auctions/1
  def destroy
    authorize_current_user(@auction&.art&.owner) do
      @auction.destroy
    end
  end

  # POST api/v1/auctions/1/bid
  def bid
    @bid ||= Transactions::Create.new('bid', bid_params).call
    if @bid[:success]
      handle_bid
      render :bid, status: :created
    else
      render json: @bid[:error], status: :unprocessable_entity
    end
  end

  private

  def set_auction
    @auction = Auction.find(params[:id])
  end

  def auction_params
    params.require(:auction).permit(:art_id, :minimal_bid, :start_date, :end_date)
  end

  def bid_params
    sanitized_params = params.require(:transaction).permit(:auction_id, :user_id, :amount)
    sanitized_params.transform_keys do |key|
      key = :receiver_id if key == :auction_id
      key = :giver_id if key == :user_id

      key
    end
  end

  def handle_bid
    current_user.update_balance
    cover_bid if @auction.bids.count > 1
  end

  def cover_bid
    covered_bid = @auction.bids[-2]
    transaction_params = { giver_id: covered_bid.user.id, receiver_id: @auction.id, amount: covered_bid.amount }
    Transactions::Create.new('covered_bid', transaction_params).call
    covered_bid.user.update_balance
  end

  def assign_auction_start_date
    if @auction.start_date
      @auction.update(status: :scheduled)
    else
      @auction.update(status: :in_progress, start_date: Time.zone.now)
    end
  end
end
