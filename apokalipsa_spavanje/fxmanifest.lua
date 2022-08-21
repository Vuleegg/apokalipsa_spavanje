fx_version 'cerulean'
games { 'gta5' }
ui_page 'html/index.html'
-- Script Information
author 'JavaHampus'
description 'A script that kicks a player if AFK for a long time.'
version '1.0.0'

client_scripts {
    'client.lua',
    'config.lua'
}
server_scripts{ 
    "@mysql-async/lib/MySQL.lua",
    'config.lua',
    'server.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/reset.css',
    'html/listener.js'
}