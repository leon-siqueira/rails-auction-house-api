# frozen_string_literal: true

module Api
  module V1
    class AuctionsController < ApplicationController
      before_action :set_auction, only: %i[show destroy]
      before_action :authenticate_user!, only: %i[create destroy]
      before_action -> { authorize Auction }, only: %i[index]
      before_action -> { authorize @auction }, only: %i[show destroy]

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

        authorize @auction
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
        if @auction.destroy
          render json: { success: true, message: 'Auction deleted' }
        else
          render json: { success: false, message: @auction.errors }
        end
      end

      private

      def set_auction
        @auction = Auction.find(params[:id])
      end

      def auction_params
        params.require(:auction).permit(:art_id, :minimal_bid, :start_date, :end_date)
      end

      # TODO: Refactor this method to a service object
      def assign_auction_start_date
        if @auction.start_date
          @auction.update(status: :scheduled)
        else
          @auction.update(status: :in_progress, start_date: Time.zone.now)
        end
      end
    end
  end
end
