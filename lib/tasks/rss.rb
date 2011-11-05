require 'rubygems'
require 'simple-rss'
require 'nokogiri'
require 'open-uri'

#rss = SimpleRSS.parse open('http://www.psgina12.com.ar/diario/rss/principal.xml')


class Pagina12
  attr_reader :resumes, :articles, :header

  def initialize(url)
    @url = url
    @rss = SimpleRSS.parse open(url)
    @items = @rss.items
  end

  def generate_header
    @header = { :title => "Pagina 12" }
  end

  def generate_resumes
    @resumes = []
    @items.each { |item| @resumes << Resume.new(item) }
    @resumes
  end

  def generate_articles
    @articles = []
    @resumes.each do |resume|
      @articles << Article.new(resume.link)
    end
    @articles
  end
end

class Resume
  attr_reader :title, :link, :description, :author

  def initialize(item)
    @item = item
    process
  end

private

  def process
    @title = @item[:title]
    @link = @item[:link]
    @description = @item[:description]
    @author = @item[:author]
  end
end

class Article
  attr_reader :title, :link, :description,
              :content, :author, :volanta

  def initialize(url)
    @url = url
  end

  def process
    @doc = Nokogiri::HTML(open(@url))
    nota = @doc.css("div.nota").first
    @volanta = nota.css("p.volanta").first.content
    @title = nota.css("h2").first.content
    @description = nota.css("p.intro").first.content
    @author = nota.css("p.autor").first.content unless nota.css("p.css").empty?
    @content = nota.css("div#cuerpo").first.content
  end
end

class HTMLGenerator
  def initialize(newspaper)
    @newspaper = newspaper
  end

  def to_html
    @output ||= header + index + content + footer
  end

  def index
    output = "<div class='index'>"
    @newspaper.generate_resumes.each_with_index do |resume, i|
      output << "<div class='resume'>"
      output << "<h3><a href=\'#anchor_#{i}\'>"
      output << resume.title + "</a></h3>"
      output << "<div class='author'>#{resume.author}</div>" if resume.author
      output << "<div class='description'>#{resume.description}</div>"
      output << "</div>"
    end
    output = output + "</div>"
  end

  def header
    "<html><head><title>#{}</title></head><body>"
  end

  def content
    output = "<div class='content'>"
    @newspaper.generate_articles.each_with_index do |article, i|
      article.process
      output << "<div class='article'>"
      output << "<a name=\'anchor_#{i}\'/>"
      output << "<div><em>#{article.volanta}</em></div>"
      output << "<h3>#{article.title}</h3>"
      output << "<div class='article'>"
      output << "<div class='author'>#{article.author}</div>"
      output << "<div class='description'>#{article.description}</div>"
      output << "<div class='note'>#{article.content}</div>"
      output << "</div></div>"
    end
    output
  end

  def footer
    "<div>Created by mobinews</div></body></html>"
  end
end

pagina= Pagina12.new("http://www.pagina12.com.ar/diario/rss/principal.xml")
html = HTMLGenerator.new(pagina)
puts html.to_html

