if [ -z "${__nidus_bash_profile:-}" ]; then
    cat $HOME/.nidus_site_config/nidus/assets/bash/banners/profile_not_sourced.txt
elif [ "${__NIDUS_BANNER_ENABLED:-no}" = yes ]; then
    cat $HOME/.nidus_site_config/nidus/assets/bash/banners/install_complete.txt
fi

