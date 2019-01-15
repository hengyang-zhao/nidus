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
