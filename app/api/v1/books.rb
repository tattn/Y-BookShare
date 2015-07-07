module V1
	class Books < Grape::API

    helpers do
			def emit_error code, msg
				env['api.tilt.template'] = 'error'
				env['api.tilt.locals'] = { code: code, error_msg: msg }
			end

			def emit_empty
					{ status: 200 }
			end

			def find_by_id id
					book = Book.find_by id: id
					emit_error 100, "指定した book_id が見つかりません" unless book
					book
			end
    end

		resource :books do

			desc "Add a new book."
			params do
				requires :title, type: String, desc: "Title of the book."
			end
			post do
				if Book.find_by title: params[:title]
					emit_error 1, "すでに登録されているタイトル"
				else
					# status 201
					Book.create title: params[:title]
					emit_empty
				end
			end

			desc "Search books."
			params do
				optional :book_id, type: Integer, desc: "BookID"
				optional :title, type: String, desc: "Title of the book."
			end
			get '/search', jbuilder: 'books/books' do
				@books = []
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
