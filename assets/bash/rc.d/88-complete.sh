__nidus_complete()
{
    local cur opts subcmd

    cur="${COMP_WORDS[COMP_CWORD]}"

    case "${#COMP_WORDS[@]}" in
        2)
            opts="banner clean info reinstall update"
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            ;;
        3)
            subcmd="${COMP_WORDS[COMP_CWORD-1]}"
            case "$subcmd" in
                banner)
                    opts="on off"
                    COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                    ;;
                reinstall)
                    opts="--overwrite-all --no-backup --force-legacy"
                    COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            ;;
        *)
            subcmd="${COMP_WORDS[1]}"
            case "$subcmd" in
                reinstall)
                    opts="--overwrite-all --no-backup --force-legacy"
                    COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            ;;
    esac
}
complete -F __nidus_complete nidus

__nidus_list_hook_labels()
{
    (
        declare -F
    ) | (
        regex='^declare -f nidus_hook_label_(.*)$'
        while read line; do
            if [[ "$line" =~ $regex ]]; then
                echo "${BASH_REMATCH[1]}"
            fi
        done
    )
}

__nidus_infinite_bash_complete()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"

    case "${#COMP_WORDS[@]}" in
        2)
            local opts="$(__nidus_list_hook_labels)"
            COMPREPLY=( $(compgen -W "${opts[*]}" -- "${cur}") )
            ;;
        *)
            COMPREPLY=()
    esac
}
complete -F __nidus_infinite_bash_complete __nidus_infinite_bash
complete -F __nidus_infinite_bash_complete lab
complete -F __nidus_infinite_bash_complete bashtrap
