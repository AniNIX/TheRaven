CONFDIR = ${pkgdir}/usr/local/etc/TheRaven
INSTALLER != curl -s https://aninix.net/foundation/installer-test.bash | /bin/bash

compile: clean ./chatbot-support.bash ./math-support.bash /usr/sbin/pb
	mkdir -p ${pkgdir}/usr/local/src/
	if [ ! -d ${pkgdir}/usr/local/src/SharedLibraries ];  then git -C ${pkgdir}/usr/local/src/ clone https://aninix.net/foundation/SharedLibraries; fi
	git -C ${pkgdir}/usr/local/src/SharedLibraries pull
	(mcs -out:raven.mono ${pkgdir}/usr/local/src/SharedLibraries/CSharp/*.csharp *.csharp Raven.csharp 2>&1 | grep -v CS2002); printf ""

clean:
	for i in raven.mono; do if [ -f $$i ]; then rm $$i; fi; done

test: compile
	script -c "mono ./raven.mono -c raven-test.conf -v" ${pkgdir}/tmp/raven-test.log

install: compile
	mkdir -p ${pkgdir}/opt
	cp raven.mono ${pkgdir}/opt/raven.mono
	if [ ! -d ${CONFDIR} ]; then mkdir -p ${CONFDIR}; cp sample-confs/* ${CONFDIR}; fi
	# Hook to deprivilege bot
	if ! getent passwd raven; then useradd -M -G git,ircd,api -d ${CONFDIR} raven; fi
	make checkperm
	# Hook for Heartbeat
	if [ -f ${pkgdir}/usr/local/etc/Heartbeat/services.list ] && [ `grep -c TheRaven ${pkgdir}/usr/local/etc/Heartbeat/services.list` -eq 0 ]; then echo "" >> ${pkgdir}/usr/local/etc/Heartbeat/services.list; fi
	# Hook for Systemd
	mkdir -p ${pkgdir}/usr/lib/systemd/system/
	cp /usr/local/src/TheRaven/raven.service ${pkgdir}/usr/lib/systemd/system/raven.service

reverse: ${pkgdir}/usr/lib/systemd/system/raven.service
	cp  ${pkgdir}/usr/lib/systemd/system/raven.service .

checkperm: ${pkgdir}/opt/raven.mono
	chown -R raven:raven ${pkgdir}/opt/raven.mono ${CONFDIR}*
	chmod 0600 ${pkgdir}/opt/raven.mono ${CONFDIR}*/*
	chmod 0700 ${CONFDIR}*
    
diff: 
	diff ./raven.service ${pkgdir}/usr/lib/systemd/system/raven.service
	diff ./sample.conf ${pkgdir}/usr/local/etc/TheRaven/raven.conf
