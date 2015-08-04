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

				desc "Receive opposite reply"
				params do
					requires :book_id, type: Integer, desc: "Book id"
				end
				put '/sent', jbuilder: 'empty' do
          authenticate!
          req = Request.find_by sender_id: @current_user.user_id, book_id: params[:book_id]
					emit_error! "リクエストが存在しません", 400, 1 unless req
					req.destroy
				end
      end
    end
  end
end
