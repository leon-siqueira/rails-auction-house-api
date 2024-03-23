class ApplicationController < ActionController::API
  include Pundit::Authorization

  def current_user
    @current_user ||= User.where(id: JwtHeaderReaderHelper.decoded_token(request)&.dig('user_id')).first
  end

end
