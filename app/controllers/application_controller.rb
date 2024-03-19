class ApplicationController < ActionController::API
  def current_user
    @current_user ||= User.where(id: JwtHeaderReaderHelper.decoded_token(request)&.dig('user_id')).first
  end

  # TODO: change this by a proper authorization method like CanCanCan
  def authorize_current_user(authorized_user)
    if authorized_user == current_user
      yield
    elsif authorized_user != current_user || authorized_user.nil?
      render json: { success: false, message: 'Unauthorized' }, status: :unauthorized
    end
  end
end
