fx_version 'cerulean'
games {'gta5'}

description 'Example resource'
version '1.0.0'

ui_page "html/index.html"

client_scripts {
  'config.lua',
  'client/client.lua',
}

server_scripts {
 'config.lua',
 'server/server.lua'
}

exports {
  'IsNearAnyBank',
  'IsNearAtm',
}

files {
 "html/index.html",
 "html/js/script.js",
 "html/css/style.css",
 "html/img/logo.png"
}