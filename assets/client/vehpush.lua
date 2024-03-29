Config = {} 
Config.DamageNeeded = 1000.0 -- 100.0 being broken and 1000.0 being fixed a lower value than 100.0 will break it
Config.MaxWidth = 5.0 -- Will complete soon
Config.MaxHeight = 5.0
Config.MaxLength = 5.0

RePCore  = nil


Citizen.CreateThread(function()
  while RePCore == nil do
    TriggerEvent('RePCore:GetObject', function(obj) RePCore = obj end)
    Citizen.Wait(0)
  end
end)

local First = vector3(0.0, 0.0, 0.0)
local Second = vector3(5.0, 5.0, 5.0)
local Vehicle = {Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil}
Citizen.CreateThread(function()
    Citizen.Wait(200)
    while true do
        local ped = PlayerPedId()
        local posped = GetEntityCoords(PlayerPedId())
        local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 20.0, 0.0)
        local rayHandle = CastRayPointToPoint(posped.x, posped.y, posped.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, ped, 0)
        local a, b, c, d, closestVehicle = GetRaycastResult(rayHandle)
        local Distance = GetDistanceBetweenCoords(c.x, c.y, c.z, posped.x, posped.y, posped.z, false);
        local vehicleCoords = GetEntityCoords(closestVehicle)
        local dimension = GetModelDimensions(GetEntityModel(closestVehicle), First, Second)
        if Distance < 6.0  and not IsPedInAnyVehicle(ped, false) then
            Vehicle.Coords = vehicleCoords
            Vehicle.Dimensions = dimension
            Vehicle.Vehicle = closestVehicle
            Vehicle.Distance = Distance
            if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), GetEntityCoords(ped), true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, GetEntityCoords(ped), true) then
                Vehicle.IsInFront = false
            else
                Vehicle.IsInFront = true
            end
        else
            Vehicle = {Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false, Distance = nil}
        end
        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()
    local lerpCurrentAngle = 0.0
    while true do 
        Citizen.Wait(5)
        local ped = PlayerPedId()
        if Vehicle.Vehicle ~= nil then
			--	if IsVehicleSeatFree(Vehicle.Vehicle, -1) and GetVehicleEngineHealth(Vehicle.Vehicle) <= Config.DamageNeeded then
			--		DrawText3Ds(Vehicle.Coords.x, Vehicle.Coords.y, Vehicle.Coords.z + 0.3, 'Натиснете [~g~SHIFT~w~] и [~g~E~w~], за да бутате.')
			--	end
                if --[[IsControlPressed(0, 21) and ]]IsVehicleSeatFree(Vehicle.Vehicle, -1) and not IsEntityAttachedToEntity(ped, Vehicle.Vehicle) and IsControlJustPressed(0, 311) then
                    NetworkRequestControlOfEntity(Vehicle.Vehicle)
                    local coords = GetEntityCoords(ped)
                    if Vehicle.IsInFront then    
                        AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y * -1 + 0.1 , Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true)
                    else
                        AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y - 0.3, Vehicle.Dimensions.z  + 1.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, true)
                    end
    
                    RequestAnimDict('missfinale_c2ig_11')
                    TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
                    Citizen.Wait(200)
                     while true do
                        Citizen.Wait(5)
    
                        local speed = GetFrameTime() * 50
                        if IsDisabledControlPressed(0, 34) then
                            SetVehicleSteeringAngle(Vehicle.Vehicle, lerpCurrentAngle)
                            lerpCurrentAngle = lerpCurrentAngle + speed
                        elseif IsDisabledControlPressed(0, 9) then
                            SetVehicleSteeringAngle(Vehicle.Vehicle, lerpCurrentAngle)
                            lerpCurrentAngle = lerpCurrentAngle - speed
                        else
                            SetVehicleSteeringAngle(Vehicle.Vehicle, lerpCurrentAngle)
     
                            if lerpCurrentAngle < -0.02 then    
                                lerpCurrentAngle = lerpCurrentAngle + speed
                            elseif lerpCurrentAngle > 0.02 then
                                lerpCurrentAngle = lerpCurrentAngle - speed
                            else
                                lerpCurrentAngle = 0.0
                            end
                        end
    
                        if lerpCurrentAngle > 15.0 then
                            lerpCurrentAngle = 15.0
                        elseif lerpCurrentAngle < -15.0 then
                            lerpCurrentAngle = -15.0
                        end
    
                        if Vehicle.IsInFront then
                            SetVehicleForwardSpeed(Vehicle.Vehicle, -1.0)
                        else
                            SetVehicleForwardSpeed(Vehicle.Vehicle, 1.0)
                        end
    
                        if HasEntityCollidedWithAnything(Vehicle.Vehicle) then
                            SetVehicleOnGroundProperly(Vehicle.Vehicle)
                        end
                              if not IsDisabledControlPressed(0, 311) then
                            DetachEntity(ped, false, false)
                            StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
                            FreezeEntityPosition(ped, false)
                            break
                        end
                    end
                end
            end
        end
end)