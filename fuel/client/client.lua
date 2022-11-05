local IsBusy = false
local LoggedIn = false
TurboCore = nil

RegisterNetEvent("TurboCore:Client:OnPlayerLoaded")
AddEventHandler("TurboCore:Client:OnPlayerLoaded", function()
    Citizen.SetTimeout(1250, function()
        TriggerEvent("TurboCore:GetObject", function(obj) TurboCore = obj end)    
        Citizen.Wait(250)
        TurboCore.Functions.TriggerCallback("turbo-fuel:server:get:fuel:config", function(config)
            Config = config
        end)
        LoggedIn = true
    end)
end)

-- Code

-- // Events \\ --

RegisterNetEvent('turbo-fuel:client:register:vehicle:fuel')
AddEventHandler('turbo-fuel:client:register:vehicle:fuel', function(Plate, Vehicle, Amount)
 Config.VehicleFuel[Plate] = Amount
end)

RegisterNetEvent('turbo-fuel:client:update:vehicle:fuel')
AddEventHandler('turbo-fuel:client:update:vehicle:fuel', function(Plate, Vehicle, Amount)
 Config.VehicleFuel[Plate] = Amount
end)

RegisterNetEvent('turbo-fuel:client:refuelWithJerryCan')
AddEventHandler('turbo-fuel:client:refuelWithJerryCan', function()
    local plyPed = PlayerPedId()
    local veh, distanceToVeh = TurboCore.Functions.GetClosestVehicle()
    if distanceToVeh < 2.5 then
        if not IsPedSittingInVehicle(plyPed, veh) then
            RefuelCar(veh, GetVehicleNumberPlateText(veh), true)
            Wait(5000)
            TriggerServerEvent('turbo-items:server:removeItem', 'jerry_can_normal', 1)
        else
            TurboCore.Functions.Notify('Излезте от МПС-то!', 'error', 5000)
        end
    else
        TurboCore.Functions.Notify('Наблизо няма МПС!', 'error', 5000)
    end
end)

-- // Loops \\ --

Citizen.CreateThread(function()
    Citizen.Wait(150)
    while true do
        Citizen.Wait(5)
        if LoggedIn then
        local Vehicle = GetVehiclePedIsIn(PlayerPedId())
        local Plate = GetVehicleNumberPlateText(Vehicle)
        if Vehicle ~= 0 then
            if Config.VehicleFuel[Plate] ~= nil then
                if IsVehicleEngineOn(Vehicle) then
                    if Config.VehicleFuel[Plate] ~= 0 then
                        if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then 
                          SetFuelLevel(Vehicle, Plate, Config.VehicleFuel[Plate] - Config.FuelUsageSpeed[Round(GetVehicleCurrentRpm(Vehicle, 1))] * Config.VehicleFuelUsage[GetVehicleClass(Vehicle)], false)
                          Citizen.Wait(7250)
                        end
                    end
                else
                    Citizen.Wait(250)
                end
            else
                Citizen.Wait(250)
                TriggerServerEvent('turbo-fuel:server:register:fuel', Plate, Vehicle, math.random(55, 85))
                Citizen.Wait(2500)
            end
         else
            Citizen.Wait(1000)
        end
      else
        Citizen.Wait(1000)
     end
    end
end)

Citizen.CreateThread(function()
  Citizen.Wait(150)
    while true do
        Citizen.Wait(5)
        if LoggedIn then
        local Vehicle, VehDistance = TurboCore.Functions.GetClosestVehicle()
        local Plate = GetVehicleNumberPlateText(Vehicle)
        InRange = false
        for k, v in pairs(Config.TankLocations) do
            local Distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.TankLocations[k]["Coords"]["X"], Config.TankLocations[k]["Coords"]["Y"], Config.TankLocations[k]["Coords"]["Z"], true)
            if Distance < 15.0 then
                InRange = true
                if VehDistance < 2.5 and not IsPedSittingInVehicle(PlayerPedId(), Vehicle) and GetFuelLevel(Plate) ~= 100 then
                  local VehicleCoords = GetEntityCoords(Vehicle)
                  DrawMarker(2, VehicleCoords.x, VehicleCoords.y, VehicleCoords.z + 1.15, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 35, 161, 48, 255, false, false, false, 1, false, false, false)     
                  DrawText3D(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z + 1.10, '~g~Количество~s~: '..GetFuelLevel(Plate).. '%\n~g~E~s~ - Зареждане | Сума ~g~€~s~'..Config.TankLocations[k]['Tank-Price'])
                if IsControlJustReleased(0, 38) and not IsBusy then
                    TurboCore.Functions.TriggerCallback("turbo-fuel:server:can:fuel", function(CanFuel)
                        if CanFuel then
                         IsBusy = true
                         RefuelCar(Vehicle, Plate)
                        else
                         TurboCore.Functions.Notify('Нямате достатъчно пари в себе си..', 'error')
                        end
                    end, Config.TankLocations[k]["Tank-Price"])
                end
                else
                    Citizen.Wait(1500)
                end
            end
        end
        if not InRange then
            Citizen.Wait(1500)
        end
      else
        Citizen.Wait(1000)
     end
    end
end)

-- // Functions \\ --

function GetFuelLevel(Plate)
    if Config.VehicleFuel[Plate] ~= nil then
        return Config.VehicleFuel[Plate]
    else
        return 0
    end
end

function SetFuelLevel(Vehicle, Plate, Amount, Spawned)
 if Amount < 0 then 
  Amount = 0 
 end
 if Spawned then
    if Amount < 100 or GetFuelLevel(Plate) < 100 then
        Amount = 100
    end
 end
 SetVehicleFuelLevel(Vehicle, Amount + 0.0)
 TriggerServerEvent('turbo-fuel:server:update:fuel', Plate, Vehicle, math.floor(Amount))
end

function RefuelCar(Vehicle, Plate, to50)
 exports['turbo-assets']:RequestAnimationDict("weapon@w_sp_jerrycan")
 TaskPlayAnim(PlayerPedId(), "weapon@w_sp_jerrycan", "fire", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
 TurboCore.Functions.Progressbar("refuel-car", "Зареждане..", math.random(5000, 6500), false, true, {
     disableMovement = true,
     disableCarMovement = true,
     disableMouse = false,
     disableCombat = true,
 }, {}, {}, {}, function() -- Done
    IsBusy = false
    if to50 then 
        local newLevel = GetFuelLevel(Plate) + 50
        if newLevel > 100.0 then newLevel = 100 end
        SetFuelLevel(Vehicle, Plate, newLevel, false) 
    else
        SetFuelLevel(Vehicle, Plate, 100, false)
    end
    PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
    TurboCore.Functions.Notify('Превозното средство е заредено', 'success')
    StopAnimTask(PlayerPedId(), "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
 end, function() -- Cancel
    IsBusy = false
    StopAnimTask(PlayerPedId(), "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
 end)
end

function DrawText3D(x, y, z, text)
 SetTextScale(0.35, 0.35)
 SetTextFont(4)
 SetTextProportional(1)
 SetTextColour(255, 255, 255, 215)
 SetTextEntry("STRING")
 SetTextCentre(true)
 AddTextComponentString(text)
 SetDrawOrigin(x,y,z, 0)
 DrawText(0.0, 0.0)
 ClearDrawOrigin()
end

function Round(num, numDecimalPlaces)
 local mult = 10^(numDecimalPlaces or 0)
 return math.floor(num * mult + 0.5) / mult
end


Citizen.CreateThread(function()
    for k,v in pairs(Config.Blips) do
      Blips = AddBlipForCoord(Config.Blips[k]['X'], Config.Blips[k]['Y'], Config.Blips[k]['Z'])
      SetBlipSprite (Blips, Config.Blips[k]['SpriteId'])
      SetBlipDisplay(Blips, 4)
      SetBlipScale  (Blips, Config.Blips[k]['Scale'])
      SetBlipAsShortRange(Blips, true)
      SetBlipColour(Blips, Config.Blips[k]['Color'])
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentSubstringPlayerName(Config.Blips[k]['Name'])
      EndTextCommandSetBlipName(Blips)
    end
end)

function AddBlipToCoords(Coords, Sprite, Scale, Color, Text)
  Blips = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
  SetBlipSprite (Blips, Sprite)
  SetBlipDisplay(Blips, 4)
  SetBlipScale  (Blips, Scale)
  SetBlipAsShortRange(Blips, true)
  SetBlipColour(Blips, Color)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentSubstringPlayerName(Text)
  EndTextCommandSetBlipName(Blips)
end

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(45000)
        local Vehicle = GetVehiclePedIsIn(PlayerPedId())
        local Plate = GetVehicleNumberPlateText(Vehicle)
        local fuelnow = GetFuelLevel(Plate)
        if fuelnow ~= 0 then
          if fuelnow < 25 then 
              TurboCore.Functions.Notify('Ниско ниво на гориво!', 'error', 5000)
              PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 3)
          end
        end
    end
end)

