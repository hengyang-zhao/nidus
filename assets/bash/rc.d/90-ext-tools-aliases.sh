__nidus_has dict && alias d=__define
__define() {
    if [ 0 -eq $# ]; then
        echo "usage: define <word>" >&2
        return 255
    fi

    local e=$'\033[';
    dict "$@" | \
        sed -e "s/\<\($1\)\>/${e}7;33m\1${e}0m/g" \
        -e "s/^\(From \)\(.*\):$/${e}1m\1${e}4m\2${e}0m${e}1m:${e}0m/g" | \
        less -r
}

__nidus_has bc && alias b=__bc_calc
__bc_calc()
{
    if [ $# -eq 0 ]; then
        bc -l
    else
        echo "$@" | bc -lq
    fi
}

__nidus_has vboxmanage && alias lsvm='__query_vm'
__query_vm()
{
    if ! [ $1 ]; then
        echo $'\033[1m'---- registered guests ----$'\033[0m'
        vboxmanage list vms
        echo $'\033[1m'---- running guests ----$'\033[0m'
        vboxmanage list runningvms
        return 0
    fi

    vboxmanage list vms | grep "\<$1\>" &> /dev/null
    if ! [ 0 = $? ]; then
        echo virtualbox guest "$1" does not exist.
        return -1
    fi

    vboxmanage list runningvms | grep "\<$1\>" &> /dev/null
    if [ 0 = $? ]; then
        echo virtualbox guest "$1" is running.
        return 0
    else
        echo virtualbox guest "$1" is stopped.
        return 1
    fi
}
