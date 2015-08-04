module V1
  class Push < Grape::API
    # このクラス内で共通化出来る処理は helper に書く
    helpers do
      include V1::Helpers    # emit_empty などを使えるようにする（必須）
    end

    # params do
    #   requires :token, type: String, desc: "Access token"
    # end
    resource :push do
      params do
        requires :user_id, type: String, desc: "User ID"
      end
      post '/' do
        # authenticate!

        PARSE_COM_APPLICATION_ID =  'n3giGyxTaQClMezovu0s6Zm2ZwtiVBD5TlLYOQKf'
        PARSE_COM_REST_API_KEY = 'WW8sO4UjrxAzSQuaeGaZGUCLEMGSTPzARwQvj550'

        client = Parse.create application_id: PARSE_COM_APPLICATION_ID, api_key: PARSE_COM_REST_API_KEY, quiet: true

        user = User.find_by user_id:params[:user_id]

        data = { alert: 'test messsage', badge: 'Increment' }
        push = client.push(data)
        push.type = "ios"
        query = client.query(Parse::Protocol::CLASS_USER).eq('username', user.email)
        push.where = query.where
        push.save

        { status: 200 }
      end
    end
  end
end
