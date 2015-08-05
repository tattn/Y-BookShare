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
            result_max = 10         # 取得件数
            start = params[:start]  # 取得開始位置

            if params[:title]
              bookshelves = []
              id_by_title = Book.where("title like '%" + params[:title] + "%'").map(&:id)
              friends = Friend.where(user_id: @current_user.user_id).map(&:friend_id)
              bookshelves = Bookshelf.where user_id:friends, book_id:id_by_title
              book_count = bookshelves.count
              if book_count > result_max * (start - 1)
                @bookshelves = bookshelves.offset(result_max * start).limit(result_max)
              end
            end
          end
        end
      end


			resource :borrow do
				get '/', jbuilder: 'borrows/borrows' do
					authenticate!
					@borrows = Borrow.where(user_id: @current_user.user_id)
				end

				params do
					requires :book_id, type: Integer, desc: "book id"
					requires :lender_id, type: Integer, desc: "lender id"
					optional :due_date, type: String, desc: "due date"
				end
				post '/', jbuilder: 'empty' do
					authenticate!

					emit_error! "すでに借りている本を借りようとしています", 400, 1 if Borrow.find_by user_id: @current_user.user_id, book_id: params[:book_id]

					@borrow_book = Bookshelf.find_by user_id: params[:lender_id], book_id: params[:book_id]
					emit_error! "存在しない本を借りようとしています", 400, 1 unless @borrow_book

					if @borrow_book.borrower_id == 0
						if params[:due_date]
							Borrow.create user_id: @current_user.user_id, book_id: params[:book_id], lender_id: params[:lender_id], due_date: params[:due_date]
						else
							Borrow.create user_id: @current_user.user_id, book_id: params[:book_id], lender_id: params[:lender_id]
						end
						@borrow_book.update borrower_id: @current_user.user_id
					else
						emit_error! "すでに借りられている本を借りようとしています", 400, 1
					end
				end
			end
		end
  end
end
