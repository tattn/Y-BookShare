module V1
	module Helpers
		extend Grape::API::Helpers

		def emit_error msg, status, code
			error!({ message: msg, status: status, code: code }, status)
			# env['api.tilt.template'] = 'error'
			# env['api.tilt.locals'] = { code: code, error_msg: msg }
		end

		def emit_empty
			{ status: 200 }
		end


		def authenticate!
			emit_error 'Unauthorized. Invalid or expired token.', 401, 1 unless current_user
		end

		def current_user
			token = ApiKey.where(access_token: params[:token]).first
			if token && !token.expired?
				@current_user = User.find(token.user_id)
			else
				false
			end
		end
	end

  class Root < Grape::API
    version 'v1'
    mount V1::Books
		mount V1::Auth
  end

end
