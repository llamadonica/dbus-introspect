## Process this file with automake to produce Makefile.in
## Created by Anjuta

SUBDIRS = src 

dbus_introspectdocdir = ${prefix}/doc/dbus_introspect
dbus_introspectdoc_DATA = \
	README\
	COPYING\
	AUTHORS\
	ChangeLog\
	INSTALL\
	NEWS


EXTRA_DIST = $(dbus_introspectdoc_DATA)


# Remove doc directory on uninstall
uninstall-local:
	-rm -r $(dbus_introspectdocdir)
