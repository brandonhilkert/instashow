require 'bundler'
Bundler.require
require "sinatra/reloader" if development?

enable :sessions

use OmniAuth::Builder do
  provider :instagram, "5010d455f7e3477d903380e6e1619e32", "d4f6d96e9829494c9babf20cb2579724"
end

get '/' do
  erb :index
end

get '/auth/instagram/callback' do
  session[:access_token] = request.env["omniauth.auth"].credentials.token
  session[:nickname] = request.env["omniauth.auth"].info.nickname
  # raise request.env["omniauth.auth"]
  redirect to("/show")
end

get '/show' do
  Instagram.access_token = session[:access_token]
  @photos = Instagram.user_recent_media(count: 50)
  puts @photos.count
  erb :show
end