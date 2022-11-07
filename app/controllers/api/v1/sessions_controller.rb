class Api::V1::SessionsController < ApplicationController
  def create
    user = User.where(email: params[:email]).first
    if user&.valid_password?(params[:password])
      render json: { data: { id: user.id, email: user.email }, token: JwtCodec.encode({ user_id: user.id }) },
             status: :created
    else
      head(:unauthorized)
    end
  end

  def show
    current_user ? head(:ok) : head(:unauthorized)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
