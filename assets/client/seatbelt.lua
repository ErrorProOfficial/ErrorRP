GLOBAL_PED = PlayerPedId()

RegisterNetEvent('RePCore:Client:OnPlayerLoaded')
AddEventHandler('RePCore:Client:OnPlayerLoaded', function()
	LoggedIn = true
end)

AddEventHandler('rep-core:client:receiveGLOBAL_PEDId', function(receivedPed)
    GLOBAL_PED = receivedPed
end)

local SeatbeltStatus = false
local IsEjected = false
local NewBodyHealth = 0
local NewEngineHealth = 0
local CurrentVehicleHealth = 0
local CurrentBodyHealth = 0
local FrameBodyChange = 0
local FrameEngineChange = 0
local LastFrameVehicleSpeed = 0
local SecondLastFrameVehicleSpeed = 0
local ThisFrameVehicleSpeed = 0
local Ticks = 0
local harnessOn = false
local harnessHp = 20
harnessData = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if LoggedIn then

            if not IsPedInAnyVehicle(GLOBAL_PED) then
                SeatbeltStatus = false
               -- exports['hud']:SetSeatbelt(false)
		    	
            end

            if IsControlJustReleased(0, 311) and IsPedInAnyVehicle(GLOBAL_PED) then
                if not harnessOn then
                    if IsPedInAnyVehicle(GLOBAL_PED) and GetVehicleClass(GetVehiclePedIsIn(GLOBAL_PED)) ~= 8 and GetVehicleClass(GetVehiclePedIsIn(GLOBAL_PED)) ~= 13 and GetVehicleClass(GetVehiclePedIsIn(GLOBAL_PED)) ~= 14 then
                        if SeatbeltStatus then
                            TriggerEvent("sound:client:play", "car-unbuckle", 0.69)	-- 0.25
                            --exports['hud']:SetSeatbelt(false)
                            TriggerEvent("seatbelt:client:ToggleSeatbelt")
                            SeatbeltStatus = false
                        else
                            TriggerEvent("sound:client:play", "car-buckle", 0.69)	-- 0.25
                            --exports['hud']:SetSeatbelt(true)
                            TriggerEvent("seatbelt:client:ToggleSeatbelt")
                            SeatbeltStatus = true
                        end
                    end
                end
            end
            if IsControlJustReleased(0, 305) and IsPedInAnyVehicle(GLOBAL_PED) then
                if harnessOn then
                    RePCore.Functions.Progressbar("harness_equip", "Сваляне на спортните колани..", 10000, false, true, {
                        disableMovement = false,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, function() -- Done
                        ToggleHarness(false)
                    end)
                end
            end

            if IsPedInAnyVehicle(GLOBAL_PED) then
                if harnessOn then
                    DisableControlAction(0, 75, true)
                    DisableControlAction(27, 75, true)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        Citizen.Wait(5)
        local currentVehicle = GetVehiclePedIsIn(GLOBAL_PED, false)
        local driverPed = GetPedInVehicleSeat(currentVehicle, -1)
        if currentVehicle ~= nil and currentVehicle ~= false and currentVehicle ~= 0 then
            SetPedHelmet(GLOBAL_PED, false)
            lastVehicle = GetVehiclePedIsIn(GLOBAL_PED, false)
            if GetVehicleEngineHealth(currentVehicle) < 0.0 then
                SetVehicleEngineHealth(currentVehicle,0.0)
            end
            ThisFrameVehicleSpeed = GetEntitySpeed(currentVehicle) * 3.6
            CurrentBodyHealth = GetVehicleBodyHealth(currentVehicle)
            if CurrentBodyHealth == 1000 and FrameBodyChange ~= 0 then
                FrameBodyChange = 0
            end
            if FrameBodyChange ~= 0 then
                if LastFrameVehicleSpeed > math.random(175, 185) and ThisFrameVehicleSpeed < (LastFrameVehicleSpeed * 0.75) and not IsEjected then
                    if FrameBodyChange > 18.0 then
                        if not SeatbeltStatus and not IsThisModelABike(currentVehicle) then
                            if math.random(math.ceil(LastFrameVehicleSpeed)) > 60 then
                                if not harnessOn then
                                    EjectFromVehicle(vels)
                                else
                                    harnessHp = harnessHp - 1
                                    TriggerServerEvent('seatbelt:DoHarnessDamage', harnessHp, harnessData)
                                end
                            end
                        elseif (SeatbeltStatus or harnessOn) and not IsThisModelABike(currentVehicle) then
                            if LastFrameVehicleSpeed > 150 then
                                if math.random(math.ceil(LastFrameVehicleSpeed)) > 150 then
                                    if not harnessOn then
                                        EjectFromVehicle()
                                    else
                                        harnessHp = harnessHp - 1
                                        TriggerServerEvent('seatbelt:DoHarnessDamage', harnessHp, harnessData)
                                    end
                                end
                            end
                        end
                    else
                        if not SeatbeltStatus and not IsThisModelABike(currentVehicle) then
                            if math.random(math.ceil(LastFrameVehicleSpeed)) > 60 then
                                if not harnessOn then
                                    EjectFromVehicle()
                                else
                                    harnessHp = harnessHp - 1
                                    TriggerServerEvent('seatbelt:DoHarnessDamage', harnessHp, harnessData)
                                end                      
                            end
                        elseif (SeatbeltStatus or harnessOn) and not IsThisModelABike(currentVehicle) then
                            if LastFrameVehicleSpeed > 120 then
                                if math.random(math.ceil(LastFrameVehicleSpeed)) > 200 then
                                    if not harnessOn then
                                        EjectFromVehicle()
                                    else
                                        harnessHp = harnessHp - 1
                                        TriggerServerEvent('seatbelt:DoHarnessDamage', harnessHp, harnessData)
                                    end                   
                                end
                            end
                        end
                    end
                    IsEjected = true
                    Citizen.Wait(15)
                --    DoWheelDamage(currentVehicle)
                    SetVehicleEngineHealth(currentVehicle, 0)
                    SetVehicleEngineOn(currentVehicle, false, true, true)
                end
                if CurrentBodyHealth < 350.0 and not IsEjected then
                    IsEjected = true
                    Citizen.Wait(15)
                --    DoWheelDamage(currentVehicle)
                    SetVehicleBodyHealth(targetVehicle, 945.0)
                    SetVehicleEngineHealth(currentVehicle, 0)
                    SetVehicleEngineOn(currentVehicle, false, true, true)
                    Citizen.Wait(1000)
                end
            end
            if LastFrameVehicleSpeed < 100 then
                Wait(100)
                Ticks = 0
            end
            FrameBodyChange = NewBodyHealth - CurrentBodyHealth
            if Ticks > 0 then 
                Ticks = Ticks - 1
                if Ticks == 1 then
                    LastFrameVehicleSpeed = GetEntitySpeed(currentVehicle) * 3.6
                end
            else
                if IsEjected then
                    IsEjected = false
                    FrameBodyChange = 0
                    LastFrameVehicleSpeed = GetEntitySpeed(currentVehicle) * 3.6
                end
                SecondLastFrameVehicleSpeed = GetEntitySpeed(currentVehicle) * 3.6
                if SecondLastFrameVehicleSpeed > LastFrameVehicleSpeed then
                    LastFrameVehicleSpeed = GetEntitySpeed(currentVehicle) * 3.6
                end
                if SecondLastFrameVehicleSpeed < LastFrameVehicleSpeed then
                    Ticks = 25
                end
            end
            vels = GetEntityVelocity(currentVehicle)
            if Ticks < 0 then 
                Ticks = 0
            end     
            NewBodyHealth = GetVehicleBodyHealth(currentVehicle)
            veloc = GetEntityVelocity(currentVehicle)
        else
            if lastVehicle ~= nil then
                SetPedHelmet(GLOBAL_PED, true)
                Citizen.Wait(200)
                NewBodyHealth = GetVehicleBodyHealth(lastVehicle)
                if not IsEjected and NewBodyHealth < CurrentBodyHealth then
                    IsEjected = true
                    SetVehicleEngineHealth(lastVehicle, 0)
                    SetVehicleEngineOn(lastVehicle, false, true, true)
                    Citizen.Wait(1000)
                end
                lastVehicle = nil
            end
            SecondLastFrameVehicleSpeed = 0
            LastFrameVehicleSpeed = 0
            NewBodyHealth = 0
            CurrentBodyHealth = 0
            FrameBodyChange = 0
            Citizen.Wait(2000)
        end
    end
end)

-- // Functions \\ --

function EjectFromVehicle(VehicleVelocity)
 local Vehicle = GetVehiclePedIsIn(GLOBAL_PEDId(),false)
 local Coords = GetOffsetFromEntityInWorldCoords(Vehicle, 1.0, 0.0, 1.0)
 local EjectSpeed = math.ceil(GetEntitySpeed(GLOBAL_PEDId()) * 8)
 local VehicleVelocity = GetEntitySpeed(Vehicle)
 SetEntityCoords(GLOBAL_PEDId(), Coords)
 Citizen.Wait(0)
 SetPedToRagdoll(GLOBAL_PEDId(), 5511, 5511, 0, 0, 0, 0)
 SetEntityVelocity(GLOBAL_PEDId(), VehicleVelocity.x*4, VehicleVelocity.y*4, VehicleVelocity.z*4)
 SetEntityHealth(GLOBAL_PEDId(), (GetEntityHealth(GLOBAL_PEDId()) - EjectSpeed))
 Citizen.SetTimeout(2500, function()
    IsEjected = false
 end)
end

RegisterNetEvent("seatbelt:client:ToggleSeatbelt")
AddEventHandler("seatbelt:client:ToggleSeatbelt", function(toggle)
    if toggle == nil then
        seatbeltOn = not seatbeltOn
    else
        seatbeltOn = toggle
    end
end)

function ToggleHarness(toggle)
    harnessOn = toggle
    seatbeltOn = false
    if not toggle then
        harnessHp = 10
        TriggerEvent("seatbelt:client:ToggleSeatbelt", true)
    else
        TriggerEvent("seatbelt:client:ToggleSeatbelt", false)
    end
    --TriggerEvent('hud:client:ToggleHarness', toggle)
end

RegisterNetEvent('seatbelt:client:UseHarness')
AddEventHandler('seatbelt:client:UseHarness', function(ItemData)
    local ped = GLOBAL_PEDId()
    local inveh = IsPedInAnyVehicle(GLOBAL_PEDId())
    if inveh and not IsThisModelABike(GetEntityModel(GetVehiclePedIsIn(ped))) then
        if not harnessOn then
            RePCore.Functions.Progressbar("harness_equip", "Слагане на спортните колани..", 10000, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                ToggleHarness(true)
                TriggerServerEvent('equip:harness', ItemData)
            end)
            harnessHp = ItemData.info.uses
            harnessData = ItemData
        end
    else
        RePCore.Functions.Notify('Трябва да бъдете в автомобил', 'error', 3500)
    end
end)

function HasHarness()
    return harnessOn
end

function DoWheelDamage(Vehicle)
 local wheels = {0,1,4,5}
 for i=1, math.random(4) do
     local wheel = math.random(#wheels)
     SetVehicleTyreBurst(Vehicle, wheels[wheel], true, 1000)
     table.remove(wheels, wheel)
 end
end