module V1
  class Timelines < Grape::API
    # このクラス内で共通化出来る処理は helper に書く
    helpers do
      include V1::Helpers    # emit_empty などを使えるようにする（必須）
    end

    params do
      requires :token, type: String, desc: "Access token"
    end
    resource :my do
      resource :timeline do
        get '/', jbuilder: 'timelines/timelines' do
          authenticate!
          @timelines = []
          friends = Friend.where user_id: @current_user.user_id, accepted: true
          friends.each do |friend|
            @timelines += Timeline.where(user_id: friend.friend_id).to_a
          end
          @timelines.sort! {|a, b| b.created_at <=> a.created_at}
        end
      end
    end
  end
end
