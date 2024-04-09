# frozen_string_literal: true

module JwtCodec
  class << self
    def encode(data = {})
      JWT.encode(data, ENV.fetch('JWT_SECRET', nil), 'HS256')
    end

    def decode(token)
      JWT.decode(token, ENV.fetch('JWT_SECRET', nil), true, { algorithm: 'HS256' }).first
    rescue JWT::ExpiredSignature
      :expired
    end
  end
end
