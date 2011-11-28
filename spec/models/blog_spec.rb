require 'spec_helper'

describe Blog do
  before do
    @blog = Blog.new
    @new_post = OpenStruct.new
    @blog.post_maker = ->{ @new_post }
  end

  it "should have no entries" do
    @blog.entries.should be_empty
  end

  it "should return a new post" do
    @it.new_post.must_equal @new_post
  end

  it "should set the post's blog reference to itself" do
    @it.new_post.blog.must_equal(@it)
  end
end
