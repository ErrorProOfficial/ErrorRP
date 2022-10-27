fx_version 'cerulean'
games {'gta5'}

description 'Example resource'
version '1.0.0'

ui_page "html/index.html"

--data_file 'HANDLING_FILE' 'misc/handling.meta'	-- turbo
data_file 'FIVEM_LOVES_YOU_4B38E96CC036038F' 'misc/events.meta'
data_file 'FIVEM_LOVES_YOU_341B23A2F0E0F131' 'misc/popgroups.ymt'

client_scripts {
 'config.lua',
 'client/anims.lua',
 'client/holster.lua',
 'client/seatbelt.lua',
 'client/props.lua',
 'client/engine.lua',
 --'client/vehpush.lua', Трябва да се види защо когато се стартне дава грешки
 'client/client.lua',
 'client/teleports.lua',
 'client/loops.lua',
 'client/instancing.lua'
 --'client/refreshskin.lua'
}

server_scripts {
 'config.lua',
 'server/server.lua',
 'server/instancing.lua'
}

files {
 "html/index.html",
 'misc/events.meta',
-- 'misc/handling.meta',	-- turbo
 'misc/popgroups.ymt',
 'misc/relationships.dat',
--  'misc/visualsettings.dat',	-- turbo
}

exports {
 'AddBlipToCoords',
 'AddProp',
 'AddPropWithAnim',
 'RemoveProp',
 'GetPropStatus',
 'RequestAnimationDict',
 'RequestModelHash',
}