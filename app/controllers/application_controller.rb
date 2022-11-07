class ApplicationController < ActionController::API
  def current_user
    @current_user ||= User.where(id: JwtHeaderReaderHelper.decoded_token(request)['user_id']).first
  end
end
