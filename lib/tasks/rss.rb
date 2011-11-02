require 'rubygems'
require 'simple-rss'
require 'open-uri'

rss = SimpleRSS.parse open('http://slashdot.org/index.rdf')

class Source
  attr_reader :url, :name, :description, :logo

  def initialize(url, name)
    @name = name
    @url = url
  end

  def retrieve_resumes
    rss = SimpleRSS.parse open(url)
    @channel = rss.channel
    @items = rss.items
  end


end

class Pagina12
  def initialize(url)
    @url = url
    @rss = SimpleRSS.parse open(url)
    @items = rss.items
  end

  def get_header
    { :title => "Pagina 12" }
  end

  def generate_header
    ""
  end

  def generate_index
    output = "<div class='index'>"
    @items.each_with_index do |item, i|
      resume = Resume.new item
      output << resume.to_html("anchor_#{i}")
    end
    output << "</div>"
  end

  def generate_content
    output = "<div class='content'>"
    @items.each_with_index do |item, i|
      article = ArticleCrawler.new(item["link"])
      output << article.to_html("anchor_#{i}")
    end
    output << "</div>"
  end

  def to_html
    output = "<html>"
    output << generate_header + generate_index + generate_content
    output << "</html>"
  end
end

class Resume
  def initialize(item)
    @item = item
  end

  def to_html(link='')
  end
end

class ArticleCrawler
  def initialize(link)
    @link = link
    @doc = Nokogiri::HTML(open(@link))
  end

  def generate_article
    @doc.channel.link
  end

  def generate_content
  end
end

class Article
  attr_accessor :title, :section, :author, :volanta, :content, :image

  def to_html(link = '')
  end
end
