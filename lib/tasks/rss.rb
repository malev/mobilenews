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

class Pagina12Crawler
  def initialize(link)
    @link = link
    @doc = Nokogiri::HTML(open(@link))
  end

  def generate_article
  end

end

class Article
end
