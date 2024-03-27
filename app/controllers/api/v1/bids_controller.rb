class Api::V1::BidsController < ApplicationController
  before_action :set_auction, only: %i[create index]
  before_action :authenticate_user!, only: %i[create]

  # POST api/v1/bids/1
  def create
    @bid ||= Transactions::Create.new('bid', bid_params).call
    if @bid[:success]
      cover_bid if @auction.bids.count > 1
      render :bid, status: :created
    else
      render json: @bid[:error], status: :unprocessable_entity
    end
  end

  # GET api/v1/bids/1
  def show
    @bid = Transaction.find_by(id: params[:id], kind: :bid)
  end

  # GET api/v1/auctions/1/bids
  def index
    @bids = @auction.bids
  end

  private

  def bid_params
    params.require(:bid).permit(:auction_id, :user_id, :amount)
    sanitized_params = params.require(:bid).permit(:auction_id, :user_id, :amount)
    sanitized_params.transform_keys do |key|
      key = :receiver_id if key == :auction_id
      key = :giver_id if key == :user_id

      key
    end
  end

  def set_auction
    @auction = Auction.find(params[:auction_id])
  end

  def cover_bid
    covered_bid = @auction.bids[-2]
    transaction_params = { giver_id: @auction.id, receiver_id: covered_bid.user.id, amount: covered_bid.amount }
    Transactions::Create.new('covered_bid', transaction_params).call
  end
end
