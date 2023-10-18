game 'gta5'
fx_version 'cerulean'
author 'atiysu & frosty'
description 'aty_pvphud'
lua54 'yes'

client_scripts{
    'client/client.lua'
}
server_scripts{
    'server/server.lua',
    '@oxmysql/lib/MySQL.lua',

}
ui_page 'ui/index.html'

files{
    'ui/**/*.*',
    'ui/*.*',
}