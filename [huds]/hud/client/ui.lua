local speed = 0.0
local seatbeltOn = false
local cruiseOn = false

local bleedingPercentage = 0
local hunger = 100
local thirst = 100
local level = 100
local oxygen = 100

function CalculateTimeToDisplay()
	hour = GetClockHours()
    minute = GetClockMinutes()
    
    local obj = {}
    
	if minute <= 9 then
		minute = "0" .. minute
    end
    
	if hour <= 9 then
		hour = "0" .. hour
    end
    
    obj.hour = hour
    obj.minute = minute

    return obj
end

local toggleHud = true

GLOBAL_PED = PlayerPedId()

AddEventHandler('qb-core:client:receivePlayerPedId', function(receivedPed)
    GLOBAL_PED = receivedPed
end)

RegisterNetEvent('hud:toggleHud')
AddEventHandler('hud:toggleHud', function(toggleHud)
    QBHud.Show = toggleHud
end)

-- RegisterNetEvent("TurboCore:Client:OnPlayerLoaded")
-- AddEventHandler("TurboCore:Client:OnPlayerLoaded", function()
--     Citizen.SetTimeout(1750, function()
--         TurboCore.Functions.GetPlayerData(function(PlayerData)
--             if PlayerData ~= nil and PlayerData.money ~= nil then
--                 CashAmount = PlayerData.money["cash"]
--                 hunger, thirst, stress = PlayerData.metadata["hunger"], PlayerData.metadata["thirst"], PlayerData.metadata["stress"]
--             end
--         end)
--         ShowHud = true
--         isLoggedIn = true
--     end)
-- end)

RegisterNetEvent("hud:client:update:needs")
AddEventHandler("hud:client:update:needs", function(NewHunger, NewThirst)
    hunger, thirst = newHunger, newThirst
end)

RegisterNetEvent('hud:client:update:stress')
AddEventHandler('hud:client:update:stress', function(NewStress)
    stress = newStress
end)

Citizen.CreateThread(function()
    Citizen.Wait(2000)
    while true do 
        if TurboCore ~= nil and isLoggedIn and QBHud.Show then
            TurboCore.Functions.GetPlayerData(function(PlayerData)
                if PlayerData ~= nil and PlayerData.money ~= nil then
                    CashAmount = PlayerData.money["cash"]
                    hunger, thirst, stress = PlayerData.metadata["hunger"], PlayerData.metadata["thirst"], PlayerData.metadata["stress"]
                end
            end)
            speed = GetEntitySpeed(GetVehiclePedIsIn(GLOBAL_PED, false)) * 3.6
            local Plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GLOBAL_PED))
            local pos = GetEntityCoords(GLOBAL_PED)
            local time = CalculateTimeToDisplay()
            local street1, street2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
            local current_zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))
            local fuel = exports['fuel']:GetFuelLevel(Plate)
            local engine = GetVehicleEngineHealth(GetVehiclePedIsIn(GLOBAL_PED))
            local inWater = IsPedSwimmingUnderWater(GLOBAL_PED)
            if inWater == 1 then oxygen = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 3 else oxygen = 100 end
            if oxygen < 0 then oxygen = 1 end
            if hunger < 0 then hunger = 0 end
            if thirst < 0 then thirst = 0 end
            if stress < 0 then stress = 0 end
            SendNUIMessage({
                action = "hudtick",
                show = IsPauseMenuActive(),
                health = GetEntityHealth(GLOBAL_PED),
                armor = GetPedArmour(GLOBAL_PED),
                thirst = thirst,
                hunger = hunger,
                stress = stress,
                seatbelt = seatbeltOn,
                talking = NetworkIsPlayerTalking(PlayerId()),
                -- onRadio = exports["rp-radio"]:IsRadioOn(),
               -- radio = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'radio:talking'),
               -- talking = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'voip:talking'),
                --bleeding = bleedingPercentage,
                -- direction = GetDirectionText(GetEntityHeading(GLOBAL_PED)),
                street1 = GetStreetNameFromHashKey(street1),
                street2 = GetStreetNameFromHashKey(street2),
                area_zone = current_zone,
                speed = math.ceil(speed),
                fuel = fuel,
                on = on,
                nivel = nivel,
                activo = activo,
                time = time,
                togglehud = toggleHud,
                oxygen = oxygen
            })
            Citizen.Wait(750)
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if TurboCore ~= nil and isLoggedIn and QBHud.Show then
            if IsPedInAnyVehicle(GLOBAL_PED, false) then
                speed = GetEntitySpeed(GetVehiclePedIsIn(GLOBAL_PED, false)) * 3.6
                
                if speed >= QBStress.MinimumSpeed then
                    TriggerServerEvent('hud:server:gain:stress', math.random(1, 2))
                end
            end
        end
        Citizen.Wait(20000)
    end
end)

local radarActive = false
Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1000)
        if IsPedInAnyVehicle(GLOBAL_PED) and isLoggedIn and QBHud.Show then
            DisplayRadar(true)
            SendNUIMessage({
                action = "car",
                show = true,
            })
            radarActive = true
        else
            DisplayRadar(false)
            SendNUIMessage({
                action = "car",
                show = false,
            })
            seatbeltOn = false
            cruiseOn = false

            SendNUIMessage({
                action = "seatbelt",
                seatbelt = seatbeltOn,
            })

            SendNUIMessage({
                action = "cruise",
                cruise = cruiseOn,
            })
            radarActive = false
        end
    end
end)

RegisterNetEvent("hud:client:UpdateNeeds")
AddEventHandler("hud:client:UpdateNeeds", function(newHunger, newThirst)
    hunger = newHunger
    thirst = newThirst
end)

RegisterNetEvent("seatbelt:client:ToggleSeatbelt")
AddEventHandler("seatbelt:client:ToggleSeatbelt", function(toggle)
    if toggle == nil then
        seatbeltOn = not seatbeltOn
        SendNUIMessage({
            action = "seatbelt",
            seatbelt = seatbeltOn,
        })
    else
        seatbeltOn = toggle
        SendNUIMessage({
            action = "seatbelt",
            seatbelt = toggle,
        })
    end
end)

RegisterNetEvent('hud:client:ToggleHarness')
AddEventHandler('hud:client:ToggleHarness', function(toggle)
    SendNUIMessage({
        action = "harness",
        harness = toggle
    })
end)

RegisterNetEvent('hud:client:UpdateNitrous')
AddEventHandler('hud:client:UpdateNitrous', function(toggle, level, IsActive)
   --[[ SendNUIMessage({
        action = "nitrous",
        toggle = toggle,
        level = level,
        active = IsActive
    })]]
        on = toggle
        nivel = level
        activo = IsActive
end)

--[[RegisterNetEvent('hud:client:UpdateDrivingMeters')
AddEventHandler('hud:client:UpdateDrivingMeters', function(toggle, amount)
    SendNUIMessage({
        action = "UpdateDrivingMeters",
        amount = amount,
        toggle = toggle,
    })
end)]]

RegisterNetEvent('hud:client:UpdateVoiceProximity')
AddEventHandler('hud:client:UpdateVoiceProximity', function(Proximity)
    SendNUIMessage({
        action = 'UpdateProximity',
        proxmity = Proximity
    })
end)


--[[RegisterNetEvent('hud:client:ProximityActive')
AddEventHandler('hud:client:ProximityActive', function(active)
    SendNUIMessage({
        action = "talking",
        IsTalking = active
    })
end)

Citizen.CreateThread(function()
    while true do
        if isLoggedIn and QBHud.Show and TurboCore ~= nil then
            TurboCore.Functions.TriggerCallback('hospital:GetPlayerBleeding', function(playerBleeding)
                if playerBleeding == 0 then
                    bleedingPercentage = 0
                elseif playerBleeding == 1 then
                    bleedingPercentage = 25
                elseif playerBleeding == 2 then
                    bleedingPercentage = 50
                elseif playerBleeding == 3 then
                    bleedingPercentage = 75
                elseif playerBleeding == 4 then
                    bleedingPercentage = 100
                end
            end)
        end

        Citizen.Wait(2500)
    end
end)]]

local LastHeading = nil
local Rotating = "left"



--[[Citizen.CreateThread(function()
    while true do
        local ped = GLOBAL_PED
        local PlayerHeading = GetEntityHeading(ped)
        if LastHeading ~= nil then
            if PlayerHeading < LastHeading then
                Rotating = "right"
            elseif PlayerHeading > LastHeading then
                Rotating = "left"
            end
        end
        LastHeading = PlayerHeading
        SendNUIMessage({
            action = "UpdateCompass",
            heading = PlayerHeading,
            lookside = Rotating,
        })
        Citizen.Wait(6)
    end
end)

function GetDirectionText(heading)
    if ((heading >= 0 and heading < 45) or (heading >= 315 and heading < 360)) then
        return "Noord"
    elseif (heading >= 45 and heading < 135) then
        return "Oost"
    elseif (heading >=135 and heading < 225) then
        return "Zuid"
    elseif (heading >= 225 and heading < 315) then
        return "West"
    end
end--

posX = -0.01
posY = 0.00-- 0.0152

width = 0.200
height = 0.28 --0.354

Citizen.CreateThread(function()
	RequestStreamedTextureDict("circlemap", false)
	while not HasStreamedTextureDictLoaded("circlemap") do
		Wait(100)
	end

	AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

	SetMinimapClipType(1)
	SetMinimapComponentPosition('minimap', 'L', 'B', posX, posY, width, height)
	-- SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.0, 0.032, 0.101, 0.259)
	SetMinimapComponentPosition('minimap_mask', 'L', 'B', posX, posY, width, height)
	SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.01, 0.024, 0.256, 0.337)

    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(false, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)

    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)

local isPause = false
local uiHidden = false

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsBigmapActive() or IsPauseMenuActive() and not isPause or IsRadarHidden() then
            if not uiHidden then
                SendNUIMessage({
                    action = "hideUI"
                })
                uiHidden = true
            end
        elseif uiHidden or IsPauseMenuActive() and isPause then
            SendNUIMessage({
                action = "displayUI"
            })
            uiHidden = false
        end
    end
end)]]


-- local uiHidden = false

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Wait(0)
-- 		if IsBigmapActive() or IsRadarHidden() then
-- 			if not uiHidden then
-- 				SendNUIMessage({
-- 					action = "hideUI"
-- 				})
-- 				uiHidden = true
-- 			end
-- 		elseif uiHidden then
-- 			SendNUIMessage({
-- 				action = "displayUI"
-- 			})
-- 			uiHidden = false
-- 		end
-- 	end
-- end)