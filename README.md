Mobilenews
==========

Small program that creates cron tasks to deliver the newspaper directly into your kindle. Of course, it requires calibre. In this case it sends: a daily newspaper, a magazine that's delivered on sundays and my Read it later list every hour.

Use
---
Clone it anywhere, create config.yml with the correct information and then run:

> bundle

> whenever --update-crontab

TODO
----
* create a new coolest syntax:

> Newsboy do
>  deliver "pagina_12_print_ed", :every => 1.day, :at => "4.30 am"
>  deliver "rebelion", :every => 1.hour
> end

* Add an option to deliver now everything.

More information
----------------
You can find more info about me and my projects on my personal [blog](https://blog.malev.com.ar)

License
-------
mobilenews is Copyright © 2011 malev.com.ar . It is free software, and may be redistributed under the terms specified in the LICENSE file.
