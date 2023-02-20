print("^0======================================================================^7")
print("^5 Vehicle Info Fivem Script - By Blaze Z Community")
print("^0======================================================================^7")


local QBCore = exports['qb-core']:GetCoreObject()

function OpenTheMenu()
	local ped = PlayerPedId()
    local vehd = GetVehiclePedIsUsing(ped)
	if DoesEntityExist(vehd) then
	    local vehicleProps = QBCore.Functions.GetVehicleProperties2(vehd)
		local turbo = 'INACTIVE'
		if vehicleProps.modTurbo ~= false then
			turbo = 'ACTIVE'
        end
		local engineShow = 'LEVEL 0'
		local brakesShow = 'LEVEL 0'
		local transmissionShow = 'LEVEL 0'
		local suspensionShow = 'LEVEL 0'

		SetVehicleModKit(vehd, 0)
		if GetNumVehicleMods(vehd, 11) == vehicleProps.modEngine + 1 then
			engineShow = 'MAX LEVEL'
		else
			engineShow = 'LEVEL '..vehicleProps.modEngine + 1
		end


		if GetNumVehicleMods(vehd, 12) == vehicleProps.modBrakes + 1 then
			brakesShow = 'MAX LEVEL'
		else
			brakesShow = 'LEVEL '..vehicleProps.modBrakes + 1
		end


		if GetNumVehicleMods(vehd, 13) == vehicleProps.modTransmission + 1 then
			transmissionShow = 'MAX LEVEL'
		else
			transmissionShow = 'LEVEL '..vehicleProps.modTransmission + 1
		end


		if GetNumVehicleMods(vehd, 15) == vehicleProps.modSuspension + 1 then
			suspensionShow = 'MAX LEVEL'
		else
		    suspensionShow = 'LEVEL '..vehicleProps.modSuspension + 1
		end


		local vehicleProps = QBCore.Functions.GetVehicleProperties2(vehd)
		SendNUIMessage({
			action = "show",
			label = GetDisplayNameFromVehicleModel(vehicleProps.model),
			plate = vehicleProps.plate,
			turbo = turbo,
			engineKit = engineShow,
			brakeKit = brakesShow,
			transmissionKit = transmissionShow,
			suspensionKit = suspensionShow,
		})
		SetNuiFocus(true, true)
		
	else
		QBCore.Functions.Notify('You must be in a car')
		vehicleProps = nil
	end
	
end

RegisterCommand('vehinfo', function()
    OpenTheMenu()
end)

RegisterNUICallback("exit", function()
    SetNuiFocus(false, false)
end)