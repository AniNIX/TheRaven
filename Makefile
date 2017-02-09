CONFDIR = /usr/local/etc/TheRaven
INSTALLER != bash -c `curl -s https://aninix.net/foundation/installer-test.bash`

compile: clean ./chatbot-support.bash ./math-support.bash
	if [ ! -x /usr/bin/mcs ] || [ ! -x /usr/bin/mono ] || [ ! -x /usr/bin/lynx ] || [ ! -x /usr/bin/bash ] || [ ! -x /usr/bin/wget ]; then ${INSTALLER} mono wget lynx bash; fi
	# Hook to use Djinni for notification
	if [ ! -d ../Djinni ]; then git clone -C '..' https://aninix.net/foundation/Djinni; fi
	git -C ../Djinni pull
	cd /usr/local/src/Djinni; make install
	if [ ! -d ../SharedLibraries ];  then git clone -C '..' https://aninix.net/foundation/SharedLibraries; fi
	git -C ../SharedLibraries pull
	mcs -out:raven.mono ../SharedLibraries/CSharp/*.csharp *.csharp Raven.csharp

clean:
	for i in raven.mono; do if [ -f $$i ]; then rm $$i; fi; done

test: compile
	script -c "mono ./raven.mono -c raven-test.conf -v" /tmp/raven-test.log

install: compile
	cp raven.mono /opt/raven.mono
	if [ ! -d ${CONFDIR} ]; then mkdir -p /usr/local/etc/TheRaven; cp ./sample-conf/* ${CONFDIR}; fi
	# Hook to deprivilege bot
	if ! getent passwd raven; then useradd -M -G git,ircd,api -d ${CONFDIR} raven; fi
	make checkperm
	# Hook for Heartbeat
	if [ -f /usr/local/etc/Heartbeat/services.list ] && [ `grep -c TheRaven /usr/local/etc/Heartbeat/services.list` -eq 0 ]; then echo "" >> /usr/local/etc/Heartbeat/services.list; fi
	# Hook for Systemd
	cp ./raven.service /usr/lib/systemd/system/raven.service
	systemctl daemon-reload
	systemctl enable raven

reverse: /usr/lib/systemd/system/raven.service
	cp  /usr/lib/systemd/system/raven.service .

checkperm: /opt/raven.mono
	chown -R raven:raven /opt/raven.mono ${CONFDIR}*
	chmod 0600 /opt/raven.mono ${CONFDIR}*/*
	chmod 0700 ${CONFDIR}*
    
