# frozen_string_literal: true

module Api
  module V1
    class BidsController < ApplicationController
      before_action :set_auction, only: %i[create index]
      before_action :authenticate_user!, only: %i[create]
      before_action -> { authorize Transaction, policy_class: BidPolicy }, only: %i[show index]

      # GET api/v1/auctions/1/bids
      def index
        @bids = @auction.bids
      end

      # GET api/v1/bids/1
      def show
        @bid = Transaction.find_by(id: params[:id], kind: :bid)
      end

      # POST api/v1/bids/
      def create
        @bid_creation ||= Transactions::Create.call('bid', bid_params)
        @bid = @bid_creation[:transaction]

        authorize @bid, policy_class: BidPolicy
        if @bid_creation[:success]
          cover_bid if @auction.bids.count > 1
          render :show, status: :created
        else
          render json: @bid_creation[:errors], status: :unprocessable_entity
        end
      end

      private

      def bid_params
        sanitized_params = params.require(:bid)
                                 .permit(:auction_id, :amount)
                                 .merge(giver_id: current_user.id)
        sanitized_params.transform_keys! do |key|
          key = :receiver_id if key.to_sym == :auction_id

          key
        end

        sanitized_params
      end

      def set_auction
        @auction = Auction.find(params.dig(:bid, :auction_id) || params[:auction_id])
      end

      def cover_bid
        covered_bid = @auction.bids[-2]
        transaction_params = { giver_id: @auction.id, receiver_id: covered_bid.giver.id, amount: covered_bid.amount }
        Transactions::Create.call('covered_bid', transaction_params)
      end
    end
  end
end
