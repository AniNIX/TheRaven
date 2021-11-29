CONFDIR = ${pkgdir}/usr/local/etc/TheRaven
LIST = ravensend ravensend-daemon

compile:
	@echo Nothing to do.

clean:
	rm -Rf pkg src

test: compile
	./ravensend -h

install: compile 
	mkdir -p ${pkgdir}/usr/local/bin
	for i in ${LIST}; do install -m 0755 -o raven -g raven $$i ${pkgdir}/usr/local/bin; done
	# Hook for Systemd
	mkdir -p ${pkgdir}/usr/lib/systemd/system/
	install -m 0644 -o raven -g raven ./ravensend-daemon.service ${pkgdir}/usr/lib/systemd/system/
	mkdir -p ${pkgdir}/usr/local/etc/
	install -m 0640 -o raven -g raven ./ravensend-daemon.yml ${pkgdir}/usr/local/etc/

reverse: ${pkgdir}/usr/lib/systemd/system/ravensend-daemon.service
	cp ${pkgdir}/usr/lib/systemd/system/ravensend-daemon.service .
	for i in ${LIST}; do cp ${pkgdir}/usr/lib/systemd/system/$$i .; done

checkperm: ${pkgdir}/opt/raven.mono
	for i in ${LIST}; do chown -R raven: ${pkgdir}/usr/local/bin/$$i; chmod 0755 ${pkgdir}/usr/local/bin/$$i; done
	chown raven: ${pkgdir}/usr/lib/systemd/system/ravensend-daemon.service
	chmod 0644 ${pkgdir}/usr/lib/systemd/system/ravensend-daemon.service

diff: 
	for i in ${LIST}; do diff ${pkgdir}/usr/lib/systemd/system/$$i $$i; done
	diff ${pkgdir}/usr/lib/systemd/system/ravensend-daemon.service ./ravensend-daemon.service
