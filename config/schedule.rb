require 'yaml'

current_path = Dir.pwd
recipes_path = current_path + "/recipes"
log_path = current_path + "/log" 

CONFIG = YAML.load_file(current_path + "/config/config.yml")
recipes = CONFIG['recipes']

set :output, log_path + "/cron_log.log"

every 1.day, :at => "4.30 am" do
  recipes.each do |recipe|
    command "ebook-convert #{recipes_path}/#{recipe} #{File.join(current_path, recipe + ".mobi")}"
    command "calibre-smtp --attachment #{recipe}.mobi --relay smtp.gmail.com --port 587 --username \"#{CONFIG['email']}\" --password \"#{CONFIG['password']}\" --encryption-method TLS #{CONFIG['email']} #{CONFIG['kindle_email']} \"\""
    command "rm #{File.join(current_path, recipe + ".mobi")}"
  end
end

recipe = "ieco.recipe"
every :Sunday, :at => '5 am' do
  command "ebook-convert #{recipes_path}/#{recipe} #{File.join(current_path, recipe + ".mobi")}"
  command "calibre-smtp --attachment #{recipe}.mobi --relay smtp.gmail.com --port 587 --username \"#{CONFIG['email']}\" --password \"#{CONFIG['password']}\" --encryption-method TLS #{CONFIG['email']} #{CONFIG['kindle_email']} \"\""
  command "rm #{File.join(current_path, recipe + ".mobi")}"
end

recipe = "readitlater.recipe"
every 1.hour do
  command "ebook-convert recipes/readitlater.recipe #{File.join(current_path, recipe + ".mobi")} --username #{CONFIG['ril_username']} --password #{CONFIG['ril_password']}"
  command "calibre-smtp --attachment #{recipe}.mobi --relay smtp.gmail.com --port 587 --username \"#{CONFIG['email']}\" --password \"#{CONFIG['password']}\" --encryption-method TLS #{CONFIG['email']} #{CONFIG['kindle_email']} \"\""
  command "rm #{File.join(current_path, recipe + ".mobi")}"
end
