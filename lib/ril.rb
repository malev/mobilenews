require 'rubygems'
require 'httparty'

class ReadItLater
  class Response
    attr_reader :header, :body, :text

    def initialize(response)
      @header = Header.new response.headers
      @body = Body.new response.body
    end
  end

  class Header
    TYPES = {
      "200" => "Request was successful",
      "400" => "Invalid request, please make sure you follow the documentation for proper syntax",
      "401" => "Username and/or password is incorrect",
      "403" => "Rate limit exceeded, please wait a little bit before resubmitting",
      "503" => "Read It Later's sync server is down for scheduled maintenance"
    }

    AVAILABLE_METHODS = %w(x-limit-user-limit x-limit-user-remaining x-limit-user-reset x-limit-key-limit x-limit-key-remaining x-limit-key-reset)

    def initialize(header)
       @header = header
    end

    def status
      st = @header.status["status"][0]
      [st, TYPES[st]]
    end

    def method_missing(sym, *args, &block)
      if sym.to_s =~ /^x\-limit/ && @header.key?(sym)
        @header[sym]
      else
        super
      end
    end

    def respond_to?(sym, include_private=false)
      if sym.to_s =~ /^x\-limit/ && @header.key?(sym)
        true
      else
        super
      end
    end
  end

  class Text
    include HTTParty
    base_uri "http://text.readitlaterlist.com/"

    def bring(query)
      get('/v2/text', :query => query)
    end
  end

  include HTTParty
  base_uri 'https://readitlaterlist.com'

  def initialize(username, password, apikey=nil)
    @apikey = apikey.nil? ? get_apikey : apikey
    @username = username
    @passowrd = passowrd
  end

  def self.text(options = {})
    apikey ||= get_apikey
    url = options[:url]
    mode = options[:mode] ? options[:mode] : "less"
    images = options[:images] ? options[:images] : 0
    query = { :url => url, :mode => mode, :images => images, :apikey => apikey}

    bring("/v2/text", :query => query)
  end

  def self.status
    apikey ||= get_apikey
    query = { :apikey => apikey}
    bring('/v2/api', :query => query)
  end

  def self.get_apikey
    "c66gkx0Zpfu44ad8diT9d77P3fAjlp50"
  end

  def create
    query = { :username => @username, :passowrd => @passowrd, :apikey => @apikey}
    bring("/v2/signup", :query =>  query)
  end

  def bring(path, query = {})
    response = if query[:query][:url]
      Text.bring(path, query)
    else
      get(path, queyr)
    end
    wrapper(response)
  end

  def wrapper(response)
    Response.new(response)
  end
end
