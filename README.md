This is a simple IRCbot for the AniNIX's operations.

# Usage
To enable this bot, just install the package from [the AniNIX repository](https://maat.aninix.net) or run the following:
```
make
sudo make install
sudo systemctl start raven.service
sudo systemctl enable raven.service
```

# Functionality
This IRCbot has some simple commands that can be found by most users with `r.help` in whatever channel the bot has joined.

Administrative functions are controlled by the access lists and can be found with `r.adminhelp`.

The bot can also be invoked with `mono ./raven.mono -h` to get more detailed help.
