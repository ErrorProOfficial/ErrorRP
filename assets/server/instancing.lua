RePCore = nil

TriggerEvent('RePCore:GetObject', function(obj) RePCore = obj end)

local playersInInstance = {}

RegisterServerEvent('assets:server:addToInstance')
AddEventHandler('assets:server:addToInstance', function(gameID)
    table.insert(playersInInstance, gameID)
end)

RegisterServerEvent('assets:server:removeFromInstance')
AddEventHandler('assets:server:removeFromInstance', function(gameID)
    for _, players in pairs(playersInInstance) do
        if players == gameID then
            playersInInstance[_] = nil
            table.remove(playersInInstance, _)
        end
    end
end)

RegisterServerEvent('assets:server:requestInstancedPlayers')
AddEventHandler('assets:server:requestInstancedPlayers', function()
    TriggerClientEvent('assets:client:confirmInstancedPlayers', -1, playersInInstance)
end)

-- DEBUGGING PURPOSES
-- Citizen.CreateThread(function()
--     while true do
--         for _, v in pairs(playersInInstance) do
--             print('ALL:')
--             print('KEYS: ' .. _)
--             print('VALUES: ' .. v)
--         end
--         Citizen.Wait(2500)
--     end
-- end)
