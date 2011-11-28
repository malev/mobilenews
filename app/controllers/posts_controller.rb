class PostsController < ApplicationController
  def new
    @post = @blog.new_post
  end
end
