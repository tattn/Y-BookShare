module V1
	class Books < Grape::API
		resource :books do

			desc "Add a new book."
			params do
				requires :title, type: String, desc: "Title of the book."
			end
			post do
				# unless Book.find_by title: params[:title]
				Book.create title: params[:title]
				status 201
				# end
			end

			params do
				requires :book_id, type: Integer, desc: "BookID"
			end
			route_param :book_id do

				desc "Get a book."
				get '/', jbuilder: 'books/book' do
					@book = Book.find(params[:book_id])
				end

			end

		end
	end
end
