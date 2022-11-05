QBCore = nil

Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

isLoggedIn = true
stress = 0
PlayerJob = {}
GLOBAL_PED = PlayerPedId()

AddEventHandler('qb-core:client:receivePlayerPedId', function(receivedPed)
    GLOBAL_PED = receivedPed
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
        if QBCore ~= nil then
            TriggerEvent("hud:client:SetMoney")
            return
        end
    end
end)

RegisterNetEvent("QBCore:Client:OnPlayerUnload")
AddEventHandler("QBCore:Client:OnPlayerUnload", function()
    isLoggedIn = false
    QBHud.Show = false
    SendNUIMessage({
        action = "hudtick",
        show = true,
    })
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    isLoggedIn = true
    QBHud.Show = true
    showRoundMap()
    SetPedMaxTimeUnderwater(GLOBAL_PED, 155.00)
    PlayerJob = QBCore.Functions.GetPlayerData().job
    TriggerEvent('hud:client:UpdateVoiceProximity', 2)
end)

local StressGain = 0
local IsGaining = false

-- Citizen.CreateThread(function()
--     while true do
--         local ped = GLOBAL_PED

--         if IsPedShooting(GLOBAL_PED) then
--             local StressChance = math.random(1, 3)
--             local odd = math.random(1, 3)
--             if StressChance == odd then
--                 local PlusStress = math.random(2, 4) / 100
--                 StressGain = StressGain + PlusStress
--             end
--             if not IsGaining then
--                 IsGaining = true
--             end
--         else
--             if IsGaining then
--                 IsGaining = false
--             end
--         end

--         if (PlayerJob.name ~= "police") then
--             if IsPlayerFreeAiming(PlayerId()) and not IsPedShooting(GLOBAL_PED) then
--                 local CurrentWeapon = GetSelectedPedWeapon(ped)
--                 local WeaponData = QBCore.Shared.Items[CurrentWeapon]
--                 if WeaponData.name:upper() ~= "weapon_unarmed" then
--                     local StressChance = math.random(1, 20)
--                     local odd = math.random(1, 20)
--                     if StressChance == odd then
--                         local PlusStress = math.random(1, 3) / 100
--                         StressGain = StressGain + PlusStress
--                     end
--                 end
--                 if not IsGaining then
--                     IsGaining = true
--                 end
--             else
--                 if IsGaining then
--                     IsGaining = false
--                 end
--             end
--         end

--         Citizen.Wait(2)
--     end
-- end)

RegisterNetEvent('hud:client:UpdateStress')
AddEventHandler('hud:client:UpdateStress', function(newStress)
    stress = newStress
end)

Citizen.CreateThread(function()
    while true do
        if not IsGaining then
            StressGain = math.ceil(StressGain)
            if StressGain > 0 then
                QBCore.Functions.Notify('Чувствате се стресиран', "primary", 2000)
                TriggerServerEvent('hud:Server:UpdateStress', StressGain)
                StressGain = 0
            end
        end

        Citizen.Wait(3000)
    end
end)

function GetShakeIntensity(stresslevel)
    local retval = 0.05
    for k, v in pairs(QBStress.Intensity["shake"]) do
        if stresslevel >= v.min and stresslevel < v.max then
            retval = v.intensity
            break
        end
    end
    return retval
end

function GetEffectInterval(stresslevel)
    local retval = 23000
    for k, v in pairs(QBStress.EffectInterval) do
        if stresslevel >= v.min and stresslevel < v.max then
            retval = v.timeout
            break
        end
    end
    return retval
end

Citizen.CreateThread(function()
    while true do
        local ped = GLOBAL_PED
        local Wait = GetEffectInterval(stress)
        if stress >= 100 then
            local ShakeIntensity = GetShakeIntensity(stress)
            local FallRepeat = math.random(2, 4)
            local RagdollTimeout = (FallRepeat * 1750)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
            SetFlash(0, 0, 500, 3000, 500)

            if not IsPedRagdoll(ped) and IsPedOnFoot(ped) and not IsPedSwimming(ped) then
                local player = GLOBAL_PED
                SetPedToRagdollWithFall(player, RagdollTimeout, RagdollTimeout, 1, GetEntityForwardVector(player), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
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
        elseif stress >= QBStress.MinimumStress then
            local ShakeIntensity = GetShakeIntensity(stress)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
            SetFlash(0, 0, 500, 2500, 500)
        end
        Citizen.Wait(Wait)
    end
end)

showRoundMap = function()    
    Citizen.CreateThread(function()
        RequestStreamedTextureDict("circlemap", false)
        while not HasStreamedTextureDictLoaded("circlemap") do
            Wait(100)
        end
    
        AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
    
        SetMinimapClipType(1)
        SetMinimapComponentPosition("minimap", "L", "B", 0.025 - 0.019, -0.03, 0.153, 0.22)
        SetMinimapComponentPosition("minimap_mask", "L", "B", 0.135 - 0.019, 0.12, 0.093, 0.164)
        SetMinimapComponentPosition("minimap_blur", "L", "B", 0.012 - 0.019, 0.022, 0.256, 0.337)

        local minimap = RequestScaleformMovie("minimap")
        SetRadarBigmapEnabled(true, false)
        Wait(0)
        SetRadarBigmapEnabled(false, false)
        SetBlipAlpha(GetNorthRadarBlip(), 0)
        
        while true do
            Wait(0)
            BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
            ScaleformMovieMethodAddParamInt(3)
            EndScaleformMovieMethod()
            BeginScaleformMovieMethod(minimap, 'HIDE_SATNAV')
            EndScaleformMovieMethod() 
            if IsPedInAnyVehicle(GLOBAL_PED) then
                if IsWaypointActive() then
                    SetTextFont(0)
                    SetTextProportional(1)
                    SetTextScale(0.0, 0.3)
                    SetTextColour(244, 244, 244, 255)
                    SetTextDropshadow(0, 0, 0, 0, 128)
                    SetTextEdge(1, 0, 0, 0, 255)
                    SetTextDropShadow()
                    SetTextOutline()
                    SetTextEntry("STRING")
                    AddTextComponentString(tostring(QBCore.Functions.MathRound(#(GetEntityCoords(GLOBAL_PED) - GetBlipCoords(GetFirstBlipInfoId(8))) / 1000, 2)) .. 'KM')
                    DrawText(0.0135, 0.925)
                end
            end
        end
    end)
    
    local isPause = false
    local uiHidden = false
    
    Citizen.CreateThread(function()
        while true do
            Wait(0)
            if IsBigmapActive() or IsPauseMenuActive() and not isPause or IsRadarHidden() then
                if not uiHidden then
                    SendNUIMessage({
                        action = "hideUI"
                    })
                    uiHidden = true
                end
            elseif uiHidden or IsPauseMenuActive() and isPause then
                SendNUIMessage({
                    action = "displayUI"
                })
                uiHidden = false
            end
        end
    end)
end
