#!@RCD_SCRIPTS_SHELL@
#
# $NetBSD: xenguest.sh,v 1.5 2015/04/20 08:05:30 sborrill Exp $
#
# PROVIDE: xenguest
# REQUIRE: DAEMON

# Set xenguest_osappend to optional string to add after OS version

$_rc_subr_loaded . /etc/rc.subr

name="xenguest"
rcvar=$name
command="@PREFIX@/sbin/xe-daemon"
start_cmd="xenguest_start"
start_precmd="xenguest_precmd"
xenbus_path="/kern/xen/xenbus"
pidfile="/var/run/xe-daemon.pid"
command_args="-p $pidfile"
command_interpreter="/bin/sh"

xenguest_precmd()
{
	XE_LINUX_DISTRIBUTION_CACHE=@VARBASE@/cache/xe-linux-distribution
	
	if [ ! -f ${xenbus_path} ]; then
		echo "${name}: Cannot find ${xenbus_path}!"
		exit 1
	fi
	if [ ! -x @PREFIX@/bin/xenstore-read ]; then
		echo "${name}: xenstore tools not found."
		exit 1
	fi
	domid=$(@PREFIX@/bin/xenstore-read domid)
	if [ "$domid" = 0 ]; then
		echo "${name}: Do not run on dom0, this is for domU use only."
		exit 1
	fi
	os_distro="$(uname -s)"
	os_uname="$(uname -r)"
	os_name="$(uname -s) $(uname -r)"
	if [ -n "$xenguest_osappend" ]; then
		os_name="${os_name} ${xenguest_osappend}"
	fi
	os_majorver="${os_uname%%.*}"
	os_minorver="${os_uname#*.}"
	os_minorver="${os_minorver%%.*}"

	mkdir -p @VARBASE@/cache
	cat << EOF > $XE_LINUX_DISTRIBUTION_CACHE
os_distro="$os_distro"
os_uname="$os_uname"
os_name="$os_name"
os_majorver="$os_majorver"
os_minorver="$os_minorver"
EOF
}

xenguest_start()
{
	@ECHO@ "Starting ${name}."
	$command $command_args &
}

load_rc_config $name
run_rc_command "$1"
