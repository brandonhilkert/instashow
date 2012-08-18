module Instashow
  class App < Sinatra::Base
    set :root, Instashow.root
    enable :sessions

    configure :development do
      register Sinatra::Reloader
    end

    use OmniAuth::Builder do
      provider :instagram, "5010d455f7e3477d903380e6e1619e32", "d4f6d96e9829494c9babf20cb2579724"
    end

    get '/' do
      erb :index
    end

    get '/auth/instagram/callback' do
      user = Instashow::User.create(request.env["omniauth.auth"])
      puts request.env["omniauth.auth"]["credentials"]["token"]
      redirect to("/#{user.nickname}")
    end

    get '/:nickname' do
      @user = Instashow::User.find_access_token_by_nickname params[:nickname]

      if @user
        Instagram.access_token = @user.access_token
        @photos = Instagram.user_recent_media(count: 50)
        erb :show
      else
        @nickname = params[:nickname]
        erb :bummer
      end
    end

  end
end