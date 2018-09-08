__nidus_infinite_bash()
{
    true
    while [ "$?" != 200 ]; do
        clear
        echo
        echo "+============================================================+"
        echo "|                         Nidus Trap                         |"
        echo "+------------------------------------------------------------+"
        echo "| ** This bash session will be RESTARTED on normal exit.     |"
        echo "| ** To escape, use exit code 200.                           |"
        echo "+============================================================+"
        echo
        bash
    done
    return 0
}
alias nidus_trap=__nidus_infinite_bash

nidus_has hub && alias git=hub

function __petar_marinov_cd_func {

    local x2 the_new_dir adir index
    local -i cnt

    if [[ $1 ==  "--" ]]; then
        dirs -v
        return 0
    fi

    the_new_dir=$1
    [[ -z $1 ]] && the_new_dir=$HOME

    if [[ ${the_new_dir:0:1} == '-' ]]; then
        #
        # Extract dir N from dirs
        index=${the_new_dir:1}
        [[ -z $index ]] && index=1
        adir=$(dirs +$index)
        [[ -z $adir ]] && return 1
        the_new_dir=$adir
    fi

    #
    # '~' has to be substituted by ${HOME}
    [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

    #
    # Now change to the new dir and add to the top of the stack
    pushd "${the_new_dir}" > /dev/null
    [[ $? -ne 0 ]] && return 1
    the_new_dir=$(pwd)

    #
    # Trim down everything beyond 11th entry
    popd -n +11 2>/dev/null 1>/dev/null

    #
    # Remove any other occurence of this dir, skipping the top of the stack
    for ((cnt=1; cnt <= 10; cnt++)); do
        x2=$(dirs +${cnt} 2>/dev/null)
        [[ $? -ne 0 ]] && return 0
        [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
        if [[ "${x2}" == "${the_new_dir}" ]]; then
            popd -n +$cnt 2>/dev/null 1>/dev/null
            cnt=cnt-1
        fi
    done

    return 0
}

alias cd='__nidus_verbose_cd'
__nidus_verbose_cd() {
    __petar_marinov_cd_func "$1"
    local ret=$?
    if [ $ret -eq 0 ]; then
        if [ "$1" != -- ]; then
            ls >&2
        fi
    fi
    return $ret
}

__nidus_adjust_clock() {
    sudo ntpdate "time.nist.gov"
}
nidus_has ntpdate && alias nidus_adjust_clock=__nidus_adjust_clock
