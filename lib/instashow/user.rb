module Instashow
  class User
    attr_reader :nickname, :access_token

    def initialize(nickname, access_token)
      @nickname, @access_token = nickname, access_token
    end

    def slideshow_url
      "http://instashow.me/#{nickname}"
    end

    def self.find_access_token_by_nickname(nickname)
      if Instashow.redis.exists(formalize_key(nickname))
        new nickname, Instashow.redis.hget(formalize_key(nickname), "access_token")
      else
        nil
      end
    end

    def self.create(omniauth)
      Instashow.redis.hset formalize_key(omniauth["info"]["nickname"]), "access_token", omniauth["credentials"]["token"]
      new omniauth["info"]["nickname"], omniauth["token"]
    end

    def self.formalize_key(key)
      "instashow:#{Instashow.env}:#{key}"
    end
  end
end