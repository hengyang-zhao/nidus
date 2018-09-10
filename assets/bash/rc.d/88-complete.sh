__nidus_complete()
{
    local cur opts prev

    cur="${COMP_WORDS[COMP_CWORD]}"

    case "${#COMP_WORDS[@]}" in
        2)
            opts="info reinstall banner clean"
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            ;;
        3)
            prev="${COMP_WORDS[COMP_CWORD-1]}"
            if [ "$prev" = banner ]; then
                opts="on off"
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            fi
            ;;
        *)
            COMPREPLY=()
    esac
}
complete -F __nidus_complete nidus
