# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Pagina12, "will work on pagina 12"  do
  before do
    file = Rails.root + "spec/support/pagina.xml"
    pagina_xml = File.read(file)
    url = "http://www.pagina12.com.ar/diario/rss/principal.xml"

    FakeWeb.register_uri(:get, url, :body => pagina_xml) 
    @pagina = Pagina12.new(url)
  end

  it "should return a hash as a header" do
    @pagina.generate_header[:title].should_not be_nil
  end

  it "should generate a collection of resumes" do
    title = "Un fantasma recorre Argentina, es el fantasma de la pol\xEDtica"
    resumes = @pagina.generate_resumes
    resumes.class.should == Array
    resumes.first.class.should == Resume
    resumes.first.title.should == title 
  end
end

describe Resume, "generate a resume object" do
  before do
    @article_rss = {
      title: "title",
      link: "link",
      description: "description",
      author: "author"
    }
  end

  it "should populate the object resume" do
    resume = Resume.new @article_rss
    resume.title.should == "title"
  end
end

describe Article do
  before do
    file = Rails.root + "spec/support/pagina.html"
    pagina_html = File.read(file)
    @url = "http://www.pagina12.com.are/diario/elpais/1-181165-2011-11-13.html"
    FakeWeb.register_uri(:get, @url, :body => pagina_html) 

    @article = Article.new(@url)
  end

  it "should process with all the information correctly" do
    title = "Un fantasma recorre Argentina, es el fantasma de la política"
    author = "marcos"
    
    @article.process
    @article.link.should == @url
    @article.title.should == title
    @article.author.should == author
  end
end
