GLOBAL_PED = PlayerPedId()

RegisterNetEvent('TurboCore:Client:OnPlayerLoaded')
AddEventHandler('TurboCore:Client:OnPlayerLoaded', function()
	LoggedIn = true
end)

AddEventHandler('turbo-core:client:receivePlayerPedId', function(receivedPed)
    GLOBAL_PED = receivedPed
end)

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end
		enum.destructor = nil
		enum.handle = nil
	end
}
   
-- // Loops \\ --

-- ViewCam Set

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(4)
--         if LoggedIn then
--             if GetFollowPedCamViewMode() == 2 then
--                 SetFollowPedCamViewMode(4)
--                 SetFollowVehicleCamViewMode(4)
--             end
--             Citizen.Wait(1000)
--         end
--     end
-- end)

-- local players = 0
-- local density = 1.0

-- RegisterNetEvent('turbo-assets:client:updateDensity')
-- AddEventHandler('turbo-assets:client:updateDensity', function()
--     players = #GetActivePlayers()
--     if players <= 10 then
--         density = 1.0
--     elseif players <= 20 then
--         density = 0.9
--     elseif players <= 30 then
--         density = 0.8
--     elseif players <= 40 then
--         density = 0.7
--     elseif players <= 50 then
--         density = 0.6
--     elseif players <= 60 then
--         density = 0.5
--     elseif players <= 70 then
--         density = 0.4
--     elseif players <= 80 then
--         density = 0.3
--     elseif players <= 90 then
--         density = 0.2
--     elseif players <= 100 then
--         density = 0.1
--     end
-- end)

-- Map Peds
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        WaterOverrideSetStrength(0.4)	-- was 1.0
        SetVehicleDensityMultiplierThisFrame(0.5)
        SetPedDensityMultiplierThisFrame(0.5)
        SetParkedVehicleDensityMultiplierThisFrame(0.3)
        SetScenarioPedDensityMultiplierThisFrame(0.01, 0.01)
    end
end)

-- Air Control

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsPedInAnyVehicle(GLOBAL_PED) then
                local Vehicle = GetVehiclePedIsIn(GLOBAL_PED, true)
                if DoesEntityExist(Vehicle) and not IsEntityDead(Vehicle) then
                    local Model = GetEntityModel(Vehicle)
                    if Model ~= nil then
                        if not IsThisModelABoat(Model) and not IsThisModelAHeli(Model) and not IsThisModelAPlane(Model) and IsEntityInAir(Model) then
                            DisableControlAction(0, 59)
                            DisableControlAction(0, 60)
                        end
                    end
                end
            else
                Citizen.Wait(5000)
            end
        end
    end
end)

-- Tackle 

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(5)
        if LoggedIn then
            if not IsPedInAnyVehicle(GLOBAL_PED, false) and GetEntitySpeed(GLOBAL_PED) > 2.5 then
                if IsControlJustPressed(1, Config.Keys["G"]) then
                    local Player, PlayerDist = TurboCore.Functions.GetClosestPlayer()
                    if PlayerDist ~= -1 and PlayerDist < 2 then
                        CanTackle = false
                        TriggerServerEvent("turbo-assets:server:tackle:player", GetPlayerServerId(Player))
                        TackleAnim()
                    end
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
end)

-- Blacklist

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        for _, sctyp in next, Config.BlacklistedScenarios['TYPES'] do
            SetScenarioTypeEnabled(sctyp, false)
        end
        for _, scgrp in next, Config.BlacklistedScenarios['GROUPS'] do
            SetScenarioGroupEnabled(scgrp, false)
        end
        for _, carmdl in next, Config.BlacklistedVehs do
            SetVehicleModelIsSuppressed(carmdl, true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        -- Hud Components
        HideHudComponentThisFrame(1)
        HideHudComponentThisFrame(2)
        HideHudComponentThisFrame(3)
        HideHudComponentThisFrame(4)
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(13)
        HideHudComponentThisFrame(14)
        HideHudComponentThisFrame(17)
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        HideHudComponentThisFrame(21)
        HideHudComponentThisFrame(22)
        DisplayAmmoThisFrame(true)
        -- Police Disable
        for i = 1, 12 do
            EnableDispatchService(i, false)
        end
        SetPlayerWantedLevel(PlayerId(), 0, false)
        SetPlayerWantedLevelNow(PlayerId(), false)
        SetPlayerWantedLevelNoDrop(PlayerId(), 0, false)
        SetDispatchCopsForPlayer(PlayerId(), false)
        SetAudioFlag("PoliceScannerDisabled", true)	
        -- Disable Vehicle Rewards
        DisablePlayerVehicleRewards(PlayerId())
        RemoveVehiclesFromGeneratorsInArea(441.8465 - 500.0, -987.99 - 500.0, 30.68 -500.0, 441.8465 + 500.0, -987.99 + 500.0, 30.68 + 500.0)
    end
end) 

-- Stop Melee When Weapon is in hand
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        if GetSelectedPedWeapon(GLOBAL_PED) ~= GetHashKey("WEAPON_UNARMED") then
            if IsPedArmed(GLOBAL_PED, 6) or IsPlayerFreeAiming(PlayerId()) then
                DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)
            else 
                Citizen.Wait(1000)
            end
        else 
            Citizen.Wait(1000)
        end
    end
end)

-- Disable Weapon Pickup
setWeaponDrops = function()
	local handle, ped = FindFirstPed()
	local finished = false

	repeat
		if not IsEntityDead(ped) then
			SetPedDropsWeaponsWhenDead(ped, false)
		end
		finished, ped = FindNextPed(handle)
	until not finished

	EndFindPed(handle)
end

Citizen.CreateThread(function()
    while true do    
        Citizen.Wait(1000)
        setWeaponDrops()
    end
end)


Citizen.CreateThread(function()
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_HILLBILLY"), GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_BALLAS"), GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MEXICAN"), GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_FAMILY"), GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MARABUNTE"), GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_SALVA"), GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(1, GetHashKey("GANG_1"), GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(1, GetHashKey("GANG_2"), GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(1, GetHashKey("GANG_9"), GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(1, GetHashKey("GANG_10"), GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(1, GetHashKey("FIREMAN"), GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(1, GetHashKey("MEDIC"), GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(1, GetHashKey("COP"), GetHashKey('PLAYER'))
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        for k, v in pairs(Config.RemoveObjects) do
            local Entity = GetClosestObjectOfType(Config.RemoveObjects[k]['X'], Config.RemoveObjects[k]['Y'], Config.RemoveObjects[k]['Z'], 2.0, GetHashKey(Config.RemoveObjects[k]['Model']), false, false, false)
            SetEntityAsMissionEntity(Entity, 1, 1)
            DeleteObject(Entity)
            SetEntityAsNoLongerNeeded(Entity)
        end
        Citizen.Wait(5000)
    end
end)

-- Remove Blacklist Vehs
-- Citizen.CreateThread(function()
--     while true do
--         for veh in EnumerateVehicles() do
--             if Config.BlacklistedVehs[GetEntityModel(veh)] then
--                 DeleteEntity(veh)
--             end
--         end
--         Citizen.Wait(250)
--     end
-- end)

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
        local next = true
        repeat
        coroutine.yield(id)
        next, id = moveFunc(iter)
        until not next
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end
   