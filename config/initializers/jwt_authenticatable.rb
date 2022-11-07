module Devise
  module Strategies
    class JWTAuthenticatable < Base
      def authenticate!
        payload = JwtHeaderReaderHelper.decoded_token(request)
        return fail(:invalid) unless payload.present?

        return fail(:invalid) if payload == :expired

        resource = mapping.to.find(payload['user_id'])
        return fail(:not_found_in_database) unless resource

        success!(resource)
      end
    end
  end
end
