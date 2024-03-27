class AuctionPolicy
  attr_reader :user, :art

  def initialize(user, auction)
    @user = user
    @auction = auction
    @art = auction.art
  end

  def index?
    @user.present?
  end

  def show?
    index?
  end

  def create?
    @user.is?(:admin) || @user.is?(:auctioneer)
  end

  def destroy?
    create?
  end
end
