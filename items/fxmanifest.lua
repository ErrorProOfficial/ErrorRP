fx_version 'cerulean'
games {'gta5'}

description 'Example resource'
version '1.0.0'

client_scripts {
 'config.lua',
 'client/drugs.lua',
 'client/fireworks.lua', 
 'client/binoculars.lua',  
 'client/client.lua',
}
   
server_scripts {
 'config.lua',
 'server/server.lua'
}  