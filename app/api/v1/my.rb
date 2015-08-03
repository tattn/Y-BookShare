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

      resource :friends do
        resource :bookshelves do
          params do
            optional :title, type: String, desc: "title of the book"
            optional :start, type: Integer, default: 1, desc: "position of all results"
          end
          get '/search' , jbuilder: 'bookshelves/bookshelves' do
            authenticate!
            @bookshelves = []
            result_max = 10         # 取得件数
            start = params[:start]  # 取得開始位置

            if params[:title]
              id_by_title = Book.where("title like '%" + params[:title] + "%'").map(&:id)
              Friend.where(user_id: @current_user.user_id).each do |user|
                bookshelves << Bookshelf.where(user_id: params[:user_id], book_id: id_by_title)
              end
              book_count = bookshelves.count
              if book_count > result_max * (start - 1)
                book = bookshelves.offset(10 * start).to_a
                @bookshelves += book
              end
            end
          end
        end
      end
    end
  end
