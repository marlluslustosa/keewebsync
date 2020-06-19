#!/bin/sh

sed -i -E -e "s/LDAPDRCPW/${LDAPDRCPW}/" \
	-e "s/LDAPDRCIP/${LDAPDRCIP}/" \
	-e "s/LDAPDRCBASEDN/${LDAPDRCBASEDN}/" \
	-e "s/LDAPDRCBINDDN/${LDAPDRCBINDDN}/" \
	-e "s/KDBXNAME/${KDBXNAME}/g" \
        /etc/lighttpd/lighttpd.conf

ln -s /var/www/html/webdav/${KDBXNAME}.kdbx /var/www/html/${KDBXNAME}

/usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf
