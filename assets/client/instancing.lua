RePCore = nil

RegisterNetEvent('RePCore:Client:OnPlayerLoaded')
AddEventHandler('RePCore:Client:OnPlayerLoaded', function()
	TriggerEvent("RePCore:GetObject", function(obj) RePCore = obj end) 
end)

local inInstance = false
local playersInInstance = {}

RegisterNetEvent('assets:client:confirmInstancedPlayers')
AddEventHandler('assets:client:confirmInstancedPlayers', function(playersTable)
    playersInInstance = playersTable
end)

switchInstance = function(inside)
    TriggerServerEvent('assets:server:requestInstancedPlayers')
    inInstance = inside
    if inInstance == true then 
        NetworkSetFriendlyFireOption(false) 
        SetCanAttackFriendly(PlayerPedId(), false, false) 
        exports['pma-voice']:toggleMute()
    else 
        NetworkSetFriendlyFireOption(true) 
        SetCanAttackFriendly(PlayerPedId(), true, true) 
        NetworkConcealPlayer(PlayerPedId(), false, false) 
        exports['pma-voice']:toggleMute()
    end
end
exports('switchInstance', switchInstance)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if inInstance then
            for _, otherPlayers in pairs(playersInInstance) do
                local otherPlayersClient = GetPlayerFromServerId(otherPlayers)
                if PlayerId() ~= otherPlayersClient then
                    local otherPlayersPeds = GetPlayerPed(otherPlayersClient)
                    if otherPlayersPeds ~= PlayerPedId() then
                        SetEntityVisible(otherPlayersPeds, false, false)
                        SetEntityNoCollisionEntity(otherPlayersPeds, PlayerPedId(), true)
                        NetworkConcealPlayer(otherPlayersPeds, true, true)
                    end
                end
            end
        else
            Citizen.Wait(2000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if inInstance then
            TriggerServerEvent('assets:server:requestInstancedPlayers')
            -- DEBUGGING PURPOSES
            -- for _, otherPlayers in pairs(playersInInstance) do
            --     print('ALL:')
            --     print('TABLEKEYS: ' .. _)
            --     print('TABLEVALUES: ' .. otherPlayers)
            --     print('PLAYERID: ' .. PlayerId())
            -- end
        end
        Citizen.Wait(2500)
    end
end)
