local DoingSomething = false
local currentVest = nil
local currentVestTexture = nil
RePCore = nil

RegisterNetEvent('RePCore:Client:OnPlayerLoaded')
AddEventHandler('RePCore:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("RePCore:GetObject", function(obj) RePCore = obj end)    
	 Citizen.Wait(250)
 end)
end)

-- Code


-- parachute addons

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function EquipParachuteAnim()
    loadAnimDict("clothingshirt")        
    TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

local ParachuteEquiped = false

RegisterNetEvent("items:client:UseParachute")
AddEventHandler("items:client:UseParachute", function()
    EquipParachuteAnim()
    RePCore.Functions.Progressbar("use_parachute", "Слагаме парашут..", 5000, false, true, {
        disableMovement = true,		-- false
        disableCarMovement = true,		-- false
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        local ped = PlayerPedId()
        TriggerEvent("inventory:client:ItemBox", RePCore.Shared.Items["parachute"], "remove")
        GiveWeaponToPed(ped, GetHashKey("GADGET_PARACHUTE"), 1, false)
        local ParachuteData = {
            outfitData = {
                ["bag"]   = { item = 8, texture = 0},  -- Neck / Tie
            }
        }
        TriggerEvent('clothing:client:loadOutfit', ParachuteData)
        ParachuteEquiped = true
        TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    end)
end)

RegisterNetEvent("items:client:ResetParachute")
AddEventHandler("items:client:ResetParachute", function()
    if ParachuteEquiped then 
        EquipParachuteAnim()
        RePCore.Functions.Progressbar("reset_parachute", "Сгъваме парашут..", 40000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            local ped = PlayerPedId()
            TriggerEvent("inventory:client:ItemBox", RePCore.Shared.Items["parachute"], "add")
            local ParachuteRemoveData = { 
                outfitData = { 
                    ["bag"] = { item = 0, texture = 0} -- Neck / Tie
                }
            }
            TriggerEvent('clothing:client:loadOutfit', ParachuteRemoveData)
            TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
            TriggerServerEvent("smallpenis:server:AddParachute")
            ParachuteEquiped = false
        end)
    else
        RePCore.Functions.Notify("Нямате парашут!!", "error")
    end
end)

-- EOF parachute addons


RegisterNetEvent('items:client:drink')
AddEventHandler('items:client:drink', function(ItemName, PropName)
	if not exports['progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
		DoingSomething = true
		TriggerServerEvent('RePCore:Server:RemoveItem', ItemName, 1)
    	 	Citizen.SetTimeout(500, function()
    			exports['assets']:AddProp(PropName)
    			TriggerEvent('inventory:client:set:busy', true)
    			exports['assets']:RequestAnimationDict("amb@world_human_drinking@coffee@male@idle_a")
    			TaskPlayAnim(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    	 		RePCore.Functions.Progressbar("drink", "Пийваме..", 10000, false, true, {
    	 			disableMovement = false,
    	 			disableCarMovement = false,
    	 			disableMouse = false,
    	 			disableCombat = true,
    			 }, {}, {}, {}, function() -- Done
					 DoingSomething = false
    				 exports['assets']:RemoveProp()
    				 TriggerEvent('inventory:client:set:busy', false)
    				 TriggerEvent("inventory:client:ItemBox", RePCore.Shared.Items[ItemName], "remove")
    				 StopAnimTask(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    				 TriggerServerEvent("RePCore:Server:SetMetaData", "thirst", RePCore.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
    			 end, function()
					DoingSomething = false
    				exports['assets']:RemoveProp()
    				TriggerEvent('inventory:client:set:busy', false)
    	 			RePCore.Functions.Notify("Отказано..", "error")
    				StopAnimTask(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    	 		end)
    	 	end)
		end
	end
end)

RegisterNetEvent('items:client:drink:slushy')
AddEventHandler('items:client:drink:slushy', function()
	if not exports['progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
		DoingSomething = true
    		Citizen.SetTimeout(500, function()
    			exports['assets']:AddProp('Cup')
    			exports['assets']:RequestAnimationDict("amb@world_human_drinking@coffee@male@idle_a")
				TriggerServerEvent('RePCore:Server:RemoveItem', 'slushy', 1)
    			TaskPlayAnim(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    			TriggerEvent('inventory:client:set:busy', true)
    			RePCore.Functions.Progressbar("drink", "Пийваме..", 10000, false, true, {
    				disableMovement = false,
    				disableCarMovement = false,
    				disableMouse = false,
    				disableCombat = true,
    			 }, {}, {}, {}, function() -- Done
					DoingSomething = false
    				 exports['assets']:RemoveProp()
    				 TriggerEvent('inventory:client:set:busy', false)
    				 TriggerServerEvent('hud:server:remove:stress', math.random(6, 12))
    				 TriggerEvent("inventory:client:ItemBox", RePCore.Shared.Items['slushy'], "remove")
    				 StopAnimTask(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    				 TriggerServerEvent("RePCore:Server:SetMetaData", "thirst", RePCore.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
    			 end, function()
					DoingSomething = false
    				exports['assets']:RemoveProp()
    				TriggerEvent('inventory:client:set:busy', false)
    				RePCore.Functions.Notify("Отказано..", "error")
    				StopAnimTask(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    			end)
    		end)
		end
	end
end)

RegisterNetEvent('items:client:eat')
AddEventHandler('items:client:eat', function(ItemName, PropName)
	if not exports['progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
		DoingSomething = true
		TriggerServerEvent('RePCore:Server:RemoveItem', ItemName, 1)
 			Citizen.SetTimeout(500, function()
				exports['assets']:AddProp(PropName)
				TriggerEvent('inventory:client:set:busy', true)
				exports['assets']:RequestAnimationDict("mp_player_inteat@burger")
				TaskPlayAnim(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
 				RePCore.Functions.Progressbar("eat", "Хапваме..", 10000, false, true, {
 					disableMovement = false,
 					disableCarMovement = false,
 					disableMouse = false,
 					disableCombat = true,
				 }, {}, {}, {}, function() -- Done
					 DoingSomething = false
					 exports['assets']:RemoveProp()
					 TriggerEvent('inventory:client:set:busy', false)
					 StopAnimTask(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
					 TriggerEvent("inventory:client:ItemBox", RePCore.Shared.Items[ItemName], "remove")
					 if ItemName == 'burger-heartstopper' then
						TriggerServerEvent("RePCore:Server:SetMetaData", "hunger", RePCore.Functions.GetPlayerData().metadata["hunger"] + math.random(40, 50))
					 else
						TriggerServerEvent("RePCore:Server:SetMetaData", "hunger", RePCore.Functions.GetPlayerData().metadata["hunger"] + math.random(20, 35))
					 end
				 	end, function()
					DoingSomething = false
					exports['assets']:RemoveProp()
					TriggerEvent('inventory:client:set:busy', false)
 					RePCore.Functions.Notify("Отказано..", "error")
					StopAnimTask(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
 				end)
 			end)
		end
	end
end)

RegisterNetEvent("items:client:beer")
AddEventHandler("items:client:beer", function(itemName)
    TriggerEvent('animations:client:EmoteCommandStart', {"drink"})

    local playerPed = PlayerPedId()
	local prop_name = 'prop_amb_beer_bottle'
	local x,y,z = table.unpack(GetEntityCoords(playerPed))
	local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
    local boneIndex = GetPedBoneIndex(playerPed, 18905)
   AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)
   -- AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

   TriggerServerEvent("RePCore:Server:RemoveItem", itemName, 1)
    RePCore.Functions.Progressbar("snort_coke", "Пийваме уйскинце..", math.random(3000, 6000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerEvent("inventory:client:ItemBox", RePCore.Shared.Items[itemName], "remove")
        DeleteObject(prop)
        AlcoholEffect()
        TriggerServerEvent("RePCore:Server:SetMetaData", "thirst", RePCore.Functions.GetPlayerData().metadata["thirst"] + math.random(10, 15))
        alcoholCount = alcoholCount + 1
        if alcoholCount > 1 and alcoholCount < 4 then
            TriggerEvent("police:client:SetStatus", "alcohol", 200)
        elseif alcoholCount >= 4 then
            TriggerEvent("police:client:SetStatus", "heavyalcohol", 200)
        end
        
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        
        RePCore.Functions.Notify("Отменено..", "error")
    end)
end)

RegisterNetEvent("items:client:whiskey")
AddEventHandler("items:client:whiskey", function(itemName)
    TriggerEvent('animations:client:EmoteCommandStart', {"drink"})

    local playerPed = PlayerPedId()
	local prop_name = 'prop_cs_whiskey_bottle'
	local x,y,z = table.unpack(GetEntityCoords(playerPed))
	local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
    local boneIndex = GetPedBoneIndex(playerPed, 18905)
	TriggerServerEvent("RePCore:Server:RemoveItem", itemName, 1)
   AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)
   -- AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)


    RePCore.Functions.Progressbar("snort_coke", "Пийваме уйскинце..", math.random(3000, 6000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerEvent("inventory:client:ItemBox", RePCore.Shared.Items[itemName], "remove")
        DeleteObject(prop)
        AlcoholEffect()
        TriggerServerEvent("RePCore:Server:SetMetaData", "thirst", RePCore.Functions.GetPlayerData().metadata["thirst"] + math.random(10, 15))
        alcoholCount = alcoholCount + 1
        if alcoholCount > 1 and alcoholCount < 4 then
            TriggerEvent("police:client:SetStatus", "alcohol", 200)
        elseif alcoholCount >= 4 then
            TriggerEvent("police:client:SetStatus", "heavyalcohol", 200)
        end
        
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        
        RePCore.Functions.Notify("Отменено..", "error")
    end)
end)

RegisterNetEvent("items:client:vodka")
AddEventHandler("items:client:vodka", function(itemName)
    TriggerEvent('animations:client:EmoteCommandStart', {"drink"})

    local playerPed = PlayerPedId()
	local prop_name = 'prop_cs_whiskey_bottle'
	local x,y,z = table.unpack(GetEntityCoords(playerPed))
	local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
    local boneIndex = GetPedBoneIndex(playerPed, 18905)
    AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)
   -- AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)
    

    RePCore.Functions.Progressbar("snort_coke", "Пийваме водчица..", math.random(3000, 6000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerEvent("inventory:client:ItemBox", RePCore.Shared.Items[itemName], "remove")
        
        TriggerServerEvent("RePCore:Server:RemoveItem", itemName, 1)
        
        DeleteObject(prop)
        AlcoholEffect()
        TriggerServerEvent("RePCore:Server:SetMetaData", "thirst", RePCore.Functions.GetPlayerData().metadata["thirst"] + math.random(10, 15))
        alcoholCount = alcoholCount + 1
        if alcoholCount > 1 and alcoholCount < 4 then
            TriggerEvent("police:client:SetStatus", "alcohol", 200)
        elseif alcoholCount >= 4 then
            TriggerEvent("police:client:SetStatus", "heavyalcohol", 200)
        end
        
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        
        RePCore.Functions.Notify("Отменено..", "error")
    end)
end)

RegisterNetEvent('smoking:cigarette')
AddEventHandler('smoking:cigarette', function()
	RePCore.Functions.TriggerCallback('RePCore:HasItem', function(HasItem)
		if HasItem then
  			Citizen.SetTimeout(1000, function()
				TriggerServerEvent('RePCore:Server:RemoveItem', 'cigarette', 1)
				TriggerEvent('animations:client:EmoteCommandStart', {"smoke"})
    			TriggerEvent('inventory:client:set:busy', true)
    			local ped = PlayerPedId();
    			RePCore.Functions.Progressbar("cigarette", "Запалване на цигарата..", 9700, false, true, {
    			disableMovement = false,
    			disableCarMovement = false,
    			disableMouse = false,
    			disableCombat = true,
    			}, {}, {}, {}, function() -- Done
					TriggerEvent('animations:client:EmoteCommandStart', {"smoke"})
    			    WeedTime = 15
    			    TriggerEvent('inventory:client:set:busy', false)
    			    TriggerEvent("inventory:client:ItemBox", RePCore.Shared.Items["cigarette"], "remove")
    			  end, function() -- Cancel
    			    TriggerEvent('inventory:client:set:busy', false)
    			    RePCore.Functions.Notify("Отменено..", "error")
    			end)
  			end)
		else
            RePCore.Functions.Notify("Трябва Ви нещо с което да я запалите..", 'error')
        end
    end, 'lighter')
end)

RegisterNetEvent('laptop:use')
AddEventHandler('laptop:use', function()
	local ped = PlayerPedId();
	print("TurboOS")
			RePCore.Functions.Notify("Нямаш интернет..", "error")
end)

RegisterNetEvent('items:client:use:armor')
AddEventHandler('items:client:use:armor', function()
	if not exports['progressbar']:GetTaskBarStatus() then
 		local CurrentArmor = GetPedArmour(PlayerPedId())
 		if CurrentArmor <= 100 and CurrentArmor + 50 <= 100 then
			local NewArmor = CurrentArmor + 50
			if CurrentArmor + 33 >= 100 or CurrentArmor >= 100 then NewArmor = 100 end
			TriggerServerEvent('RePCore:Server:RemoveItem', 'armor', 1)
			 TriggerEvent('inventory:client:set:busy', true)
 		    RePCore.Functions.Progressbar("vest", "Слагаме жилетка..", 10000, false, true, {
 		    	disableMovement = false,
 		    	disableCarMovement = false,
 		    	disableMouse = false,
 		    	disableCombat = true,
 		    }, {}, {}, {}, function() -- Done
 		  	 	 SetPedArmour(PlayerPedId(), NewArmor)
				 TriggerEvent('inventory:client:set:busy', false)
 		   	 TriggerEvent("inventory:client:ItemBox", RePCore.Shared.Items['armor'], "remove")
				 TriggerServerEvent('hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
 		    	 RePCore.Functions.Notify("Успешно сложихте бронежилетката", "success")
 		    end, function()
				TriggerEvent('inventory:client:set:busy', false)
 		    	RePCore.Functions.Notify("Отказано..", "error")
 		    end)
 		else
			RePCore.Functions.Notify("Вече имате жилетка..", "error")
 		end
	end
end)

RegisterNetEvent("items:client:use:heavy")
AddEventHandler("items:client:use:heavy", function()
	if not exports['progressbar']:GetTaskBarStatus() then
    	local Sex = "Man"
    	if RePCore.Functions.GetPlayerData().charinfo.gender == 1 then
    	  Sex = "Vrouw"
    	end
		TriggerServerEvent('RePCore:Server:RemoveItem', 'heavy-armor', 1)
		TriggerEvent('inventory:client:set:busy', true)
    	RePCore.Functions.Progressbar("use_heavyarmor", "Слагаме бронежилетка..", 5000, false, true, {
    	disableMovement = false,
    	disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function() -- Done
			TriggerEvent('inventory:client:set:busy', false)
			TriggerEvent("inventory:client:ItemBox", RePCore.Shared.Items['heavy-armor'], "remove")
    	    if Sex == 'Man' then
    	    currentVest = GetPedDrawableVariation(PlayerPedId(), 9)
    	    currentVestTexture = GetPedTextureVariation(PlayerPedId(), 9)
    	    if GetPedDrawableVariation(PlayerPedId(), 9) == 7 then
    	        SetPedComponentVariation(PlayerPedId(), 9, 19, GetPedTextureVariation(PlayerPedId(), 9), 2)
    	    else
    	        SetPedComponentVariation(PlayerPedId(), 9, 5, 0, 2)
    	    end
    	    SetPedArmour(PlayerPedId(), 100)
    	  else
    	    currentVest = GetPedDrawableVariation(PlayerPedId(), 9)
    	    currentVestTexture = GetPedTextureVariation(PlayerPedId(), 9)
    	    if GetPedDrawableVariation(PlayerPedId(), 9) == 7 then
    	        SetPedComponentVariation(PlayerPedId(), 9, 20, GetPedTextureVariation(PlayerPedId(), 9), 2)
    	    else
    	        SetPedComponentVariation(PlayerPedId(), 9, 5, 0, 2)
    	    end
			SetPedArmour(PlayerPedId(), 100)
			TriggerServerEvent('hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
    	  end
		end, function() -- Cancel
    	    TriggerEvent('inventory:client:set:busy', false)
    	    RePCore.Functions.Notify("Отказано..", "error")
    	end)
	end
end)

RegisterNetEvent("items:client:reset:armor")
AddEventHandler("items:client:reset:armor", function()
	if not exports['progressbar']:GetTaskBarStatus() then
    	local ped = PlayerPedId()
    	if currentVest ~= nil and currentVestTexture ~= nil then 
    	    RePCore.Functions.Progressbar("remove-armor", "Сваляме бронежилетка..", 2500, false, false, {
    	        disableMovement = false,
    	        disableCarMovement = false,
    	        disableMouse = false,
    	        disableCombat = true,
    	    }, {}, {}, {}, function() -- Done
    	        SetPedComponentVariation(PlayerPedId(), 9, currentVest, currentVestTexture, 2)
    	        SetPedArmour(PlayerPedId(), 0)
				TriggerServerEvent('items:server:giveitem', 'heavy-armor', 1)
				TriggerServerEvent('hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
				currentVest, currentVestTexture = nil, nil
    	    end)
    	else
    	    RePCore.Functions.Notify("Нямате сложена бронежилетка..", "error")
    	end
	end
end)

RegisterNetEvent('items:client:use:repairkit')
AddEventHandler('items:client:use:repairkit', function()
	if not exports['progressbar']:GetTaskBarStatus() then
		local PlayerCoords = GetEntityCoords(PlayerPedId())
		local Vehicle, Distance = RePCore.Functions.GetClosestVehicle()
		if GetVehicleEngineHealth(Vehicle) < 1000.0 then
			NewHealth = GetVehicleEngineHealth(Vehicle) + 250.0
			if GetVehicleEngineHealth(Vehicle) + 250.0 > 1000.0 then 
				NewHealth = 1000.0 
			end
			if Distance < 4.0 and not IsPedInAnyVehicle(PlayerPedId()) then
				local EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, 2.5, 0)
				if IsBackEngine(GetEntityModel(Vehicle)) then
				  EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, -2.5, 0)
				end
			if GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, EnginePos) < 4.0 then
				local VehicleDoor = nil
				if IsBackEngine(GetEntityModel(Vehicle)) then
					VehicleDoor = 5
				else
					VehicleDoor = 4
				end
				SetVehicleDoorOpen(Vehicle, VehicleDoor, false, false)
				TriggerServerEvent('RePCore:Server:RemoveItem', 'repairkit', 1)
				Citizen.Wait(450)
				TriggerEvent('inventory:client:set:busy', true)
				RePCore.Functions.Progressbar("repair_vehicle", "Поправяме..", math.random(10000, 20000), false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mini@repair",
					anim = "fixing_a_player",
					flags = 16,
				}, {}, {}, function() -- Done
					if math.random(1,50) < 10 then
					  TriggerEvent("inventory:client:ItemBox", RePCore.Shared.Items['repairkit'], "remove")
					end
					TriggerEvent('inventory:client:set:busy', false)
					SetVehicleDoorShut(Vehicle, VehicleDoor, false)
					StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
					RePCore.Functions.Notify("МПС поправено!")
					SetVehicleEngineHealth(Vehicle, NewHealth) 
					for i = 1, 6 do
					 SetVehicleTyreFixed(Vehicle, i)
					end
				end, function() -- Cancel
					TriggerEvent('inventory:client:set:busy', false)
					StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
					RePCore.Functions.Notify("Неуспешно!", "error")
					SetVehicleDoorShut(Vehicle, VehicleDoor, false)
				end)
			end
		 else
			RePCore.Functions.Notify("Няма МПС?!?", "error")
		end
		end	
	end
end)

RegisterNetEvent('items:client:use:neon')
AddEventHandler('items:client:use:neon', function()
	if not exports['progressbar']:GetTaskBarStatus() then
		local PlayerCoords = GetEntityCoords(PlayerPedId())
		local Vehicle, Distance = RePCore.Functions.GetClosestVehicle()
		if GetVehicleEngineHealth(Vehicle) < 1000.0 then
			NewHealth = GetVehicleEngineHealth(Vehicle) + 250.0
			if GetVehicleEngineHealth(Vehicle) + 250.0 > 1000.0 then 
				NewHealth = 1000.0 
			end
			if Distance < 4.0 and not IsPedInAnyVehicle(PlayerPedId()) then
				local EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, 2.5, 0)
				if IsBackEngine(GetEntityModel(Vehicle)) then
				  EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, -2.5, 0)
				end
			if GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, EnginePos) < 4.0 then
				local VehicleDoor = nil
				if IsBackEngine(GetEntityModel(Vehicle)) then
					VehicleDoor = 5
				else
					VehicleDoor = 4
				end
				SetVehicleDoorOpen(Vehicle, VehicleDoor, false, false)
				Citizen.Wait(450)
				TriggerEvent('inventory:client:set:busy', true)
				RePCore.Functions.Progressbar("repair_vehicle", "Поправяме..", math.random(10000, 20000), false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mini@repair",
					anim = "fixing_a_player",
					flags = 16,
				}, {}, {}, function() -- Done
					if math.random(1,50) < 10 then
					  TriggerServerEvent('RePCore:Server:RemoveItem', 'repairkit', 1)
					  TriggerEvent("inventory:client:ItemBox", TurboCore.Shared.Items['repairkit'], "remove")
					end
					TriggerEvent('inventory:client:set:busy', false)
					SetVehicleDoorShut(Vehicle, VehicleDoor, false)
					StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
					TurboCore.Functions.Notify("МПС поправено!")
					SetVehicleEngineHealth(Vehicle, NewHealth) 
					for i = 1, 6 do
						SetVehicleNeonLightEnabled(Vehicle,0,true)
						SetVehicleNeonLightEnabled(Vehicle,1,true)
						SetVehicleNeonLightEnabled(Vehicle,2,true)
						SetVehicleNeonLightEnabled(Vehicle,3,true)
						Citizen.Wait(300)
						SetVehicleNeonLightsColour(Vehicle,0,0,255)
					end
				end, function() -- Cancel
					TriggerEvent('inventory:client:set:busy', false)
					StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
					RePCore.Functions.Notify("Неуспешно!", "error")
					SetVehicleDoorShut(Vehicle, VehicleDoor, false)
				end)
			end
		 else
			RePCore.Functions.Notify("Няма МПС?!?", "error")
		end
		end	
	end
end)

RegisterNetEvent('items:client:dice')
AddEventHandler('items:client:dice', function(Amount, Sides)
	local DiceResult = {}
	for i = 1, Amount do
		table.insert(DiceResult, math.random(1, Sides))
	end
	local RollText = CreateRollText(DiceResult, Sides)
	TriggerEvent('items:client:dice:anim')
	Citizen.SetTimeout(1900, function()
		TriggerServerEvent('sound:server:play:distance', 2.0, 'dice', 0.5)
		TriggerServerEvent('assets:server:display:text', RollText)
	end)
end)

RegisterNetEvent('items:client:coinflip')
AddEventHandler('items:client:coinflip', function()
	local CoinFlip = {}
	local Random = math.random(1,2)
     if Random <= 1 then
		CoinFlip = 'Монета: ~g~Ези'	-- Kop
     else
		CoinFlip = 'Монета: ~y~Тура'	-- Munt
	 end
	 TriggerEvent('items:client:dice:anim')
	 Citizen.SetTimeout(1900, function()
		TriggerServerEvent('sound:server:play:distance', 2.0, 'coin', 0.5)
		TriggerServerEvent('assets:server:display:text', CoinFlip)
	 end)
end)

RegisterNetEvent('items:client:dice:anim')
AddEventHandler('items:client:dice:anim', function()
	exports['assets']:RequestAnimationDict("anim@mp_player_intcelebrationmale@wank")
    TaskPlayAnim(PlayerPedId(), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Citizen.Wait(1500)
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('items:client:use:duffel-bag')
AddEventHandler('items:client:use:duffel-bag', function(BagId)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", 'tas_'..BagId, {maxweight = 25000, slots = 3})
    TriggerEvent("inventory:client:SetCurrentStash", 'tas_'..BagId)
end)

RegisterNetEvent('clean:kit')
AddEventHandler('clean:kit', function()
	local ply = GetPlayerPed(-1)
	local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local vehicle = nil
		if IsPedInAnyVehicle(ped, false) then vehicle = GetVehiclePedIsIn(ped, false) else vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71) end
			if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(ply, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
			Progressbar(10000,"ПОЛИРАНЕ")
			SetVehicleDirtLevel(vehicle, 0.2)
			TriggerServerEvent('RePCore:Server:RemoveItem', "cleaningkit", 1)
			TriggerEvent("inventory:client:ItemBox", RePCore.Shared.Items["cleaningkit"], "remove")
	end
end)

function Progressbar(duration, label)
	local retval = nil
	RePCore.Functions.Progressbar("clean", label, duration, false, false, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function()
		retval = true
	end, function()
		retval = false
	end)

	while retval == nil do
		Wait(1)
	end

	return retval
end

--  // Functions \\ --

function IsBackEngine(Vehicle)
    for _, model in pairs(Config.BackEngineVehicles) do
        if GetHashKey(model) == Vehicle then
            return true
        end
    end
    return false
end

function StaminaEffect()
	local startStamina = 20
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
	while startStamina > 0 do 
		Citizen.Wait(1000)
		if math.random(1, 100) < 20 then
			RestorePlayerStamina(PlayerId(), 1.0)
		end
		startStamina = startStamina - 1
		if math.random(1, 100) < 10 and IsPedRunning(PlayerPedId()) then
			SetPedToRagdoll(PlayerPedId(), math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
		end
	end
	if IsPedRunning(PlayerPedId()) then
	  SetPedToRagdoll(PlayerPedId(), math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
	end
	startStamina = 0
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
  end

function AlcoholEffect()
    local onAlcohol = true
    local alcoholTime = 25
   -- local RelieveOdd = math.random(35, 45)
    --Citizen.CreateThread(function()
    local playerPed = GetPlayerPed(-1)
    local maxHealth = GetEntityMaxHealth(playerPed)
    RequestAnimSet('move_m@drunk@moderatedrunk')
    while not HasAnimSetLoaded('move_m@drunk@moderatedrunk') do
      Citizen.Wait(1)
    end
    Citizen.Wait(3000)
    SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk",1.0) 
    ClearPedTasksImmediately(playerPed)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(playerPed, true)
    --SetPedMovementClipset(playerPed, "move_m@drunk@verydrunk", true)
    
       while onAlcohol do 
            SetPlayerHealthRechargeMultiplier(PlayerId(), 1.8)
            local playerPed = GetPlayerPed(-1)
            local maxHealth = GetEntityMaxHealth(playerPed)
          --  SetPedMovementClipset(ped, "move_m@drunk@verydrunk", 1 )
           --SetPedIsDrug(playerPed, true)
            Citizen.Wait(2000)
            alcoholTime = alcoholTime - 1
            if alcoholTime <= 0 then
                onAlcohol = false
                print('movement set')
                ClearTimecycleModifier()
                ResetScenarioTypesEnabled()
               -- ResetPedMovementClipset(ped, 0) <- it might cause the push of the vehicles
               -- SetPedIsDrug(playerPed, false)
                SetPedMotionBlur(playerPed, false)
                TriggerServerEvent('hud:server:remove:stress', math.random(6, 12))
           end
        end
    --end)
end

function CreateRollText(rollTable, sides)
    local s = "~g~Зарчета~s~: "	--Gedobbled
    local total = 0
    for k, roll in pairs(rollTable, sides) do
        total = total + roll
        if k == 1 then
            s = s .. roll .. "/" .. sides
        else
            s = s .. " | " .. roll .. "/" .. sides
        end
    end
    s = s .. " | (Общо: ~g~"..total.."~s~)"
    return s
end