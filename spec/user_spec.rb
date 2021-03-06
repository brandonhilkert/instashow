require "spec_helper"

describe Instashow::User do
    let(:omniauth) {
      {
        "credentials" => {
          "token" => "21434159.5010d45.5e1bfe30b59841b286815111e4129073"
        },
        "info" => {
          "nickname" => "brandonhilkert"
        }
      }
    }

  describe "#slideshow_url" do
    it "should create the correct url" do
      user = Instashow::User.new("brandon", "23asdfas")
      user.slideshow_url.should == "http://instashow.me/brandon"
    end
  end

  describe ".find_access_token_by_nickname" do
    before(:each) do
      Instashow::User.create(omniauth)
    end

    subject { Instashow::User.find_access_token_by_nickname("brandonhilkert") }

    it "should return user object" do
      subject.should be_a Instashow::User
    end

    it "should have nickname" do
      subject.nickname.should == "brandonhilkert"
    end

    it "should have access_token" do
      subject.access_token.should == "21434159.5010d45.5e1bfe30b59841b286815111e4129073"
    end

    it "should return nil if user isn't found" do
      Instashow::User.find_access_token_by_nickname("test").should be_nil
    end
  end

  describe ".create" do
    it "adds hash with nickname key" do
      Instashow::User.create(omniauth)
      Instashow.redis.exists(Instashow::User.formalize_key(omniauth["info"]["nickname"])).should be_true
    end

    it "create a hash that includes access_token" do
      Instashow::User.create(omniauth)
      Instashow.redis.hget(Instashow::User.formalize_key(omniauth["info"]["nickname"]), "access_token").should == "21434159.5010d45.5e1bfe30b59841b286815111e4129073"
    end

    it "returns the new User" do
      Instashow::User.create(omniauth).should be_a Instashow::User
    end
  end

  describe ".formalize_key" do
    it "returns proper key for env" do
      Instashow.stub(env: "development")
      Instashow::User.formalize_key("access_token").should == "instashow:development:access_token"
    end
  end
end