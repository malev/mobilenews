require 'optparse'
require 'whenever'
require 'yaml'

class Newsboy
  def initialize(&block)
    @current_path = Dir.pwd
    @recipes_path = @current_path + "/recipes"
    @log_path = @current_path + "/log"
    @output = "set :output, \"#{@log_path}\" + \"/cron_log.log\"\n"
    @config = YAML.load_file(@current_path + "/config/config.yml")
    @options = {}
    @recipes = []
    parse_options
    instance_eval &block
  end

  def work
    @options[:string] = @output

    if @options[:deliver]
      @recipes.each do |recipe|
        system "ebook-convert #{@recipes_path}/#{recipe}.recipe #{File.join(@current_path, recipe + ".mobi")}"
        system "calibre-smtp --attachment #{recipe}.mobi --relay smtp.gmail.com --port 587 --username \"#{@config['email']}\" --password \"#{@config['password']}\" --encryption-method TLS #{@config['email']} #{@config['kindle_email']} \"\""
        system "rm #{File.join(@current_path, recipe + ".mobi")}"
        # %x[ebook-convert #{@recipes_path}/#{recipe}.recipe #{File.join(@current_path, recipe + ".mobi")}]
        # %x[calibre-smtp --attachment #{recipe}.mobi --relay smtp.gmail.com --port 587 --username \\\"#{@config['email']}\\\" --password \\\"#{@config['password']}\\\" --encryption-method TLS #{@config['email']} #{@config['kindle_email']} \"\"]
        # %x[rm #{File.join(@current_path, recipe + ".mobi")}]
        puts "sent!"
        exit(0)
      end
    else
      Whenever::CommandLine.execute(@options)
    end
  end

  def deliver(recipe, options = {})
    options[:every] = get_every(options[:every])
    options[:at] = get_at(options[:at])
    @recipes << recipe
    @output << build_string(recipe, options)
  end

  def build_string(recipe, options)
    "every #{options[:every]}#{options[:at]} do
      command \"ebook-convert #{@recipes_path}/#{recipe}.recipe #{File.join(@current_path, recipe + ".mobi")};calibre-smtp --attachment #{recipe}.mobi --relay smtp.gmail.com --port 587 --username \\\"#{@config['email']}\\\" --password \\\"#{@config['password']}\\\" --encryption-method TLS #{@config['email']} #{@config['kindle_email']} \"\";rm #{File.join(@current_path, recipe + ".mobi")}\"
    end\n"
  end

  def get_at(at)
    if at.nil?
      ""
    else
      ", :at => \"#{at}\""
    end
  end

  def get_every(every)
    every = every.split(" ")
    if every.length == 1
      ":" + every.first
    else
      every.join(".")
    end
  end

  def parse_options
    OptionParser.new do |opts|
      opts.banner = "Usage: Newsboy [options]"
      opts.on('-i', '--update-crontab') do |identifier|
        @options[:update] = true
      end
      opts.on('-w', '--write-crontab') do |identifier|
         @options[:write] = true
      end
      opts.on('-c', '--clear-crontab') do |identifier|
        @options[:clear] = true
      end
      opts.on('-d', '--deliver-now') do |identifier|
        @options[:deliver] = true
      end
      opts.on('-v', '--version') { puts "Newsboy v#{"0.0.1"}"; exit(0) }
    end.parse!
  end
end