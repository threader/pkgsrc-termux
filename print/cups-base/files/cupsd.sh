#!@RCD_SCRIPTS_SHELL@
#
# $NetBSD: cupsd.sh,v 1.1 2017/11/12 14:10:15 khorben Exp $
#
# Common UNIX Printing System daemon
#
# PROVIDE: cups
# REQUIRE: DAEMON
#
# You will need to set some variables in /etc/rc.conf to start cupsd:
#
# cupsd=YES
# cupsd_wait=YES	# set to "YES" to wait for cupsd to detect printers;
#			#   this variable is optional and defaults to "NO".
# cupsd_timeout=60	# set to the number of seconds we wait for cupsd
#			#   to respond before we declare it not responding;
#			#   this variable is optional and defaults to "60".

if [ -f /etc/rc.subr ]; then
	. /etc/rc.subr
fi

name="cupsd"
rcvar=${name}
command="@PREFIX@/sbin/${name}"
pidfile="@VARBASE@/run/cups/cupsd.pid"
lpstat_command="@PREFIX@/bin/lpstat"
command_args="& sleep 2"
required_files="@PKG_SYSCONFDIR@/${name}.conf"
extra_commands="reload wait"
wait_cmd="cupsd_waitcmd"
start_postcmd="cupsd_poststart"

cupsd_poststart()
{
	if checkyesno cupsd_wait; then
		run_rc_command wait
	fi
}

cupsd_waitcmd()
{
	if [ -x ${lpstat_command} ]; then
		msg=
		@ECHO@ -n "Waiting ${cupsd_timeout} seconds for ${name}: "
		if ${lpstat_command} -r >/dev/null 2>&1; then
			msg='responding'
		else
			master=$$
			trap "msg='not responding'" ALRM
			(sleep ${cupsd_timeout} && kill -ALRM $master) >/dev/null 2>&1 &
			while [ -z "$msg" ]; do
				if ${lpstat_command} -r >/dev/null 2>&1; then
					msg='responding'
					trap : ALRM
				else
					sleep 5
					@ECHO@ -n '.'
				fi
			done
		fi
		@ECHO@ "$msg"
	fi
}

if [ -f /etc/rc.subr ]; then
	load_rc_config $name
	: ${cupsd_wait:=NO}
	: ${cupsd_timeout:=60}
	run_rc_command "$1"
else
	@ECHO@ -n " ${name}"
	${command} ${cupsd_flags} ${command_args}
fi
