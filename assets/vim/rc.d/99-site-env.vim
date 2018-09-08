for rc in split(globpath("$HOME/.nidus_site_config/vim/", "*.vim"), '\n')
    execute "source" rc
endfor

