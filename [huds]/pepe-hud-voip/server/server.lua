QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('hud:server:gain:stress')
AddEventHandler('hud:server:gain:stress', function(Amount)
    local Player = QBCore.Functions.GetPlayer(source)
	local NewStress = nil
	if Player ~= nil then
	  NewStress = Player.PlayerData.metadata["stress"] + Amount
	  if NewStress <= 0 then NewStress = 0 end
	  if NewStress > 105 then NewStress = 100 end
	  Player.Functions.SetMetaData("stress", NewStress)
      TriggerClientEvent("hud:client:update:stress", Player.PlayerData.source, NewStress)
	end
end)

RegisterServerEvent('hud:server:remove:stress')
AddEventHandler('hud:server:remove:stress', function(Amount)
    local Player = QBCore.Functions.GetPlayer(source)
	local NewStress = nil
	if Player ~= nil then
	  NewStress = Player.PlayerData.metadata["stress"] - Amount
	  if NewStress <= 0 then NewStress = 0 end
	  if NewStress > 105 then NewStress = 100 end
	  Player.Functions.SetMetaData("stress", NewStress)
      TriggerClientEvent("hud:client:update:stress", Player.PlayerData.source, NewStress)
	end
end)

QBCore.Commands.Add("cash", "Kijk hoeveel geld je bij je hebt", {}, false, function(source, args)
	TriggerClientEvent('hud:client:show:money', source, "cash")
end)