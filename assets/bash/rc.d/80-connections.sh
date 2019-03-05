__nidus_has screen && alias c=__connect_screen
function __connect_screen {
    if [ -n "$STY" ]; then
        echo '*** Nested screen is forbidden here ***'
        return
    fi

    local arg=${1:-}

    case "_$arg" in
        _)
            screen -q -x main || screen -S main
            ;;
        _:)
            screen -ls
            ;;
        _::)
            screen -q -ls
            errno=$?

            if [ $errno -le 10 ]; then
                echo '*** No available screens to attach. ***'
                return
            fi

              scrno=`screen -ls | sed -e '2q;d' | sed 's/^\s*\([0-9]\+\).*$/\1/g'`
            screen -x $scrno
            ;;
        *)
            screen -q -x "$arg" || screen -S "$arg"
            ;;
    esac
}

__nidus_has tmux && alias t=__connect_tmux
function __connect_tmux
{
    local arg="${1:-}"
    case "_$arg" in
        _)
            [ "${TMUX_ATTACHED:-no}" != yes ] && tmux new -c ~ -As main
            ;;
        _:)
            tmux ls
            ;;
        *)
            [ "${TMUX_ATTACHED:-no}" != yes ] && tmux new -c ~ -As "$arg"
            ;;
    esac
}

