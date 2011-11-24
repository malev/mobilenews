#!/usr/bin/env ruby -w
# encoding: UTF-8

require 'rubygems'
require 'httparty'
require 'pp'

class ReadItLater
  include HTTParty
  base_uri 'https://readitlaterlist.com'

  def initialize(username, password, apikey)
    @user_auth = {:username => username, :password => password}
    @apikey = {:apikey => apikey}
    @auth = @user_auth.merge(@apikey)
  end

  def status
    self.class.get('/v2/api', :query => @apikey)
  end

  def status_info
    self.status.headers.to_hash
  end

  def list
    self.class.get('/v2/get', :query => @auth)
  end
end

read = ReadItLater.new("malev", '', "c66gkx0Zpfu44ad8diT9d77P3fAjlp50")

