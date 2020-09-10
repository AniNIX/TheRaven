CONFDIR = ${pkgdir}/usr/local/etc/TheRaven

compile: clean ./chatbot-support.bash ./math-support.bash
	(mcs -out:raven.mono /opt/aninix/Uniglot/CSharp/*.csharp *.csharp Raven.csharp 2>&1 | grep -v CS2002); printf ""

clean:
	for i in raven.mono; do if [ -f $$i ]; then rm $$i; fi; done

test: compile
	cd ./sample-confs; mono ../raven.mono -c sample.conf -v -h

install: compile 
	mkdir -p ${pkgdir}/opt
	cp raven.mono ${pkgdir}/opt/raven.mono
	if [ ! -d ${CONFDIR} ]; then mkdir -p ${CONFDIR}; cp sample-confs/* ${CONFDIR}; fi
	# Hook to deprivilege bot
	make checkperm
	# Hook for Systemd
	mkdir -p ${pkgdir}/usr/lib/systemd/system/
	cp ./raven.service ${pkgdir}/usr/lib/systemd/system/raven.service

reverse: ${pkgdir}/usr/lib/systemd/system/raven.service
	cp  ${pkgdir}/usr/lib/systemd/system/raven.service .

checkperm: ${pkgdir}/opt/raven.mono
	chown -R raven:raven ${pkgdir}/opt/raven.mono ${CONFDIR}*
	chmod 0600 ${pkgdir}/opt/raven.mono ${CONFDIR}*/*
	chmod 0700 ${CONFDIR}*
    
diff: 
	diff ./raven.service ${pkgdir}/usr/lib/systemd/system/raven.service
	diff ./sample.conf ${pkgdir}/usr/local/etc/TheRaven/raven.conf
