function __source_site_rc {
    local IFS=$' \t\n'
    local rc_file
    local rc_dir="$HOME/.nidus_site_config/bash/rc"

    for rc_file in "$rc_dir"/*.sh ; do
        if [ -r "$rc_file" ]; then
            source "$rc_file"
        fi
    done
}
__source_site_rc
unset -f __source_site_rc

