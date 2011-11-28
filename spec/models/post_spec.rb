require 'spec_helper'

describe Post do
  before do
    @it = Post.new
  end

  it "should start with blank attributes" do
    @it.title.should be_nil
    @it.body.should be_nil
  end

  it "should support reading and writing a title" do
    @it.title = "foo"
    @it.title.should eql("foo")
  end

  it "should support reading and writing a post body" do
    @it.body = "foo"
    @it.body.should eql("foo")
  end

  describe "#publish" do
    before do
      @blog = Object.new
      @it.expects(:blog).returns(@blog)
    end

    after do
      @blog.verify
    end

    it "should add the post to the blog" do
      @blog.expect :add_entry, nil, [@it]
      @it.publish
    end
  end
end
