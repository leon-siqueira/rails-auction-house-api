# frozen_string_literal: true

module JwtHeaderReaderHelper
  class << self
    def decoded_token(request)
      token = header_token(request)
      token.present? && JwtCodec.decode(token)
    end

    def header_token(request)
      header = request.headers['Authorization']
      header&.split&.last
    end
  end
end
