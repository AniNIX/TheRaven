raven.mono: /usr/bin/mcs /usr/bin/mono clean ./raven.csharp ./connection.csharp ./ravencommand.csharp /bin/bash /usr/bin/mail /usr/bin/wget
	mkdir -p /usr/local/etc/TheRaven
	mcs -out:raven.mono reportmessage.csharp *exception.csharp irc*message.csharp connection.csharp raven*.csharp
	id raven || useradd -M -G git,ircd,api raven
	id raven || usermod -d /usr/local/etc/TheRaven raven
	chown raven:raven /usr/local/etc/TheRaven

clean:
	if [ "$$(ls ./*~ 2>/dev/null | wc -l)" -gt 0 ]; then rm -Rf *~; fi
	if [ "$$(ls ./*.mono 2>/dev/null | wc -l)" -gt 0 ]; then rm -Rf *.mono; fi
	if [ "$$(ls ./\#* 2>/dev/null | wc -l)" -gt 0 ]; then rm -Rf \#*; fi
	if [ -f raven.mono ]; then rm raven.mono; fi

edit:
	emacs -nw raven.csharp

test: raven.mono
	script -c "mono ./raven.mono -c /usr/local/etc/TheRaven-Test -v" /tmp/raven-test.log

check-for-verbosity:
	grep Console.WriteLine *.csharp | egrep -v 'verbosity|raven.csharp'; echo

install: raven.mono
	cp raven.mono /opt/raven.mono
	[ ! -d /usr/local/etc/TheRaven ] || mkdir -p /usr/local/etc/TheRaven
	chown -R raven:raven /opt/raven.mono /usr/local/etc/TheRaven*
	chmod 0600 /opt/raven.mono /usr/local/etc/TheRaven*/*
	chmod 0700 /usr/local/etc/TheRaven*
	cp ./raven.service /usr/lib/systemd/system/raven.service
	/usr/bin/bash make-conf-dir.bash /usr/local/etc/TheRaven
	systemctl daemon-reload
	systemctl enable raven
