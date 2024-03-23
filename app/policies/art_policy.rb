class ArtPolicy
  attr_reader :user, :art

  def initialize(user, art)
    @user = user
    @art = art
  end

  def index?
    @user.present?
  end

  def show?
    index?
  end

  def create?
    @user.is?(:admin) || @user.is?(:artist)
  end

  def update?
    @user.is?(:admin) || @art.creator == @user && @art.owner == @user
  end

  def destroy?
    update?
  end
end
