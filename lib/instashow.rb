require 'bundler'
Bundler.require

module Instashow
  def self.root
    @root ||= Pathname(File.expand_path('../..', __FILE__))
  end

  def self.env
    @env ||= (ENV['RACK_ENV'] || 'development')
  end

  def self.redis
    @redis ||= (
      url = URI(ENV['REDISTOGO_URL'] || "redis://127.0.0.1:6379")

      base_settings = {
        host: url.host,
        port: url.port,
        db: url.path[1..-1],
        password: url.password
      }

      Redis.new(base_settings)
    )
  end
end

require File.expand_path('../instashow/app', __FILE__)
require File.expand_path('../instashow/user', __FILE__)