class ApplicationController < ActionController::API
  def current_user
    @current_user ||= User.where(id: payload['user_id']).first
  end

  def emmit_jwt_token(data = {})
    JWT.encode(data, ENV['JWT_SECRET'])
  end

  private

  def jwt_token
    header = request.headers['Authorization']
    header&.split(' ')&.last
  end

  def payload
    token = jwt_token
    begin
      JWT.decode(token, ENV['JWT_SECRET'], true, { algorithm: 'HS256' }).first
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
