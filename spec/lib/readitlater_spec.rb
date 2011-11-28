# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReadItLater, "The class should talk to the ReadItLater Api" do
  before do
    @url = "https://readitlaterlist.com/v2/"
  end

  def select_response(dir="", resp)

    FakeWeb.register_uri(:get, @url + dir, :body => resp) 
  end

  it "should verify if the credentials are correct"

  it "should fail with FASE credentials" do
    username = "false"
    password = "incorrect"
    resp = false

    select_response('auth', resp)

    ReadItLater.auth(username, password).should == false
  end

  it "should authenticate with the correct user/password"

  it "should fail if pass or user are incorrect"

  it "should get the user reading list"


end
