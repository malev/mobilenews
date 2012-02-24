Mobilenews
==========

Small program that creates cron tasks to deliver the newspaper directly into your kindle. Of course, it requires calibre. In this case it sends: a daily newspaper, a magazine that's delivered on sundays and my Read it later list every hour.

Use
---

* Install [calibre](http://calibre-ebook.com/).
* Clone it wherever you want.
* Run bundle
* Config your config/config.yml and mobilenews files (there is an example below.)
* Run mobilenews

mobilenews file
---------------

```ruby  
#!/usr/bin/env ruby

require_relative "lib/newsboy.rb"

Newsboy.new do
  deliver "pagina_12_print_ed", :every => "1 day", :at => "4.30 am"
  deliver "ieco", :every => "sunday", :at => "4.40 am"
end.work
```

Options
-------
```sh  
$ ./mobilenews --help
Usage: Newsboy [options]
    -i, --update-crontab
    -w, --write-crontab
    -c, --clear-crontab
    -d, --deliver-now
    -v, --version
```

More information
----------------
You can find more info about me and my projects on my personal [blog](https://blog.malev.com.ar).

License
-------
mobilenews is Copyright © 2011 malev.com.ar . It is free software, and may be redistributed under the terms specified in the COPYING file.
