module Devise
  module Strategies
    class JWTAuthenticatable < Base
      def authenticate!
        payload = JwtHeaderReaderHelper.decoded_token(request)
        return fail!(:timeout) if payload == :expired

        return fail!(:invalid) unless payload.present?

        resource = mapping.to.find(payload['user_id'])
        return fail!(:not_found_in_database) unless resource

        return fail!(:invalid) if payload['iat'] <= resource.token_expiration.to_i

        success!(resource)
      end
    end
  end
end
