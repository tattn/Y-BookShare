module V1
	class Auth < Grape::API

		helpers do
			include V1::Helpers    # emit_empty などを使えるようにする（必須）
		end

		resource :auth do
			desc "Return access_token if valid login"
			params do
				requires :email, type: String, desc: "Email"
				requires :password, type: String, desc: "Password"
			end
			post :login, jbuilder: 'auth' do
				@user = User.where(email: params[:email]).first

				if @user && @user.authenticate(params[:password])
					key = ApiKey.create(user_id: @user.id)
					@token = key.access_token
				else
					emit_error! 'メールアドレスまたはパスワードが間違っています', 401, 1
				end
			end

			desc "Sign out"
			params do
				requires :token, type: String, desc: "Access token"
			end
			post :logout, jbuilder: 'empty' do
				authenticate!
        key = ApiKey.where(access_token: params[:token]).first
        key.destroy
			end

			desc "Try login using access token. This api exists for DEBUGGGGGGGGGGG"
			params do
				requires :token, type: String, desc: "Access token"
			end
			get :ping do
				authenticate! # params に :token をつけて、このメソッドを呼ぶと、ユーザー認証が自動で行われる
				{ message: "pong" }
			end
		end
	end
end
