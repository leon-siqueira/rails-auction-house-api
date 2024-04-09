# frozen_string_literal: true

class BidPolicy
  attr_reader :user, :bid

  def initialize(user, bid)
    @user = user
    @bid = bid
    @auction = @bid.receiver if bid.instance_of?(Transaction)
  end

  def index?
    @user.present?
  end

  def show?
    index?
  end

  def create?
    @user.is?(:admin) || (@user.is?(:buyer) && @auction.user != @user)
  end
end
