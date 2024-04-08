This is a simple IRC bot for the AniNIX's operations.

# Etymology

The Raven is a named after the [common raven](https://en.wikipedia.org/wiki/Raven) by [DarkFeather](/DarkFeather). There's a lot of history there, but it's effectively that user's namesake & avatar.

# Relevant Files and Software

The Raven's source code can be compiled into a deployable agent. To enable this bot, just install the package from [the AniNIX repository](https://maat.aninix.net) or run the following:

```
make
sudo make install
sudo systemctl enable --now raven.service
```

The configuration lives in `/usr/local/etc/TheRaven`. Unique files are provided for logins, search functions, help text, CrowFacts and magic8 functions, etc.

TheRaven is dependent on /bin/bash and [wget](https://wiki.archlinux.org/index.php/Wget) for the TinyURL features. It is dependent on the [Mono](https://wiki.archlinux.org/index.php/Mono) package for compiling on Linux.

TheRaven also expects an OS script, `api-keys`, that will return a TinyURL API key when run with the `tinyurl` parameter.

# Available Clients

There are no direct clients -- connect to [IRC](https://irc.aninix.net) or our Discord bridge. Use `r.help` in any channel where TheRaven is present to find out what it can do, or PM it directly.

# Equivalents or Competition

[Sopel](https://sopel.chat/) is an equivalent, maintained IRC bot. We maintain our own for the use case of testing code development.

Various Discord bots also perform the same function.

# Functionality
This IRC bot has some simple commands that can be found by most users with `r.help` in whatever channel the bot has joined.

Administrative functions are controlled by the access lists and can be found with `r.adminhelp`.

The bot can also be invoked with `mono ./raven.mono -h` to get more detailed help.
