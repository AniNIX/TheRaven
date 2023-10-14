CONFDIR = ${pkgdir}/usr/local/etc/TheRaven
INSTALLDIR = ${pkgdir}/opt/aninix/TheRaven
SCRIPTS != ls -1 *.bash

compile: clean ./chatbot-support.bash ./math-support.bash
	(mcs -out:raven.mono /opt/aninix/Uniglot/CSharp/*.csharp *.csharp Raven.csharp 2>&1 | grep -v CS2002); printf ""

clean:
	for i in raven.mono; do if [ -f $$i ]; then rm $$i; fi; done

test: compile
	cd ./sample-confs; mono ../raven.mono -c sample.conf -v -h

install: compile 
	source $$PWD/installscript && pre_install || true
	install -o raven -g raven -m 0750 -d ${INSTALLDIR}
	for script in ${SCRIPTS} raven.mono; do install -o raven -g raven -m 0640 $$script ${INSTALLDIR}; done
	if [ ! -d ${CONFDIR} ]; then mkdir -p ${CONFDIR}; cp sample-confs/* ${CONFDIR}; fi
	# Hook to deprivilege bot
	make checkperm
	# Hook for Systemd
	mkdir -p ${pkgdir}/usr/lib/systemd/system/
	cp ./raven.service ${pkgdir}/usr/lib/systemd/system/raven.service

reverse: /usr/lib/systemd/system/raven.service /usr/local/etc/TheRaven
	cp /usr/lib/systemd/system/raven.service .
	cp ${INSTALLDIR}/*.bash .

checkperm: ${INSTALLDIR}/raven.mono
	chown -R raven:raven ${INSTALLDIR} ${CONFDIR}
	chmod 0600 ${INSTALLDIR}/* ${CONFDIR}/*
	chmod 0700 ${CONFDIR} ${INSTALLDIR}
    
diff: 
	diff ./raven.service ${pkgdir}/usr/lib/systemd/system/raven.service
	diff ./sample.conf ${pkgdir}/usr/local/etc/TheRaven/raven.conf
