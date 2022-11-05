local CashAmount = 0
local isLoggedIn = false
local Hunger, Thirst, Stress = 100, 100, 0
local Seatbelt = false
local SillyWalk = false
local InVehicle = false

QBCore = nil
ShowHud = false

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    Citizen.SetTimeout(750, function()
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(250)
        QBCore.Functions.GetPlayerData(function(PlayerData)
            if PlayerData ~= nil and PlayerData.money ~= nil then
                CashAmount = PlayerData.money["cash"]
                Hunger, Thirst, Stress = PlayerData.metadata["hunger"], PlayerData.metadata["thirst"], PlayerData.metadata["stress"]
            end
        end)
        ShowHud = true
        isLoggedIn = true
    end)
end)

RegisterNetEvent("hud:client:update:needs")
AddEventHandler("hud:client:update:needs", function(NewHunger, NewThirst)
    Hunger, Thirst = NewHunger, NewThirst
end)

RegisterNetEvent('hud:client:update:stress')
AddEventHandler('hud:client:update:stress', function(NewStress)
    Stress = NewStress
end)

-- Code

-- // Loops \\ --
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedInAnyVehicle(PlayerPedId()) then
            DisplayRadar(true)
            if not InVehicle then
              InVehicle = true
              SendNUIMessage({
                  action = "carhud",
                  bool = true,
              })
            end
        else
            DisplayRadar(false)
            if InVehicle then
                InVehicle = false
                SendNUIMessage({
                    action = "carhud",
                    bool = false,
                })
            end
        end
        Citizen.Wait(250)
    end
end)

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(0)
     if ShowHud then
        local Speed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) * 3.6
        local Plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId()))
        local StreetName = GetStreetNameAtCoord(GetEntityCoords(PlayerPedId()), Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
        if IsPedSittingInAnyVehicle(PlayerPedId()) then
           SendNUIMessage({
               action = "UpdateHud",
               show = IsPauseMenuActive(),
               -- Player --
               radio = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'radio:talking'),
               talking = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'voip:talking'),
               health = GetEntityHealth(PlayerPedId()),
               armor = GetPedArmour(PlayerPedId()),
               thirst = math.floor(Thirst),
               hunger = math.floor(Hunger),
               stress = math.floor(Stress),
               street = GetStreetNameFromHashKey(StreetName),
               zone = GetLabelText(GetNameOfZone(GetEntityCoords(PlayerPedId()))),
               parachute = HasParachute,
               --  Vehicle --
               speed = math.ceil(Speed),
               fuel = exports['turbo-fuel']:GetFuelLevel(Plate),
               seatbelt = Seatbelt,
               hour = GetGameTime('Hours'),
               minute = GetGameTime('Minutes'),
           })
           Citizen.Wait(75)
        else
            SendNUIMessage({
                action = "UpdateHud",
                show = IsPauseMenuActive(),
                -- Player --
                radio = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'radio:talking'),
                talking = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'voip:talking'),
                health = GetEntityHealth(PlayerPedId()),
                armor = GetPedArmour(PlayerPedId()),
                thirst = math.floor(Thirst),
                hunger = math.floor(Hunger),
                stress = math.floor(Stress),
                street = GetStreetNameFromHashKey(StreetName),
                zone = GetLabelText(GetNameOfZone(GetEntityCoords(PlayerPedId()))),
                parachute = HasParachute,
                hour = GetGameTime('Hours'),
                minute = GetGameTime('Minutes'),
            })  
            Citizen.Wait(1500)
        end
        SetBlipAlpha(GetNorthRadarBlip(), 0)
      end
    end
end)

Citizen.CreateThread(function()
    local CurrentLevel = 1
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(1, 243) then
            CurrentLevel =  exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'voip:mode')
            if CurrentLevel == 1 then
                SendNUIMessage({
                    action = "UpdateProximity",
                    prox = 2
                })
            elseif CurrentLevel == 2 then
                SendNUIMessage({
                    action = "UpdateProximity",
                    prox = 1
                })
            elseif CurrentLevel == 3 then
                SendNUIMessage({
                    action = "UpdateProximity",
                    prox = 3
                })
            end
        end
    end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if isLoggedIn then
        local Wait = GetEffectInterval(Stress)
        if Stress >= 100 then
            local ShakeIntensity = GetShakeIntensity(Stress)
            local FallRepeat = math.random(2, 4)
            local RagdollTimeout = (FallRepeat * 1750)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
            SetFlash(0, 0, 500, 3000, 500)
            if not IsPedRagdoll(PlayerPedId()) and IsPedOnFoot(PlayerPedId()) and not IsPedSwimming(PlayerPedId()) then
                SetPedToRagdollWithFall(PlayerPedId(), RagdollTimeout, RagdollTimeout, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
            end
            Citizen.Wait(500)
            for i = 1, FallRepeat, 1 do
                Citizen.Wait(750)
                DoScreenFadeOut(200)
                Citizen.Wait(1000)
                DoScreenFadeIn(200)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
                SetFlash(0, 0, 200, 750, 200)
            end
        elseif Stress >= Config.MinimumStress then
            local ShakeIntensity = GetShakeIntensity(Stress)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
            SetFlash(0, 0, 500, 2500, 500)
        end
        Citizen.Wait(Wait)
    end
  end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isLoggedIn then
            if IsPedInAnyVehicle(PlayerPedId(), false) then
             local CurrentSpeed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6
              if CurrentSpeed >= 180 then
                  TriggerServerEvent('hud:server:gain:stress', math.random(1, 2))
              end
            end
        end
        Citizen.Wait(20000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isLoggedIn then
            if SillyWalk then
             RequestAnimSet("move_m@injured")
             while not HasAnimSetLoaded("move_m@injured") do Citizen.Wait(0) end
             SetPedMovementClipset(PlayerPedId(), "move_m@injured", true)
             Citizen.Wait(50)
            end
        else
            Citizen.Wait(1500)
        end
    end
end)


-- // Events \\ --

RegisterNetEvent("hud:client:show:money")
AddEventHandler("hud:client:show:money", function(type)
    TriggerEvent("hud:client:set:money")
    SendNUIMessage({
        action = "show",
        cash = CashAmount,
        type = type,
    })
end)

RegisterNetEvent("hud:client:set:values")
AddEventHandler("hud:client:set:values", function()
    Citizen.SetTimeout(1000, function()
        QBCore.Functions.GetPlayerData(function(PlayerData) 
            SendNUIMessage({
                action = "UpdateHud",
                show = IsPauseMenuActive(),
                -- Player --
                radio = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'radio:talking'),
                talking = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'voip:talking'),
                health = PlayerData.metadata['health'],
                armor = PlayerData.metadata['armor'],
                thirst = PlayerData.metadata['thirst'],
                hunger = PlayerData.metadata['hunger'],
                stress = PlayerData.metadata['stress'],
                parachute = HasParachute,
                hour = GetGameTime('Hours'),
                minute = GetGameTime('Minutes'),
            })
            if not PlayerData.metadata["isdead"] then
              SetEntityHealth(PlayerPedId(), PlayerData.metadata["health"])
            end
        end)
    end)
end)

RegisterNetEvent("hud:client:money:change")
AddEventHandler("hud:client:money:change", function(type, amount, isMinus)
    QBCore.Functions.GetPlayerData(function(PlayerData)
        CashAmount = PlayerData.money["cash"]
    end)
     SendNUIMessage({
         action = "update",
         cash = CashAmount,
         amount = amount,
         minus = isMinus,
         type = type,
     })
end)

RegisterNUICallback('SetBlood', function(data)
    if data.Bool then
        SillyWalk = true
        SetFlash(false, false, 450, 3000, 450)
        Citizen.Wait(350)
        SetTimecycleModifier('damage')
    else
        SillyWalk = false
        QBCore.Functions.GetPlayerData(function(PlayerData)
            if not PlayerData.metadata['isdead'] then
                SetFlash(false, false, 450, 3000, 450)
                Citizen.Wait(350)
                ClearTimecycleModifier()
                ResetPedMovementClipset(PlayerPedId(), 0)
            end
        end)
    end
end)

function SetSeatbelt(bool)
    Seatbelt = bool
end

function GetGameTime(Type)
    local Hours = GetClockHours()
    local Minutes = GetClockMinutes()
    if Type == 'Minutes' then
        if Minutes <= 9 then
            Minutes = "0" .. Minutes
        end
     return Minutes
    elseif Type == 'Hours' then
        if Hours <= 9 then
            Hours = "0" .. Hours
        end
     return Hours
    end
end

function GetShakeIntensity(stresslevel)
    local retval = 0.05
    for k, v in pairs(Config.Intensity["shake"]) do
        if stresslevel >= v.min and stresslevel < v.max then
            retval = v.intensity
            break
        end
    end
    return retval
end

function GetEffectInterval(stresslevel)
    local retval = 60000
    for k, v in pairs(Config.EffectInterval) do
        if stresslevel >= v.min and stresslevel < v.max then
            retval = v.timeout
            break
        end
    end
    return retval
end