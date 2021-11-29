This package provides a couple files that will allow you to send messages via TheRaven to an IRC daemon.

# ravensend

This CLI allows you to send a message to a channel using TheRaven. Simplest invocation is as below:

```
ravensend -c '#thechannel' -f ./the.conf -m 'some message'
```

Assuming TheRaven sits in #thechannel and the user has the rights to read the.conf, the message should go through.

# ravensend-daemon

This daemon allows you to translate webhook inputs from services like Graylog to be sent by TheRaven.
