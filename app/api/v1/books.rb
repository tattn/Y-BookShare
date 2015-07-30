require 'foreign'

module V1
  class Books < Grape::API

    # このクラス内で共通化出来る処理は helper に書く
    helpers do
      include V1::Helpers    # emit_empty などを使えるようにする（必須）

      def find_by_id id
        book = Book.find_by id: id
        emit_error "指定した book_id が見つかりません", 400, 1 unless book
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
          emit_error "すでに登録されているタイトル", 400, 1 # エラーを吐く場合はこのメソッドを使う(参照: api/v1/root.rb)
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
        optional :title, type: String, desc: "Title of the book."
        optional :isbn, type: Integer, desc: "ISBN of the book."
        optional :amazon, type: Integer, desc: "search in amazon if this parameter exists"
        optional :start, type: Integer, default: 1, desc: "position of all results"
      end
      get '/search', jbuilder: 'books/books' do        # jbuilderで出力する場合はこのように書く(参照: views/api)
        @books = []
        title = params[:title] if params[:title]
        title = params[:isbn] if params[:isbn]
        if title
					RESULT_MAX = 10         # 取得件数
					start = params[:start]  # 取得開始位置

					books = Book.where("title like ?", "%#{title}%")
					book_count = books.count

					if book_count > RESULT_MAX * (start - 1)
						book = books.offset(10 * start).to_a
						@books += book
					end

          # データベースにない、またはパラメータによって指定されていれば、アマゾンで検索して結果を保存
          if @books.blank? or params[:amazon]
						#FIXME: アマゾンで検索した結果、データベースに既にあるものを取得してしまい、同じ本を返してしまう可能性がある
            Foreign.search_book title, start do |item|
              if item[:isbn]
                book = Book.find_or_initialize_by isbn: item[:isbn]
								puts "isbn"
              else
                book = Book.find_or_initialize_by title: item[:title]
								puts "title"
              end
              book.update item
              @books << book
            end
          end

        end
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
