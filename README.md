Colorless to IRC daemon
=======================

This is a proof of concept that you can make such a daemon in about half an hour or less. It
connects to a channel on the Colorless chat server, and mirrors it to the a channel on
the Rizon IRC server.

You can use some environment variables to reconfigure it:

* IRC_HOST defaults to `irc.rizon.net`
* IRC_PORT defaults to `6667`
* IRC_CHANNEL defaults to `#ColorlessTest`
* CL_CHANNEL defaults to `main`

So basically if you want to change any of that, do `export IRC_HOST=somehost.net` before running the daemon.
To run it, just `bundle install` it initially and `ruby cl2irc.rb` this little bugger and you're all set.
