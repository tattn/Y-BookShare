module V1
  class Requests < Grape::API
    # このクラス内で共通化出来る処理は helper に書く
    helpers do
      include V1::Helpers    # emit_empty などを使えるようにする（必須）
    end

    params do
      requires :token, type: String, desc: "Access token"
    end
    resource :my do
      resource :request do
        get '/sent', jbuilder: 'requests/requests2' do
          authenticate!
          @reqs = Request.where(sender_id: @current_user.user_id)
        end
      end
    end
  end
end
