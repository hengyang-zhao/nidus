__NIDUS_COMMAND_SNO=0
__NIDUS_COMMAND_ERRNO=0

function __nidus_prefix_line_if_labeled {
    local label=${NIDUS_PS1_LABEL:-}
    local prefix="$1"
    if [ -n "$label" ]; then
      sed -e "s/^/$(__nidus_fmt ps1_label)$prefix$(__nidus_reset_fmt)/g"
    else
      cat
    fi
}

function __nidus_inline_echo {
    builtin echo -n "$@"
}

function  __nidus_cursor_xpos {
    local saved_state xpos dummy
    saved_state="$(stty -g)"
    stty -echo
    echo -n $'\033[6n' > /dev/tty; read -s -d ';' dummy; read -s -dR xpos
    echo "$xpos"
    stty "$saved_state" 2>/dev/null
}

function __nidus_force_newline {
    if ! [ "${NIDUS_ENABLE_EXPLICIT_EOF:-no}" = yes ]; then
        return
    fi

    if [ "$(__nidus_cursor_xpos)" != 1 ]; then
        __nidus_reset_fmt
        __nidus_fmt force_newline
        __nidus_inline_echo ":no_eol:"
        __nidus_reset_fmt

        if [ "$(__nidus_cursor_xpos)" != 1 ]; then
            builtin echo
        fi
    fi
}

function __nidus_short_hostname {
    if [ -z "${NIDUS_PS1_HOSTNAME:-}" ]; then
        local node_name="$(uname -n)"
        __nidus_inline_echo "${node_name%%.*}"
    else
        __nidus_inline_echo "$NIDUS_PS1_HOSTNAME"
    fi
}

function __nidus_ps1_user_host {
    __nidus_ps1_username

    __nidus_fmt ps1_userhost_punct zero_width
    __nidus_inline_echo "@"
    __nidus_reset_fmt zero_width

    __nidus_ps1_hostname
    return 0
}

function __nidus_ps1_username {
    __nidus_fmt ps1_username zero_width
    __nidus_inline_echo "$(whoami)"
    __nidus_reset_fmt zero_width
}

function __nidus_ps1_hostname {
    __nidus_fmt ps1_hostname zero_width
    __nidus_inline_echo "$(__nidus_short_hostname)"
    __nidus_reset_fmt zero_width
    return 0
}

function __nidus_ps1_non_default_ifs {
    if [[ "${#IFS}" == 3 && "$IFS" == *" "* && "$IFS" == *$'\t'* && "$IFS" == *$'\n'* ]]; then
        return 1
    fi

    __nidus_fmt ps1_ifs zero_width
    __nidus_inline_echo "(IFS="
    __nidus_reset_fmt zero_width

    __nidus_fmt ps1_ifs_value zero_width
    printf "%q" "$IFS"
    __nidus_reset_fmt zero_width

    __nidus_fmt ps1_ifs zero_width
    __nidus_inline_echo ")"
    __nidus_reset_fmt zero_width

    return 0
}

function __nidus_ps1_chroot {
    if [ -n "${debian_chroot:-}" ]; then
        __nidus_fmt ps1_chroot zero_width
        __nidus_inline_echo "($debian_chroot)"
        __nidus_reset_fmt zero_width
        return 0
    else
        return 1
    fi
}

function __nidus_ps1_bg_indicator {
    local njobs="$1"
    if [ "$njobs" -gt 0 ]; then
        __nidus_fmt ps1_bg_indicator zero_width
        __nidus_inline_echo "&$njobs"
        __nidus_reset_fmt zero_width
        return 0
    fi
    return 1
}

function __nidus_ps1_shlvl_indicator {
    if [ "$SHLVL" -gt 1 ]; then
        __nidus_fmt ps1_shlvl_indicator zero_width
        __nidus_inline_echo "^$(expr "$SHLVL" - 1)"
        __nidus_reset_fmt zero_width
        return 0
    fi
    return 1
}

function __nidus_ps1_screen_indicator {
    local session="${STY:-}"
    if [ -n "${session:-}" ]; then
        __nidus_fmt ps1_screen_indicator zero_width
        __nidus_inline_echo "*${session#*.}*"
        __nidus_reset_fmt zero_width
        return 0
    fi
    return 1
}

function __nidus_ps1_git_indicator {

    if type git &>/dev/null; then
        gbr="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
        if [ -n "$gbr" ]; then
            if [ "$gbr" = HEAD ]; then
                gbr="$(git rev-parse HEAD 2>/dev/null | head -c8)"
            fi
            groot="$(basename ///$(git rev-parse --show-toplevel) 2>/dev/null)"

            if [ "${#groot}" -gt 12 ]; then
                groot="${groot: 0:8}\`${groot: -3:3}"
            fi
            __nidus_fmt ps1_git_indicator zero_width
            if [ "$groot" = / ]; then
                __nidus_inline_echo "(.git)"
            else
                __nidus_inline_echo "$groot[$gbr]"
            fi
            __nidus_reset_fmt zero_width
            return 0
        fi
    fi
    return 1
}

function __nidus_ps1_permission {

    local r w x display=no
    if test -r .; then
        r="$(__nidus_fmt ps1_perm_good)r$(__nidus_reset_fmt)"
    else
        r="$(__nidus_fmt ps1_perm_bad)-$(__nidus_reset_fmt)"
        display=yes
    fi
    if test -w .; then
        w="$(__nidus_fmt ps1_perm_good)w$(__nidus_reset_fmt)"
    else
        w="$(__nidus_fmt ps1_perm_bad)-$(__nidus_reset_fmt)"
        display=yes
    fi
    if test -x .; then
        x="$(__nidus_fmt ps1_perm_good)x$(__nidus_reset_fmt)"
    else
        x="$(__nidus_fmt ps1_perm_bad)-$(__nidus_reset_fmt)"
    fi

    if [ "$display" = yes ]; then
        __nidus_inline_echo "$r$w$x"
        __nidus_reset_fmt zero_width
        return 0
    fi
    return 1
}

function __nidus_ps1_cwd {
    local hook=nidus_hook_ps1_cwd

    __nidus_fmt ps1_cwd zero_width
    if [ "$(type -t "$hook")" = function ]; then
        __nidus_inline_echo "$($hook "$1")"
    else
        __nidus_inline_echo "$1"
    fi
    __nidus_reset_fmt zero_width
    return 0
}

function __nidus_ps1_physical_cwd {
    local physical_cwd="$(pwd -P)"
    if [ "$physical_cwd" != "$(pwd)" ]; then
        __nidus_fmt ps1_physical_cwd zero_width
        __nidus_inline_echo "(Physical: $physical_cwd)"
        __nidus_reset_fmt zero_width
        return 0
    fi
    return 1
}

function __nidus_ps1_label {
  local label=${NIDUS_PS1_LABEL:-}
  if [ -n "$label" ]; then
      __nidus_fmt ps1_label zero_width
      __nidus_inline_echo ":${label}:"
      __nidus_reset_fmt zero_width
      return 0
  fi
  return 1
}

function __nidus_ps1_dollar_hash {
    __nidus_fmt ps1_dollar_hash zero_width
    __nidus_inline_echo "$1"
    __nidus_reset_fmt zero_width
}

function __nidus_ps1_space {
    __nidus_inline_echo ' '
}

function __nidus_ps1_newline {
    builtin echo
}

function __nidus_ps1_pinned_vars {
    local var_name
    local IFS=:
    for var_name in $__NIDUS_PINNED_VARS; do
        [ -z "$var_name" ] && continue
        __nidus_fmt pinned_key
        __nidus_inline_echo "$var_name"
        __nidus_reset_fmt

        __nidus_fmt pinned_punct
        __nidus_inline_echo "='"
        __nidus_reset_fmt

        __nidus_fmt pinned_value
        eval "__nidus_inline_echo \"\$${var_name}\""
        __nidus_reset_fmt

        __nidus_fmt pinned_punct
        __nidus_inline_echo "'"
        __nidus_reset_fmt

        __nidus_ps1_newline
    done
}

PS1='$(
    (
        __nidus_ps1_user_host         && __nidus_ps1_space
        __nidus_ps1_chroot            && __nidus_ps1_space
        __nidus_ps1_bg_indicator "\j" && __nidus_ps1_space
        __nidus_ps1_shlvl_indicator   && __nidus_ps1_space
        __nidus_ps1_screen_indicator  && __nidus_ps1_space
        __nidus_ps1_git_indicator     && __nidus_ps1_space
        __nidus_ps1_permission        && __nidus_ps1_space
        __nidus_ps1_cwd "\w"
        __nidus_ps1_newline
    ) | (
        __nidus_prefix_line_if_labeled "$NIDUS_FMT_PS1_HEAD_PREFIX"
    )
    (
        __nidus_ps1_pinned_vars
        __nidus_ps1_physical_cwd && __nidus_ps1_newline
    ) | (
        __nidus_prefix_line_if_labeled "$NIDUS_FMT_PS1_MID_PREFIX"
    )
    (
        __nidus_ps1_label            && __nidus_ps1_space
        __nidus_ps1_dollar_hash "\$" && __nidus_ps1_space
        __nidus_ps1_non_default_ifs  && __nidus_ps1_space
    ) | (
        __nidus_prefix_line_if_labeled "$NIDUS_FMT_PS1_TAIL_PREFIX"
    )
)'

function __nidus_do_before_command {

    # This assignment must be done first
    __NIDUS_COMMAND_ERRNO="${PIPESTATUS[@]}"

    local IFS=$' \t\n'
    if [ "$BASH_COMMAND" = __nidus_do_after_command ]; then
        return
    fi
    let '__NIDUS_COMMAND_SNO += 1'

    if [ "${NIDUS_ENABLE_CMD_EXPANSION:-yes}" = no ]; then
        return
    fi

    read -r -a cmd_tokens <<< "$BASH_COMMAND"
    case "$(type -t "${cmd_tokens[0]}")" in
        file|alias)
            # even we got alias here, it has already been resolved
            cmd_tokens[0]=$(type -P "${cmd_tokens[0]}")
            ;;
        builtin)
            cmd_tokens[0]="builtin ${cmd_tokens[0]}"
            ;;
        function)
            cmd_tokens[0]="function ${cmd_tokens[0]}"
            ;;
        keyword)
            cmd_tokens[0]="keyword ${cmd_tokens[0]}"
            ;;
        *)
            ;;
    esac

    local sink=${NIDUS_CMD_EXPANSION_SINK:-&2}
    local proxy_fd=${NIDUS_CMD_EXPANSION_SINK_PROXY_FD:-99}
    local stat_str="[$__NIDUS_COMMAND_SNO] -> ${cmd_tokens[@]} ($(date +'%m/%d/%Y %H:%M:%S'))"
    local safe_stat_str="$(cat -v <<< "$stat_str")"

    if [ -w "$sink" ]; then
        eval "exec $proxy_fd>>$sink"
    else
        eval "exec $proxy_fd>$sink"
    fi

    __nidus_force_newline

    [ -t "$proxy_fd" ] && eval "__nidus_fmt cmd_expansions >&$proxy_fd"
    eval '__nidus_inline_echo "$safe_stat_str" '" >&$proxy_fd"
    [ -t "$proxy_fd" ] && eval "__nidus_reset_fmt >&$proxy_fd"
    eval "__nidus_ps1_newline >&$proxy_fd"

    eval "exec $proxy_fd>&-"

    # Many bash command completion scripts use unbound variables, i.e.,
    # dereference an undefined variable and use its fallback substution, which
    # is an empty string. Turning on this option (-u) is therefore going to be
    # break these scripts, which are in fact stable, fortunately.
    if [ "$__NIDUS_COMMAND_SNO" = 1 ] && [ "${NIDUS_REPORT_UNBOUND_VARIABLE:-yes}" = yes ]; then
        set -u
    fi
}

function __nidus_do_after_command {

    # At this point, since bash completion scripts are so widely used, it is
    # safe of assume that user leaves this option (-u) off by default, so that
    # command completion can work. Given this, the option is switched on/off
    # siliently, providing safer interactive variable substitution, in a not-
    # so-annoying way, hopefully.
    if [ "${NIDUS_REPORT_UNBOUND_VARIABLE:-yes}" = yes ]; then
        set +u
    fi

    local IFS=$' \t\n'
    local eno ts
    local ret=OK

    __nidus_force_newline

    if [ "$__NIDUS_COMMAND_SNO" -gt 0 ]; then
        __NIDUS_COMMAND_SNO=0

        if [ "${NIDUS_ENABLE_STATUS_LINE:-yes}" = no ]; then
            return
        fi

        ts=$(date +"%m/%d/%Y %H:%M:%S")
        for eno in $__NIDUS_COMMAND_ERRNO; do
            if [ $eno -ne 0 ]; then
                ret=ERR
                break
            fi
        done

        __nidus_reset_fmt
        [ "${NIDUS_THICK_SEPARATOR:-no}" = yes ] || __nidus_fmt underline
        if [ $ret = OK ]; then
            __nidus_fmt status_ok
        else
            __nidus_fmt status_error
        fi

        if [ $ret = OK ]; then
            printf "%${COLUMNS}s\n" "$ts [ Status OK ]"
        else
            printf "%${COLUMNS}s\n" "$ts [ Exception code $__NIDUS_COMMAND_ERRNO ]"
        fi

        if [ "${NIDUS_THICK_SEPARATOR:-no}" = yes ]; then
            printf "%${COLUMNS}s\n" "" | tr " " "${NIDUS_THICK_SEPARATOR_CHAR:-~}"
        fi
        __nidus_reset_fmt
    fi
}
