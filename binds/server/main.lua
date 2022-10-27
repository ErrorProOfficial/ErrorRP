RePCore = nil

TriggerEvent('RePCore:GetObject', function(obj) RePCore = obj end)

-- Code

RePCore.Commands.Add("binds", "Отваряне на меню за бързи клавиши", {}, false, function(source, args)
	TriggerClientEvent("binds:client:openUI", source)
end)

RegisterServerEvent('binds:server:setKeyMeta')
AddEventHandler('binds:server:setKeyMeta', function(keyMeta)
    local src = source
    local Player = RePCore.Functions.GetPlayer(src)
    Player.Functions.SetMetaData("commandbinds", keyMeta)
end)