CONFDIR := /usr/local/etc/TheRaven

compile: /usr/bin/mcs /usr/bin/mono clean ./raven.csharp ./connection.csharp ./ravencommand.csharp /bin/bash /usr/bin/mail /usr/bin/wget /usr/local/bin/djinni ./chatbot-support.bash
	if [ ! -d ../Djinni ]; then git clone -C '..' https://aninix.net/foundation/Djinni; fi
	git -C ../Djinni pull
	if [ ! -d ../SharedLibraries ];  then git clone -C '..' https://aninix.net/foundation/SharedLibraries; fi
	git -C ../SharedLibraries pull
	mcs -out:raven.mono ../SharedLibraries/CSharp/*.csharp *.csharp 

clean:
	if [ "$$(ls ./*~ 2>/dev/null | wc -l)" -gt 0 ]; then rm -Rf *~; fi
	if [ "$$(ls ./*.mono 2>/dev/null | wc -l)" -gt 0 ]; then rm -Rf *.mono; fi
	if [ "$$(ls ./\#* 2>/dev/null | wc -l)" -gt 0 ]; then rm -Rf \#*; fi

edit:
	emacs -nw raven.csharp

test: compile
	script -c "mono ./raven.mono -c ${CONFDIR}-Test -v" /tmp/raven-test.log

check-for-verbosity:
	grep Console.WriteLine *.csharp | egrep -v 'verbosity|raven.csharp'; echo

install: compile
	cp raven.mono /opt/raven.mono
	if [ ! -d ${CONFDIR} ]; then (mkdir -p /usr/local/etc/TheRaven; cp ./sample-conf/* ${CONFDIR}); fi
	if ! getent passwd raven; then useradd -M -G git,ircd,api -d ${CONFDIR} raven; fi
	make checkperm
	cp ./raven.service /usr/lib/systemd/system/raven.service
	systemctl daemon-reload
	systemctl enable raven

reverse: /usr/lib/systemd/system/raven.service
	cp  /usr/lib/systemd/system/raven.service .

checkperm: /opt/raven.mono
	chown -R raven:raven /opt/raven.mono ${CONFDIR}*
	chmod 0600 /opt/raven.mono ${CONFDIR}*/*
	chmod 0700 ${CONFDIR}*
    
