class Api::V1::SessionsController < ApplicationController
  def create
    @user = User.where(email: params[:email]).first
    issue_token
    if @user&.valid_password?(params[:password])
      render :create, status: :created
    else
      head(:unauthorized)
    end
  end

  def show
    current_user ? head(:ok) : head(:unauthorized)
  end

  def destroy
    current_user&.update(token_expiration: Time.zone.now)
    head(:ok)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def issue_token
    iat = Time.zone.now.to_i
    exp = iat + 3600
    @token = JwtCodec.encode({ user_id: @user.id, iat:, exp: })
  end
end
