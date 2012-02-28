require 'thor'
require 'open3'

class Newsboy < Thor
  desc "test", "just testing a bit"
  def deliver(recipe)
    load_config
    mobi_file = generate_mobi(recipe)
    deliver_mobi(mobi_file)
    remove_mobi(mobi_file)
  end

  desc "Generate mobi", "Generate the mobi file for the given recipe"
  def generate_mobi(recipe)
    recipe_file = File.expand_path("#{recipe}.recipe", @recipes_path)
    new_file = File.expand_path("#{recipe}.mobi", @current_path)
    if File.exists?(recipe_file)
      puts "ebook-convert #{recipe_file} #{new_file} >> #{@log_file} 2>&1"
      system("ebook-convert #{recipe_file} #{new_file} >> #{@log_file} 2>&1")
    else
      puts "The recipe of #{recipe} does not exist!"
      exit(0)
    end
    new_file
  end

  desc "Deliver mobi file", ""
  def deliver_mobi(mobi_file)
    load_config
    puts "calibre-smtp --attachment #{mobi_file} --relay smtp.gmail.com --port 587 \\
            --username \"#{@config['email']}\" --password \"#{@config['password']}\" \\
            --encryption-method TLS #{@config['email']} #{@config['kindle_email']} \"\" \\
            >> #{@log_file} 2>&1"
    system("calibre-smtp --attachment #{mobi_file} --relay smtp.gmail.com --port 587 \\
            --username \"#{@config['email']}\" --password \"#{@config['password']}\" \\
            --encryption-method TLS #{@config['email']} #{@config['kindle_email']} \"\" \\
            >> #{@log_file} 2>&1")
  end

  desc "Remove mobi file", ""
  def remove_mobi(mobi_file)
    load_config
    puts "rm #{mobi_file} >> #{@log_file} 2>&1"
    system("rm #{mobi_file} >> #{@log_file} 2>&1")
  end

  no_tasks do
    def load_config
      @current_path = Dir.pwd
      @log_file = File.expand_path("log/cron_log.log", @current_path)
      @recipes_path = @current_path + "/recipes"
      @config = YAML.load_file(@current_path + "/config/config.yml")
    end
  end
end
