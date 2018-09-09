__nidus_complete()
{
    if [ "${#COMP_WORDS[@]}" != 2 ]; then
        return 0
    fi

    local cur opts

    cur="${COMP_WORDS[COMP_CWORD]}"
    opts="info reinstall"

    COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
}
complete -F __nidus_complete nidus
