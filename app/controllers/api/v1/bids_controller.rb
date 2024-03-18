class Api::V1::BidsController < ApplicationController
  before_action :set_auction, only: %i[create index]
  before_action :authenticate_user!, only: %i[create]

  def create
    @bid = Transaction.new(kind: :bid, amount: bid_params[:amount], receiver: @auction, giver: current_user)

    if @bid.save
      current_user.update_balance
      cover_bid if @auction.bids.count > 1
      render :show, status: :created
    else
      render json: @bid.errors, status: :unprocessable_entity
    end
  end

  def show
    @bid = Transaction.find_by(id: params[:id], kind: :bid)
  end

  def index
    @bids = @auction.bids
  end

  private

  def bid_params
    params.require(:bid).permit(:auction_id, :user_id, :amount)
  end

  def set_auction
    @auction = Auction.find(params[:auction_id])
  end

  def cover_bid
    @covered_bid = @auction.bids[-2]
    @auction_return = Transaction.new(kind: :covered_bid, giver: @covered_bid.receiver,
                                      receiver: @covered_bid.giver, amount: @covered_bid.amount)
    @auction_return.save
    # TODO: on every transaction creation, enqueue a job to update the balance of the receiver
    @auction_return.receiver.update_balance
  end
end
