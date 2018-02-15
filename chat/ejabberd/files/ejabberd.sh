#!@RCD_SCRIPTS_SHELL@
#
# $NetBSD: ejabberd.sh,v 1.4 2014/07/31 10:31:51 fhajny Exp $
# $FreeBSD: ejabberd.sh.in,v 1.1 2005/08/28 15:51:48 vsevolod Exp $
#
# PROVIDE: ejabberd
# REQUIRE: DAEMON
# BEFORE: LOGIN
# KEYWORD: shutdown

if [ -f /etc/rc.subr ]
then
        . /etc/rc.subr
fi

name="ejabberd"
rcvar=${name}

command=ejabberdctl
ejabberd_user="@EJABBERD_USER@"
reload_cmd="ejabberd_reload"
restart_cmd="ejabberd_reload"
start_cmd="ejabberd_start"
status_cmd="ejabberd_status"
stop_cmd="ejabberd_stop"

PATH=/sbin:/bin:/usr/sbin:/usr/bin:@PREFIX@/bin:@PREFIX@/sbin
EJABBERDCTL=@PREFIX@/sbin/ejabberdctl

ejabberd_status()
{
    su $ejabberd_user -c "$EJABBERDCTL status >/dev/null"
}

ejabberd_start()
{
    echo -n "Starting $name: "
    if ejabberd_status; then
	echo " already running."
	exit 1
    else
	su $ejabberd_user -c "$EJABBERDCTL start"
    fi
    echo "$name."
}

ejabberd_stop()
{
    echo -n "Stopping $name: "
    if su $ejabberd_user -c "$EJABBERDCTL stop"; then
	cnt=0
        while ejabberd_status; do
            cnt=`expr $cnt + 1`
            if [ $cnt -gt 60 ]; then
                echo -n " failed "
                break
            fi
            sleep 1
            echo -n "."
        done
    else
        echo -n " failed "
    fi
    echo "$name."
}

ejabberd_reload()
{
    echo -n "Restarting $name: "
    if ejabberd_status; then
        su $ejabberd_user -c "$EJABBERDCTL restart"
    else
        ejabberd_start
    fi
    echo "$name."
}

load_rc_config $name
run_rc_command "$1"
