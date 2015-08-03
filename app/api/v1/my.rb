module V1
  class My < Grape::API
    # このクラス内で共通化出来る処理は helper に書く
    helpers do
      include V1::Helpers    # emit_empty などを使えるようにする（必須）
    end

    params do
      requires :token, type: String, desc: "Access token"
    end
    resource :my do
      resource :invitation_code do
        get '/' do
          authenticate!
          { status: 200, invitation_code: @current_user.invitation_code }
        end

        put '/' do
					code = SecureRandom.hex
					begin
						User.update invitation_code: code
					end while User.find_by(invitation_code: code)
        end
      end
    end
  end
end
