#!@RCD_SCRIPTS_SHELL@
#
# $NetBSD: samba.sh,v 1.1 2015/05/12 12:19:52 ryoon Exp $
#
# PROVIDE: samba
# REQUIRE: DAEMON

. /etc/rc.subr

name="samba"
rcvar=$name
command="@PREFIX@/sbin/${name}"
pidfile="@SMB_PID@/${name}.pid"
required_files="@SMB_CONFIG@/smb.conf"
extra_commands="reload"

load_rc_config $name
run_rc_command "$1"
