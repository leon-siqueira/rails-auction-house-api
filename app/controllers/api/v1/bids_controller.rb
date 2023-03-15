class Api::V1::BidsController < ApplicationController
  before_action :set_auction, only: %i[create index]
  before_action :authenticate_user!, only: %i[create]

  def create
    @bid = Bid.new(bid_params)
    @bid.user = current_user

    if @bid.save
      current_user.update_balance
      cover_bid if @auction.bids.count > 1
      render :show, status: :created
    else
      render json: @bid.errors, status: :unprocessable_entity
    end
  end

  def show
    @bid = Bid.find(params[:id])
  end

  def index
    @bids = @auction.bids
  end

  private

  def bid_params
    params.require(:bid).permit(:auction_id, :user_id, :value)
  end

  def set_auction
    @auction = Auction.find(params[:auction_id])
  end

  def cover_bid
    @covered_bid = @auction.bids[-2]
    @auction_return = AuctionReturn.new(kind: :covered_bid, auction: @covered_bid.auction,
                                        user: @covered_bid.user, value: @covered_bid.value)
    @auction_return.save
    @covered_bid.user.update_balance
  end
end
