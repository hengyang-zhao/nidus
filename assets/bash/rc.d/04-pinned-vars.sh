__NIDUS_PINNED_VARS=

function nidus_define_pinned {
    local var_name="$1"
    local var_value="${2:-}"
    eval "$var_name='$var_value'"

    local IFS=:
    local v
    for v in $__NIDUS_PINNED_VARS; do
        [ "$v" = "$var_name" ] && return
    done
    __NIDUS_PINNED_VARS="$__NIDUS_PINNED_VARS:$var_name"
}

function nidus_update_pinned {
    __NIDUS_PINNED_VARS=
    if [ -z "${NIDUS_PS1_LABEL:-}" ]; then
        return
    fi

    local hook="nidus_hook_label_$NIDUS_PS1_LABEL"
    [ "$(type -t "$hook")" = function ] && "$hook" "${NIDUS_PS1_LABEL}"
}

