Colorless to IRC daemon
=======================

This is a proof of concept that you can make such a daemon in about half an hour or less. It
connects to a channel on the Colorless chat server, and mirrors it to the a channel on
the Rizon IRC server.

You can use some environment variables to reconfigure it:

* IRC_HOST defaults to `irc.rizon.net`
* IRC_PORT defaults to `6667`
* IRC_CHANNEL defaults to `\#ColorlessTest`
* CL_CHANNEL defaults to `main`

Just `bundle install` initially and `ruby cl2irc.rb` this little bugger and you're all set.
