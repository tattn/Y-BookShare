
module V1
  class Blacklists < Grape::API
    # このクラス内で共通化出来る処理は helper に書く
    helpers do
      include V1::Helpers    # emit_empty などを使えるようにする（必須）
    end

    params :token do
      requires :token, type: String, desc: "Access token"
    end
    resource :my do
      resource :blacklist do
        desc "get a blacklist"
        get '/', jbuilder: 'users/users' do
          authenticate!
          black_ids = Blacklist.where(user_id: @current_user.user_id).map(&:bother_id)
          @users = User.where(user_id: black_ids)
        end

        desc "add blacklist"
        params do
          requires :user_id, type: Integer, desc: "block user id"
        end
        post '/', jbuilder: 'empty' do
          authenticate!
          emit_error! "既に登録されています", 400, 1 if Blacklist.find_by user_id: @current_user.user_id, bother_id: params[:user_id]
          Blacklist.create user_id: @current_user.user_id, bother_id: params[:user_id]
        end

        params do
          requires :user_id, type: Integer, desc: "user id"
        end
        route_param :user_id do
          desc "acquit a user"
          delete '/', jbuilder: 'empty' do
            authenticate!
            blacklist = Blacklist.find_by user_id: @current_user.user_id, bother_id: params[:user_id]
            emit_error! "ブラックリストに登録されていません", 400, 1 unless blacklist
            blacklist.destroy
          end
        end
      end

    end

  end
end
