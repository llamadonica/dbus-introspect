## Process this file with automake to produce Makefile.in

## Created by Anjuta



AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	$(DBUS_INTROSPECT_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

bin_PROGRAMS = dbus_introspect

dbus_introspect_SOURCES = \
	dbus_introspect.vala config.vapi

dbus_introspect_VALAFLAGS =  --pkg glib-2.0  \
	--pkg gio-2.0 \
        --vapidir=. \
        --pkg dbus_introspect_util

dbus_introspect_LDFLAGS = \
	-Wl,--export-dynamic

dbus_introspect_LDADD = $(DBUS_INTROSPECT_LIBS)


