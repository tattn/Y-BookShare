module V1
	class Books < Grape::API

		# このクラス内で共通化出来る処理は helper に書く
    helpers do
			include V1::Helpers    # emit_empty などを使えるようにする（必須）

			def find_by_id id
					book = Book.find_by id: id
					emit_error 100, "指定した book_id が見つかりません" unless book
					book
			end
    end

		resource :books do

			desc "Add a new book." # このAPIの説明
			params do              # このAPIに必要なパラメータ(require は必須, optional はなくてもいい引数)
				requires :title, type: String, desc: "Title of the book."
				optional :genre_id, type: Integer, desc: "GenreID of the book."
			end
			post do                # HTTP メソッド名
				if Book.find_by title: params[:title]
					emit_error 1, "すでに登録されているタイトル" # エラーを吐く場合はこのメソッドを使う(参照: api/v1/root.rb)
				else
					# status 201
					if params[:genre_id]
						Book.create title: params[:title], genre_id: params[:genre_id]
					else
						Book.create title: params[:title]
					end
					emit_empty                                   # 出力がない場合はこのメソッドを使う(参照: api/v1/root.rb)
				end
			end

			#TODO: タイトルの全文検索をできるようにするべき
			desc "Search books."
			params do
				optional :book_id, type: Integer, desc: "BookID"
				optional :title, type: String, desc: "Title of the book."
			end
			get '/search', jbuilder: 'books/books' do        # jbuilderで出力する場合はこのように書く(参照: views/api)
				@books = []
				book = Book.find_by(id: params[:book_id])
				@books << book if book
				book = Book.find_by(title: params[:title])
				@books << book if book
			end

			params do
				requires :book_id, type: Integer, desc: "BookID"
			end
			route_param :book_id do

				desc "Get a book."
				get '/', jbuilder: 'books/book' do
					@book = find_by_id params[:book_id]
				end

				desc "Change property of a book."
				params do
					requires :title, type: String, desc: "Title of the book."
				end
				put '/' do
					@book = find_by_id params[:book_id]
					return unless @book
					@book.update title: params[:title]
					emit_empty
				end

				desc "Delete a book."
				delete '/' do
					@book = find_by_id params[:book_id]
					return unless @book
					@book.destroy
					emit_empty
				end

			end

		end
	end
end
