module V1
  class Root < Grape::API
    version 'v1'
    mount V1::Books
  end
end
