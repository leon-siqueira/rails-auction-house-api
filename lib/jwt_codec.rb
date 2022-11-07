module JwtCodec
  class << self
    def encode(data = {})
      JWT.encode(data, ENV['JWT_SECRET'], 'HS256')
    end

    def decode(token)
      JWT.decode(token, ENV['JWT_SECRET'], true, { algorithm: 'HS256' }).first
    rescue JWT::ExpiredSignature
      :expired
    end
  end
end
