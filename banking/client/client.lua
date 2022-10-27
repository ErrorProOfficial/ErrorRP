local CanOpenBank = false
local LoggedIn = false

RePCore = nil 

RegisterNetEvent('RePCore:Client:OnPlayerLoaded')
AddEventHandler('RePCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(500, function()
     TriggerEvent("RePCore:GetObject", function(obj) RePCore = obj end)    
      Citizen.Wait(150)
      LoggedIn = true
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if LoggedIn then
         IsNearBank = false
          for k, v in pairs(Config.Banks) do
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
            if Distance < 2.5 then
                if v['IsOpen'] then
                    CanOpenBank = true
                    --DrawMarker(2, v['X'], v['Y'], v['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 48, 255, 58, 255, false, false, false, 1, false, false, false)
                else
                    CanOpenBank = false
                    --DrawMarker(2, v['X'], v['Y'], v['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 72, 48, 255, false, false, false, 1, false, false, false)
                end
                IsNearBank = true
            end
          end
          if not IsNearBank then
            CanOpenBank = false
            Citizen.Wait(1500)
          end
        end
    end
end)

RegisterNetEvent('banking:client:open:bank')
AddEventHandler('banking:client:open:bank', function()
    Citizen.SetTimeout(450, function()
        OpenBank(true)
    end)
end)

RegisterNetEvent('banking:client:open:atm')
AddEventHandler('banking:client:open:atm', function()
    Citizen.SetTimeout(450, function()
        OpenAtm(false)
    end)
end)

RegisterNUICallback('ClickSound', function(data)
    if data.success == 'bank-error' then
     PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
    elseif data.success == 'click' then
     PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
    else
     TriggerEvent("sound:client:play", data.success, 0.25)
    end
end)

RegisterNUICallback('Withdraw', function(data)
    if IsNearAnyBank() or IsNearAtm() then
        TriggerServerEvent('toDiscord', "Изтеглена Сума: " ..data.RemoveAmount..  "  IBAN:  " ..data.BankId.. "")
      TriggerServerEvent('banking:server:withdraw', data.RemoveAmount, data.BankId) 
    end
end)

RegisterNUICallback('Deposit', function(data)
    if IsNearAnyBank() then
        TriggerServerEvent('toDiscord', "Депозирана Сума: " ..data.AddAmount.. "  IBAN:  " ..data.BankId.. "")
      TriggerServerEvent('banking:server:deposit', data.AddAmount, data.BankId) 
    end
end)

RegisterNUICallback('CreateAccount', function(data)
     if IsNearAnyBank() or IsNearAtm() then
        TriggerServerEvent('toDiscord', "Създаден нов акаунт: " ..data.Name.. " " ..data.Type.. "")
       TriggerServerEvent('banking:server:create:account', data.Name, data.Type)
    end
end)

RegisterNUICallback('AddUserToAccount', function(data)
     if IsNearAnyBank() or IsNearAtm() then
        TriggerServerEvent('toDiscord', "Добавен играч към акаунт: " ..data.BankId.. " " ..data.TargetBsn.. "")
       TriggerServerEvent('banking:server:add:user', data.BankId, data.TargetBsn)
    end
end)

RegisterNUICallback('DeleteFromAccount', function(data)
     if IsNearAnyBank() or IsNearAtm() then
        TriggerServerEvent('toDiscord', "Премахнат играч от акаунт: " ..data.BankId.. " " ..data.TargetBsn.. "")
       TriggerServerEvent('banking:server:remove:user', data.BankId, data.TargetBsn)
     end
end)

RegisterNUICallback('DeleteAccount', function(data)
    if IsNearAnyBank() or IsNearAtm() then
        TriggerServerEvent('toDiscord', "Изтрит акаунт: " ..data.BankId.. "")
      TriggerServerEvent('banking:server:remove:account', data.BankId)
    end
end)

RegisterNUICallback('GetTransactions', function(data)
    if IsNearAnyBank() or IsNearAtm() then
        RePCore.Functions.TriggerCallback('banking:server:get:account:transactions', function(Transactions)
         SendNUIMessage({
           action = 'SetupTransaction',
           transaction = Transactions,
         })    
        end, data.BankId)
    end
end)

RegisterNUICallback('GetPersonalBalance', function(data, cb)
    local Player = RePCore.Functions.GetPlayerData()
    local Data = {
        Balance = Player.money['bank'],
        BankId = Player.charinfo.account,
        CitizenId = Player.citizenid,
        Name = Player.charinfo.firstname..' '.. Player.charinfo.lastname,
    }
    cb(Data)
end)

RegisterNUICallback('GetSharedAccounts', function(data, cb)
    RePCore.Functions.TriggerCallback('banking:server:get:shared:account', function(Accounts)
        cb(Accounts)
    end)  
end)

RegisterNUICallback('GetPrivateAcounts', function(data, cb)
    RePCore.Functions.TriggerCallback('banking:server:get:private:account', function(Accounts)
        cb(Accounts)
    end)  
end)

RegisterNUICallback('CloseApp', function()
    SetNuiFocus(false, false)
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_atm@male@exit", "exit", 1.0, 1.0, -1, 49, 0, 0, 0, 0 )
    RePCore.Functions.Progressbar("bank", "Затваряне..", 5000, false, false, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(PlayerPedId())
    end, function()
        RePCore.Functions.Notify("Отменено..", "error")
    end)
end)

RegisterNUICallback('GetAccountUsers', function(data)
    RePCore.Functions.TriggerCallback('banking:server:get:account:users', function(Accounts)
        SendNUIMessage({
          action = 'SetupUsers',
          accounts = Accounts,
          citizenid = RePCore.Functions.GetPlayerData().citizenid,
        })    
    end, data.BankId)
end)

RegisterNetEvent('banking:client:check:players:near')
AddEventHandler('banking:client:check:players:near', function(TargetPlayer, Amount)
    local Player, Distance = RePCore.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 3.0 then
        if GetPlayerServerId(Player) == TargetPlayer then
            exports['assets']:RequestAnimationDict('friends@laf@ig_5')
            TaskPlayAnim(PlayerPedId(), 'friends@laf@ig_5', 'nephew', 5.0, 1.0, 5.0,48, 0.0, 0, 0, 0)
            TriggerServerEvent('banking:server:give:cash', TargetPlayer, Amount) 
        else
            RePCore.Functions.Notify("Гражданинът не е верен..", "error")
        end
    else
        RePCore.Functions.Notify("Неуспешно намиране на гражданина..", "error")
    end
end)

function OpenAtm(CanDeposit, UseAnim)
    exports['assets']:RequestAnimationDict('amb@prop_human_atm@male@idle_a')
    exports['assets']:RequestAnimationDict('amb@prop_human_atm@male@exit')
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_atm@male@idle_a", "idle_b", 1.0, 1.0, -1, 49, 0, 0, 0, 0 )
    RePCore.Functions.Progressbar("bank", "Вкарване на картата..", 4500, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'openbank',
            candeposit = CanDeposit,
            chardata = RePCore.Functions.GetPlayerData(),
        })
    end, function()
        RePCore.Functions.Notify("Отказано..", "error")
    end)
end

function OpenBank(CanDeposit, UseAnim)
    exports['assets']:RequestAnimationDict('amb@prop_human_atm@male@idle_a')
    exports['assets']:RequestAnimationDict('amb@prop_human_atm@male@exit')
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_atm@male@idle_a", "idle_b", 1.0, 1.0, -1, 49, 0, 0, 0, 0 )
    RePCore.Functions.Progressbar("bank", "Достъп до банката..", 4500, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'openbank',
            candeposit = CanDeposit,
            chardata = RePCore.Functions.GetPlayerData(),
        })
    end, function()
        RePCore.Functions.Notify("Отказано..", "error")
    end)
end

function IsNearAtm()
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    for k, v in pairs(Config.AtmObject) do
        local AtmObject = GetClosestObjectOfType(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 3.0, v, false, 0, 0)
        local ObjectCoords = GetEntityCoords(AtmObject)
        local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, ObjectCoords.x, ObjectCoords.y, ObjectCoords.z, true)
        if Distance < 2.0 then
            return true
        end
    end
end

function IsNearAnyBank()
    return CanOpenBank
end

RegisterNetEvent("payanimation")
AddEventHandler("payanimation", function()
	TriggerEvent('animations:client:EmoteCommandStart', {"id"})
end)