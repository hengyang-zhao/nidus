function __source_site_profile {
    local IFS=$' \t\n'
    local profile
    local profile_dir="$HOME/.nidus_site_config/bash/profile"

    for profile in "$profile_dir"/*.sh ; do
        if [ -r "$profile" ]; then
            source "$profile"
        fi
    done
}
__source_site_profile
unset -f __source_site_profile

