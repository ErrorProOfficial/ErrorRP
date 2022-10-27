local DisplayCount = 0
GLOBAL_PED = PlayerPedId()

RePCore = nil

local HasPhone = true
local gpsShown = false

RegisterNetEvent('RePCore:Client:OnPlayerLoaded')
AddEventHandler('RePCore:Client:OnPlayerLoaded', function()
	TriggerEvent("RePCore:GetObject", function(obj) RePCore = obj end) 
	Citizen.Wait(150)
	NetworkSetFriendlyFireOption(true)
	SetCanAttackFriendly(PlayerPedId(), true, true)
end)

AddEventHandler('rep-core:client:receivePlayerPedId', function(receivedPed)
    GLOBAL_PED = receivedPed
end)

-- Code

-- // Events \\ --
-- Pvp Enable

RegisterNetEvent('assets:client:me:show')
AddEventHandler('assets:client:me:show', function(Text, Source)
  local PlayerId = GetPlayerFromServerId(Source)
  local IsDisplaying = true
  Citizen.CreateThread(function()
    local DisplayOffset = 0 + (DisplayCount * 0.14)
    DisplayCount = DisplayCount + 1
    while IsDisplaying do
      Citizen.Wait(0)
      local SourceCoords = GetEntityCoords(GetPlayerPed(PlayerId))
      local NearCoords = GetEntityCoords(GLOBAL_PED)
      local Distance = Vdist2(SourceCoords, NearCoords)
      if Distance < 25.0 then
        DrawText3D(SourceCoords.x, SourceCoords.y, SourceCoords.z + DisplayOffset, Text)
      end
    end
    DisplayCount = DisplayCount - 1
  end)
  Citizen.CreateThread(function()
   Citizen.Wait(6500)
   IsDisplaying = false
  end)
end)


-- ТРЯБВА ДА СЕ КОНФИГУРИРА
-- Citizen.CreateThread(function()
-- 	while true do
-- 		SetDiscordAppId(APPID)

-- 		SetDiscordRichPresenceAsset('logo_name')
--         SetDiscordRichPresenceAssetText('СЕЗОН 4 Е ТУК!')
--         SetDiscordRichPresenceAssetSmall('logo_name')
--         SetDiscordRichPresenceAssetSmallText('Влез и се забавлявай!')
--         SetDiscordRichPresenceAction(0, "Влез в дискорд!", "https://discord.gg/TBBmH8vc")
--         SetRichPresence(tonumber(#GetActivePlayers()) .. '/' .. tonumber(GetConvarInt('sv_maxclients', 64)))
-- 		Citizen.Wait(5000)
-- 	end
-- end)

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

-- // AntiAFK \\ --

secondsUntilKick = 1200

kickWarning = true

Citizen.CreateThread(function()
	while true do
		Wait(1000)

		playerPed = PlayerPedId()
		if playerPed then
			currentPos = GetEntityCoords(playerPed, true)

			if currentPos == prevPos then
				if time > 0 then
					if kickWarning and time == math.ceil(secondsUntilKick / 4) then
						--TriggerEvent("chatMessage", "WARNING", {255, 0, 0}, "^1Ще бъдеш кикнат от сървъра след" .. time .. " Ако продължаваш да бъдеш AFK!")
                        RePCore.Functions.Notify("Ще бъдеш кикнат от сървъра след" .. time .. " Ако продължаваш да бъдеш AFK!", 'error', 3500)
					end

					time = time - 1
				else
					TriggerServerEvent("kickForBeingAnAFKDouchebag")
				end
			else
				time = secondsUntilKick
			end

			prevPos = currentPos
		end
	end
end)
-- // AntiAFK \\ --

-- // AntiBhop \\ --

local ragdoll_chance = 0.7 

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100) 
		if IsPedOnFoot(GLOBAL_PED) and not IsPedSwimming(GLOBAL_PED) and (IsPedRunning(GLOBAL_PED) or IsPedSprinting(GLOBAL_PED)) and not IsPedClimbing(GLOBAL_PED) and IsPedJumping(GLOBAL_PED) and not IsPedRagdoll(GLOBAL_PED) then
			local chance_result = math.random()
			if chance_result < ragdoll_chance then 
				Citizen.Wait(600) 
				SetPedToRagdoll(GLOBAL_PED, 5000, 1, 2)
			else
				Citizen.Wait(2000) 
			end
		end
	end
end)

-- // AntiBhop \\ --

-- // Brighter Lights \\ --

--[[
function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

local function starts_with(str, start)
   return str:sub(1, #start) == start
end

Citizen.CreateThread(function()
	local settingsFile = LoadResourceFile(GetCurrentResourceName(), "misc/visualsettings.dat")
	local lines = stringsplit(settingsFile, "\n")
	for k,v in ipairs(lines) do
		if not starts_with(v, '#') and not starts_with(v, '//') and (v ~= "" or v ~= " ") and #v > 1 then
			v = v:gsub("%s+", " ")
			local setting = stringsplit(v, " ")
			if setting[1] ~= nil and setting[2] ~= nil and tonumber(setting[2]) ~= nil then
				if setting[1] ~= 'weather.CycleDuration' then	
					Citizen.InvokeNative(GetHashKey('SET_VISUAL_SETTING_FLOAT') & 0xFFFFFFFF, setting[1], tonumber(setting[2])+.0)
				end
			end
		end
	end
end)
]]

Citizen.CreateThread(function()
	DisplayRadar(false)
	
	while true do
		Citizen.Wait(0)
		--RePCore.Functions.TriggerCallback('RePCore:HasItem', function(HasItem)
			--if HasItem then
			--	HasPhone = true
			--else
			--	HasPhone = false
			--end
			--local vehicle   = GetVehiclePedIsIn(playerPed, false)
			if IsEntityInWater(GLOBAL_PED) then
				gpsShown = true
				DisplayRadar(true)
			end
		
			if not IsEntityInWater(GLOBAL_PED) then
				if IsPedInAnyVehicle(GLOBAL_PED,  false) then
					if HasPhone == true then
						DisplayRadar(true)
						gpsShown = true	
					end
				else
					if gpsShown == true then
						DisplayRadar(false)
						gpsShown = false
					end
					if HasPhone == true and IsControlPressed(0, 20) then
						DisplayRadar(true)
						gpsShown = true
					else
						if gpsShown == true then
							DisplayRadar(false)
							gpsShown = false
						end
					end
				end
			end
		--end, 'phone')
	end
end)


-- ДОБАВКА ДА ПОКАЗВА ПО-ГОЛЯМА КАРТА 

Citizen.CreateThread(function()
  local toggle = false -- Create the variable which will change
  SetRadarBigmapEnabled(toggle) -- Call the function with the variable we just created (to set it to the default we want it to be; in this case false)
  while true do
    Citizen.Wait(0)
	
	if IsControlPressed(0, 21) and IsControlJustReleased(0, 323) then -- Смяна на бутоните да е с SHIFT и X вместо само Z
--    if IsControlJustReleased(0, 20) then -- Checking if it was released rather than pressed is better
      toggle = not toggle -- Invert current value of the variable (not true = false, not false = true)
      SetRadarBigmapEnabled(toggle) -- Call the function again with the same variable (which should now be inverted)
    end
  end
end)

-- КРАЙ НА ДОБАВКАТА




Citizen.CreateThread(function()
	SetWeaponDamageModifier(GetHashKey('WEAPON_UNARMED'), 0.3)
	SetWeaponDamageModifier(GetHashKey('WEAPON_NIGHTSTICK'), 0.3)
	-- Melee
	SetWeaponDamageModifier(GetHashKey('WEAPON_FLASHLIGHT'), 0.4)
	SetWeaponDamageModifier(GetHashKey('WEAPON_HAMMER'), 0.4)
	SetWeaponDamageModifier(GetHashKey('WEAPON_HATCHET'), 0.4)
	SetWeaponDamageModifier(GetHashKey('WEAPON_SWITCHBLADE'), 0.4)
	SetWeaponDamageModifier(GetHashKey('WEAPON_WRENCH'), 0.4)
	SetWeaponDamageModifier(GetHashKey('WEAPON_BREAD'), 0.4)
end)

RegisterNUICallback('CheckDevtools', function()
   TriggerServerEvent('assets:server:drop')
end)

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

local noclip = false
local noclip_speed = 1.0

RegisterNetEvent('noclip:mouse')
AddEventHandler('noclip:mouse', function(truefalse)
    noclip = not noclip
end)

getPosition = function()
    local x,y,z = table.unpack(GetEntityCoords(GLOBAL_PED,true))
    return x,y,z
end

getCamDirection = function()
    local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GLOBAL_PED)
    local pitch = GetGameplayCamRelativePitch()
    local x = -math.sin(heading*math.pi/180.0)
    local y = math.cos(heading*math.pi/180.0)
    local z = math.sin(pitch*math.pi/180.0)
    local len = math.sqrt(x*x+y*y+z*z)
    if len ~= 0 then
        x = x/len
        y = y/len
        z = z/len
    end
    return x,y,z
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if (noclip) then
            local x,y,z = getPosition()
            local dx,dy,dz = getCamDirection()
            local speed = noclip_speed
            SetEntityVisible(GLOBAL_PED, false, false)
            SetEntityInvincible(GLOBAL_PED, true) --asd
            if IsPedInAnyVehicle(GLOBAL_PED, false) then
                target = GetVehiclePedIsIn(GLOBAL_PED)
                SetEntityVisible(target, false, false)
                SetEntityInvincible(target, true)
                SetEntityAsMissionEntity(target)
            end
            SetEntityVelocity(GLOBAL_PED, 0.0001, 0.0001, 0.0001)
            SetEntityVelocity(target, 0.0001, 0.0001, 0.0001)
            if IsControlPressed(0, 21) then
                speed = speed + 5
            end
            if IsControlPressed(0, 326) then  
                speed = speed - 0.7	
            end
            if IsControlPressed(0,32) then
                x = x+speed*dx
                y = y+speed*dy
                z = z+speed*dz
            end
            if IsControlPressed(0,269) then 
                x = x-speed*dx
                y = y-speed*dy
                z = z-speed*dz
            end
            SetEntityCoordsNoOffset(GLOBAL_PED,x,y,z,true,true,true)
            SetEntityCoordsNoOffset(target, x , y , z , true , true , true )
        else
			SetPedIntoVehicle(GLOBAL_PED,target,-1)
            SetEntityVisible(GLOBAL_PED, true, false)
            SetEntityInvincible(GLOBAL_PED, false)
			SetEntityVisible(target, true, false)
            SetEntityInvincible(target, false)
			target = nil
            Citizen.Wait(1500)
        end
	end
end)

function getPlayers()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        table.insert(players, {id = GetPlayerServerId(player), name = GetPlayerName(player)})
    end
    return players
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
--        if GetDistanceBetweenCoords( -1452.16, -540.6957, 74.044433, GetEntityCoords(GLOBAL_PED)) < 2.0 then
--            SetEntityCoordsNoOffset(GLOBAL_PED,-1447.521, -537.8173, 34.740154, false, false, false)
        if GetDistanceBetweenCoords( -328.56, -1048.93, 33.56, GetEntityCoords(GLOBAL_PED)) < 2.0 then
            SetEntityCoordsNoOffset(GLOBAL_PED,-288.61, -1081.05, 23.03, false, false, false)
        end
    end
end)

streets = false
RegisterCommand("s1", function()

	streets = true
	comp = true

end)

RegisterCommand("s0", function()

	streets = false
	comp = false

end)


 local streetName = {}


 streetName.show = true
 streetName.position = {x = 0.25, y = 0.94, centered = true}
 streetName.textSize = 0.30
 streetName.textColour = {r = 255, g = 255, b = 255, a = 255}



 Citizen.CreateThread( function()
 	local lastStreetA = 0
 	local lastStreetB = 0
 	local lastStreetName = {}
	
 	while streetName.show do
 		Wait(0)
		
 		local playerPos = GetEntityCoords(PlayerPedId(), true )
 		local streetA, streetB = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, playerPos.x, playerPos.y, playerPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
 		local street = {}
		
 		if not ((streetA == lastStreetA or streetA == lastStreetB) and (streetB == lastStreetA or streetB == lastStreetB)) then
			lastStreetA = streetA
			lastStreetB = streetB
 		end
		
 		if lastStreetA ~= 0 then
 			table.insert( street, GetStreetNameFromHashKey( lastStreetA ) )
 		end
		
 		if lastStreetB ~= 0 then
 			table.insert( street, GetStreetNameFromHashKey( lastStreetB ) )
 		end
 		if streets == true then
 		drawText( table.concat( street, " & " ), streetName.position.x, streetName.position.y, {
 			size = streetName.textSize,
 			colour = streetName.textColour,
 			outline = true,
 			centered = streetName.position.centered
 		})
 	end
 	end
 end)

function drawText( str, x, y, style )
    if style == nil then
        style = {}
    end
    
    SetTextFont( 7 )
    SetTextScale( 0.0, (style.size ~= nil) and style.size or 1.0 )
    SetTextProportional( 1 )
    
    if style.colour ~= nil then
        SetTextColour( style.colour.r ~= nil and style.colour.r or 255, style.colour.g ~= nil and style.colour.g or 255, style.colour.b ~= nil and style.colour.b or 255, style.colour.a ~= nil and style.colour.a or 255 )
    else
        SetTextColour( 255, 255, 255, 255 )
    end
    
    if style.shadow ~= nil then
        SetTextDropShadow( style.shadow.distance ~= nil and style.shadow.distance or 0, style.shadow.r ~= nil and style.shadow.r or 0, style.shadow.g ~= nil and style.shadow.g or 0, style.shadow.b ~= nil and style.shadow.b or 0, style.shadow.a ~= nil and style.shadow.a or 255 )
    else
        SetTextDropShadow( 0, 0, 0, 0, 255 )
    end
    
    if style.border ~= nil then
        SetTextEdge( style.border.size ~= nil and style.border.size or 1, style.border.r ~= nil and style.border.r or 0, style.border.g ~= nil and style.border.g or 0, style.border.b ~= nil and style.border.b or 0, style.border.a ~= nil and style.shadow.a or 255 )
    end
    
    if style.centered ~= nil and style.centered == true then
        SetTextCentre( true )
    end
    
    if style.outline ~= nil and style.outline == true then
        SetTextOutline()
    end
    
    SetTextEntry( "STRING" )
    AddTextComponentString( str )
    
    DrawText( x, y )
end

local compass = { cardinal={}, intercardinal={}}
 
compass.show = true
compass.position = {x = 0.25, y = 0.96, centered = true}
compass.width = 0.15
compass.fov = 180
compass.followGameplayCam = true
 
compass.ticksBetweenCardinals = 9.0
compass.tickColour = {r = 255, g = 255, b = 255, a = 255}
compass.tickSize = {w = 0.001, h = 0.003}
 
compass.cardinal.textSize = 0.25
compass.cardinal.textOffset = 0.015
compass.cardinal.textColour = {r = 255, g = 255, b = 255, a = 255}
 
compass.cardinal.tickShow = true
compass.cardinal.tickSize = {w = 0.001, h = 0.012}
compass.cardinal.tickColour = {r = 255, g = 255, b = 255, a = 255}
 
compass.intercardinal.show = true
compass.intercardinal.textShow = true
compass.intercardinal.textSize = 0.2
compass.intercardinal.textOffset = 0.015
compass.intercardinal.textColour = {r = 255, g = 255, b = 255, a = 255}
 
compass.intercardinal.tickShow = true
compass.intercardinal.tickSize = {w = 0.001, h = 0.006}
compass.intercardinal.tickColour = {r = 255, g = 255, b = 255, a = 255}
-- End of configuration
 
 
Citizen.CreateThread( function()
    if compass.position.centered then
        compass.position.x = compass.position.x - compass.width / 2
    end
    
    while compass.show do
        Wait( 0 )
		if comp == true then
        
        local pxDegree = compass.width / compass.fov
        local playerHeadingDegrees = 0
        
        if compass.followGameplayCam then
            -- Converts [-180, 180] to [0, 360] where E = 90 and W = 270
            local camRot = Citizen.InvokeNative( 0x837765A25378F0BB, 0, Citizen.ResultAsVector() )
            playerHeadingDegrees = 360.0 - ((camRot.z + 360.0) % 360.0)
        else
            -- Converts E = 270 to E = 90
            playerHeadingDegrees = 360.0 - GetEntityHeading( GetPlayerPed( -1 ) )
        end
        
        local tickDegree = playerHeadingDegrees - compass.fov / 2
        local tickDegreeRemainder = compass.ticksBetweenCardinals - (tickDegree % compass.ticksBetweenCardinals)
        local tickPosition = compass.position.x + tickDegreeRemainder * pxDegree
        
        tickDegree = tickDegree + tickDegreeRemainder
        
        while tickPosition < compass.position.x + compass.width do
            if (tickDegree % 90.0) == 0 then
                -- Draw cardinal
                if compass.cardinal.tickShow then
                    DrawRect( tickPosition, compass.position.y, compass.cardinal.tickSize.w, compass.cardinal.tickSize.h, compass.cardinal.tickColour.r, compass.cardinal.tickColour.g, compass.cardinal.tickColour.b, compass.cardinal.tickColour.a )
                end
                
                drawText( degreesToIntercardinalDirection( tickDegree ), tickPosition, compass.position.y + compass.cardinal.textOffset, {
                    size = compass.cardinal.textSize,
                    colour = compass.cardinal.textColour,
                    outline = true,
                    centered = true
                })
            elseif (tickDegree % 45.0) == 0 and compass.intercardinal.show then
                -- Draw intercardinal
                if compass.intercardinal.tickShow then
                    DrawRect( tickPosition, compass.position.y, compass.intercardinal.tickSize.w, compass.intercardinal.tickSize.h, compass.intercardinal.tickColour.r, compass.intercardinal.tickColour.g, compass.intercardinal.tickColour.b, compass.intercardinal.tickColour.a )
                end
                
                if compass.intercardinal.textShow then
                    drawText( degreesToIntercardinalDirection( tickDegree ), tickPosition, compass.position.y + compass.intercardinal.textOffset, {
                        size = compass.intercardinal.textSize,
                        colour = compass.intercardinal.textColour,
                        outline = true,
                        centered = true
                    })
                end
            else
                -- Draw tick
                DrawRect( tickPosition, compass.position.y, compass.tickSize.w, compass.tickSize.h, compass.tickColour.r, compass.tickColour.g, compass.tickColour.b, compass.tickColour.a )
            end
            
            -- Advance to the next tick
            tickDegree = tickDegree + compass.ticksBetweenCardinals
            tickPosition = tickPosition + pxDegree * compass.ticksBetweenCardinals
		end
        end
    end
end)
 
-- Converts degrees to (inter)cardinal directions.
-- @param1  float   Degrees. Expects EAST to be 90° and WEST to be 270°.
--                  In GTA, WEST is usually 90°, EAST is usually 270°. To convert, subtract that value from 360.
--
-- @return          The converted (inter)cardinal direction.
function degreesToIntercardinalDirection( dgr )
    dgr = dgr % 360.0
    
    if (dgr >= 0.0 and dgr < 22.5) or dgr >= 337.5 then
        return "N "
    elseif dgr >= 22.5 and dgr < 67.5 then
        return "NE"
    elseif dgr >= 67.5 and dgr < 112.5 then
        return "E"
    elseif dgr >= 112.5 and dgr < 157.5 then
        return "SE"
    elseif dgr >= 157.5 and dgr < 202.5 then
        return "S"
    elseif dgr >= 202.5 and dgr < 247.5 then
        return "SW"
    elseif dgr >= 247.5 and dgr < 292.5 then
        return "W"
    elseif dgr >= 292.5 and dgr < 337.5 then
        return "NW"
    end
end


RegisterNetEvent('pickup:bike')
AddEventHandler('pickup:bike', function()
    local playerPed = GLOBAL_PED
    local coords = GetEntityCoords(playerPed)
    local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
    local bone = GetPedBoneIndex(playerPed, 0xE5F3)
    local bike = false

    if GetEntityModel(vehicle) == GetHashKey("bmx") or GetEntityModel(vehicle) == GetHashKey("scorcher") or GetEntityModel(vehicle) == GetHashKey("cruiser") or GetEntityModel(vehicle) == GetHashKey("fixter") or GetEntityModel(vehicle) == GetHashKey("tribike") or GetEntityModel(vehicle) == GetHashKey("tribike2") or GetEntityModel(vehicle) == GetHashKey("tribike3")  then

    AttachEntityToEntity(vehicle, playerPed, bone, 0.0, 0.24, 0.10, 340.0, 330.0, 330.0, true, true, false, true, 1, true)
    TurboCore.Functions.Notify("Натисни G за да пуснеш колелото", 'error')

    RequestAnimDict("anim@heists@box_carry@")
    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do Citizen.Wait(0) end
    TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 2.0, 2.0, 50000000, 51, 0, false, false, false)
    bike = true

    RegisterCommand('dropbike', function()
        if IsEntityAttached(vehicle) then
        DetachEntity(vehicle, nil, nil)
        SetVehicleOnGroundProperly(vehicle)
        ClearPedTasksImmediately(playerPed)
        bike = false

        end
    end, false)

        RegisterKeyMapping('dropbike', 'Drop Bike', 'keyboard', 'g')

                Citizen.CreateThread(function()
                while true do
                Citizen.Wait(0)
                if bike and IsEntityPlayingAnim(playerPed, "anim@heists@box_carry@", "idle", 3) ~= 1 then
                    RequestAnimDict("anim@heists@box_carry@")
                    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do Citizen.Wait(0) end
                    TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 2.0, 2.0, 50000000, 51, 0, false, false, false)
                    if not IsEntityAttachedToEntity(playerPed, vehicle) then
                        bike = false
                        ClearPedTasksImmediately(playerPed)
                    end
                end
            end
        end)
    end
end)

Citizen.CreateThread(function()

    local bike = {
        `bmx`,
        `cruiser`,
        `scorcher`,
        `fixter`,
        `tribike`,
        `tribike2`,
        `tribike3`,
    }

    exports['-target']:AddTargetModel(bike, {
        options = {
            {
                event = "pickup:bike",
                icon = "fas fa-bicycle",
                label = "Вземи Колелото",
            },
        },
		job = {'all'},
        distance = 2.5
    })
    
end)

local ragdoll = false
function setRagdoll(flag)
  ragdoll = flag
end
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if ragdoll then
      SetPedToRagdoll(GLOBAL_PED, 1000, 1000, 0, 0, 0, 0)
    end
  end
end)

ragdol = true
RegisterNetEvent("Ragdoll")
AddEventHandler("Ragdoll", function()
	if ( ragdol ) then
		setRagdoll(true)
		ragdol = false
	else
		setRagdoll(false)
		ragdol = true
	end
end)

Citizen.CreateThread(function()
 	while true do
 		Citizen.Wait(100)
 		if ( IsControlPressed(2, 303) ) then
 			TriggerEvent("Ragdoll", source)
 		end
 	end
 end)