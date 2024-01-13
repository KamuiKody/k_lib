fx_version 'cerulean'
game 'gta5'

name 'k_lib'
author 'kamui kody'
description 'A library of commonly used functions. A Scaleform wrapper and soon to be Network Scene wrapper as well.   "Created Using Kamui Kody\'s Boilerplate"'

-- ui_page 'html/index.html'

shared_scripts {
   '@qb-core/shared/locale.lua',
   'locales/en.lua',
   'locales/*.lua',
   'shared/*.lua'
}

client_scripts {
    'client/*.lua',
    'client/**/*.lua',
}

server_scripts {
    'server/*.lua'
}

lua54 'yes'
