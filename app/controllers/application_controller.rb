class ApplicationController < ActionController::Base
  #include Clearance::Authentication
  protect_from_forgery

  before_filter :init_blog

  private

  def init_blog
    @blog = Blog.new
  end
end
