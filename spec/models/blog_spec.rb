require 'spec_helper'
require 'ostruct'

describe Blog do
  before do
    @it = Blog.new
    @new_post = OpenStruct.new
    @it.post_maker = ->{ @new_post }
  end

  it "should have no entries" do
    @it.entries.should be_empty
  end

  it "should return a new post" do
    @it.new_post.should eql(@new_post)
  end

  it "should set the post's blog reference to itself" do
    @it.new_post.blog.should eql(@it)
  end

  it "should accept an attribute hash on behalf of the post maker" do
    post_maker = mock()
    post_maker.expects(:call).with({:x => 42, :y => 'z'}).returns(@new_post)
    @it.post_maker = post_maker
    @it.new_post(:x => 42, :y => 'z')
    #post_maker.verify
  end

  describe "#add_entry" do
    it "should add the entry to the blog" do
      entry = Object.new
      @it.add_entry(entry)
      @it.entries.should include(entry)
    end
  end
end
