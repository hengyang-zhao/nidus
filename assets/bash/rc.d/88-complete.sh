__nidus_complete()
{
    local cur opts prev

    cur="${COMP_WORDS[COMP_CWORD]}"

    case "${#COMP_WORDS[@]}" in
        2)
            opts="banner clean info reinstall update"
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            ;;
        3)
            prev="${COMP_WORDS[COMP_CWORD-1]}"
            case "$prev" in
                banner)
                    opts="on off"
                    COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                    ;;
                reinstall)
                    opts="--overwrite-all --no-backup"
                    COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                    ;;
                *)
                    COMPREPLY=()
            esac
            ;;
        *)
            COMPREPLY=()
    esac
}
complete -F __nidus_complete nidus
