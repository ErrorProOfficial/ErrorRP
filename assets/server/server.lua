RePCore = nil

TriggerEvent('RePCore:GetObject', function(obj) RePCore = obj end)

RegisterServerEvent('assets:server:tackle:player')
AddEventHandler('assets:server:tackle:player', function(playerId)
    TriggerClientEvent("assets:client:get:tackeled", playerId)
end)

RegisterServerEvent('assets:server:display:text')
AddEventHandler('assets:server:display:text', function(Text)
	TriggerClientEvent('assets:client:me:show', -1, Text, source)
end)

RegisterServerEvent('assets:server:drop')
AddEventHandler('assets:server:drop', function()
	--if not RePCore.Functions.HasPermission(source, 'admin') then
		TriggerEvent("logs:server:SendLog", "anticheat", "Nui Devtools", "red", "**".. GetPlayerName(source).. "** Tryd opening devtools.")
		DropPlayer(source, 'Do not open DevTools.')
	--end
end)

RePCore.Commands.Add("id", "Какво е моето ID?", {}, false, function(source, args)
    TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "ID: "..source)
end, 'user')



RePCore.Commands.Add("me", "Нещо което не можете да кажете", {}, false, function(source, args)
  local Text = table.concat(args, ' ')
  TriggerClientEvent('assets:client:me:show', -1, Text, source)
end, 'user')

RePCore.Commands.Add("ме", "Нещо което не можете да кажете", {}, false, function(source, args)
	local Text = table.concat(args, ' ')
	TriggerClientEvent('assets:client:me:show', -1, Text, source)
  end, 'user')

RegisterServerEvent("kickForBeingAnAFKDouchebag")
AddEventHandler("kickForBeingAnAFKDouchebag", function()
	DropPlayer(source, "Стоя AFK прекалено дълго.")
end)

RegisterServerEvent('assets:server:toggleWaterfall')
AddEventHandler('assets:server:toggleWaterfall', function(truefalse)
    waterfallEnabled = truefalse
end)

-- Citizen.CreateThread(function()
--     while true do 
--         Citizen.Wait(60 * 1000)
--         TriggerClientEvent('assets:client:updateDensity', -1)
--     end
-- end)

local waterfallEnabled = true

Citizen.CreateThread(function()
    Citizen.Wait((1000 * 60 * 3))
    while true do 
        Citizen.Wait(40000)
        if waterfallEnabled then
            print('Running Waterfall')
            local queue = exports['connectqueue']:GetQueueExports()
            local queuesize = queue.GetSize()
            local currentSlots = GetConvarInt('sv_maxclients', 64)
            if currentSlots == 64 then
                waterfallEnabled = false
            end
            if queuesize >= 1 and queuesize < 10 then
                local newSlots = tonumber(tonumber(GetConvarInt('sv_maxclients', 64)) + tonumber(1))
                changeSlots(newSlots)
            elseif queuesize >= 2 and queuesize < 10 then
                local newSlots = tonumber(tonumber(GetConvarInt('sv_maxclients', 64)) + tonumber(2))
                changeSlots(newSlots)
            elseif queuesize >= 3 and queuesize < 10 then
                local newSlots = tonumber(tonumber(GetConvarInt('sv_maxclients', 64)) + tonumber(3))
                changeSlots(newSlots)
            elseif queuesize >= 10 then
                local newSlots = tonumber(tonumber(GetConvarInt('sv_maxclients', 64)) + tonumber(10))
                changeSlots(newSlots)
            end
        end
    end
end)

changeSlots = function(newSlots)
    local currentSlots = GetConvarInt('sv_maxclients', 64)
    SetConvar('sv_maxclients', newSlots)
    local changedSlots = GetConvarInt('sv_maxclients', 64)
    print('Automatically changed slots from ' .. currentSlots .. ' to ' .. changedSlots .. ' due to big queue.')
end

RePCore.Commands.Add("closeeye", "Затвори трето око.", {}, false, function(source, args)
	TriggerClientEvent('target:client:closeTarget', source)
end, "user")

RegisterServerEvent('log')
AddEventHandler('log', function(weapon)
	local src = GetPlayerDetails(source)
	TriggerEvent("logs:server:SendLog", "shops", "Използва U ", "green", "**"..GetPlayerName(src) )
end)