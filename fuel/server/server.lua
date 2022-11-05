TurboCore = nil

TriggerEvent('TurboCore:GetObject', function(obj) TurboCore = obj end)

-- Code

TurboCore.Functions.CreateCallback("fuel:server:get:fuel:config", function(source, cb)
    cb(Config)
end)

TurboCore.Functions.CreateCallback('-fuel:server:can:fuel', function(source, cb, price)
    local CanFuel = false
    local Player = TurboCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney("cash", price, "car-wash") then
        CanFuel = true
    else 
        CanFuel = false
    end
    cb(CanFuel)
end)

RegisterServerEvent('fuel:server:register:fuel')
AddEventHandler('fuel:server:register:fuel', function(Plate, Vehicle, Amount)
    Config.VehicleFuel[Plate] = Amount
    TriggerClientEvent('fuel:client:register:vehicle:fuel', -1, Plate, Vehicle, Amount)
end)

RegisterServerEvent('fuel:server:update:fuel')
AddEventHandler('fuel:server:update:fuel', function(Plate, Vehicle, Amount)
    Config.VehicleFuel[Plate] = Amount
    TriggerClientEvent('fuel:client:update:vehicle:fuel', -1, Plate, Vehicle, Amount)
end)
