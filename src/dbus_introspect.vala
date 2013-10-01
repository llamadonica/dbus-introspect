/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- */
/*
 * dbus_introspect.vala
 * Copyright (C) 2012 Adam and Monica Stark <adstark1982@yahoo.com>
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name ``Adam and Monica Stark'' nor the name of any other
 *    contributor may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 * 
 * dbus-introspect IS PROVIDED BY Adam and Monica Stark ``AS IS'' AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL Adam and Monica Stark OR ANY OTHER CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

using GLib;

[DBus (name = "org.freedesktop.DBus.Introspectable", timeout = 120000)]
public interface Introspectable : GLib.Object {
	[DBus (name = "Introspect")]
	public abstract string introspect() throws DBusError, IOError;
}

[DBus (name = "org.freedesktop.DBus.Introspectable", timeout = 120000)]
public interface IntrospectableSync : GLib.Object {
	[DBus (name = "Introspect")]
	public abstract string introspect() throws DBusError, IOError;
}

public class Main : GLib.Object 
{
	// Whether to use the system bus.
	static bool       use_system  = false;
	// introspect the specified bus address and path, returning a string,
	// or null if any kind of error is detected.
	static string?    introspect (string address, string path) throws DBusError, IOError
	{
		if (!Util.is_object_path(path))
		{	
			stderr.printf ("Object path was invalid.\n");
			return null;
		}
		debug ("Config: %s%s %s", use_system?"-s ":"", address, path);
		Introspectable objRoot = Bus.get_proxy_sync (use_system?BusType.SYSTEM:BusType.SESSION, address, path);
		if (objRoot == null)
		{	
			stderr.printf ("Could not connect to specified object.\n");
			return null;
		}
		return objRoot.introspect();
	}

	// The main entry point
	static int main (string[] args) {	
		const OptionEntry[] opts = 
           {{ "session", '\x0', OptionFlags.REVERSE, 
                                   OptionArg.NONE,   out use_system, "Use the session bus (the default.)",null},
			{ "system",  's',   0, OptionArg.NONE,   out use_system, "Use the system bus.",null},
            { null }};
		OptionContext optParse = new OptionContext("ADDRESS PATH\n\nPrint the interfaces of a DBus object that exposes the \"org.freedsktop.DBus.Introspectable\" interface.");
		optParse.add_main_entries(opts,null);
		try {
			optParse.parse(ref args) ;
		}
		catch (OptionError e) {
			stderr.printf("%s\n%s\n", e.message,optParse.get_help(false,null));
			return 1;	
		}
		{ // Assign arguments
			if (args.length < 2 ) {
				stderr.printf( "You must specify an address.\n%s",optParse.get_help(false,null)) ;
				return 1;
			}
			if (args.length < 3) {
				stderr.printf( "You must specify an object path.\n%s",optParse.get_help(false,null)) ;
				return 1;
			}
			else if (args.length > 3) {
				stderr.printf("Unknown argument: %s\n%s\n", args[3],optParse.get_help(false,null));
				return 1;
			}
		}
		string? result = null;
		try 
		{	result = introspect( args[1], args[2]);
			if (result == null)
				return 1;
		}
		catch (Error e)
		{
			stderr.printf ("%s\n", e.message) ; 
			return 1;
		}
		stdout.printf (result);
		return 0;
	}
}
