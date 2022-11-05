TurboCore = nil

TriggerEvent('TurboCore:GetObject', function(obj) TurboCore = obj end)

-- Code

TurboCore.Functions.CreateCallback("turbo-fuel:server:get:fuel:config", function(source, cb)
    cb(Config)
end)

TurboCore.Functions.CreateCallback('turbo-fuel:server:can:fuel', function(source, cb, price)
    local CanFuel = false
    local Player = TurboCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney("cash", price, "car-wash") then
        CanFuel = true
    else 
        CanFuel = false
    end
    cb(CanFuel)
end)

RegisterServerEvent('turbo-fuel:server:register:fuel')
AddEventHandler('turbo-fuel:server:register:fuel', function(Plate, Vehicle, Amount)
    Config.VehicleFuel[Plate] = Amount
    TriggerClientEvent('turbo-fuel:client:register:vehicle:fuel', -1, Plate, Vehicle, Amount)
end)

RegisterServerEvent('turbo-fuel:server:update:fuel')
AddEventHandler('turbo-fuel:server:update:fuel', function(Plate, Vehicle, Amount)
    Config.VehicleFuel[Plate] = Amount
    TriggerClientEvent('turbo-fuel:client:update:vehicle:fuel', -1, Plate, Vehicle, Amount)
end)