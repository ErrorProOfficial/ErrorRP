fx_version 'cerulean'
games {'gta5'}

description 'Example resource'
version '1.0.0'

ui_page "html/index.html"

server_scripts {
	"server/main.lua"
}

client_scripts {
	"client/main.lua"
}

files {
	"html/*"
}

