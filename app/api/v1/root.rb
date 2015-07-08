module V1
	module Helpers
		extend Grape::API::Helpers

		def emit_error code, msg
			env['api.tilt.template'] = 'error'
			env['api.tilt.locals'] = { code: code, error_msg: msg }
		end

		def emit_empty
			{ status: 200 }
		end
	end

  class Root < Grape::API
    version 'v1'
    mount V1::Books
  end

end
