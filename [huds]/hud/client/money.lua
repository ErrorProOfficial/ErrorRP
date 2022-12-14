local cashAmount = 0
local bankAmount = 0

QBCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(200)
        if QBCore == nil then
            TriggerEvent("QBCore:getObject", function(obj) QBCore = obj end)    
        end
    end
end)

 RegisterNetEvent("hud:client:ShowMoney")
 AddEventHandler("hud:client:ShowMoney", function(type)
     QBCore.Functions.GetPlayerData(function(PlayerData)
         CashAmount = PlayerData.money["cash"]
     end)
     TriggerEvent("hud:client:SetMoney")
     SendNUIMessage({
         action = "show",
         cash = cashAmount,
         bank = bankAmount,
         type = type,
     })
 end)

 RegisterNetEvent("hud:client:money:change")
 AddEventHandler("hud:client:money:change", function(type, amount, isMinus)
     QBCore.Functions.GetPlayerData(function(PlayerData)
         CashAmount = PlayerData.money["cash"]
     end)
      SendNUIMessage({
          action = "update",
          cash = CashAmount,
          amount = amount,
          minus = isMinus,
          type = type,
      })
 end)


RegisterNetEvent("hud:client:SetMoney")
AddEventHandler("hud:client:SetMoney", function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData ~= nil and PlayerData.money ~= nil then
            cashAmount = PlayerData.money["cash"]
            bankAmount = PlayerData.money["bank"]
        end
    end)
    if QBHud.Money.ShowConstant then
        SendNUIMessage({
            action = "open",
            cash = cashAmount,
            bank = bankAmount,
        })
    end
end)

RegisterNetEvent("hud:client:ShowMoney")
AddEventHandler("hud:client:ShowMoney", function(type)
    TriggerEvent("hud:client:SetMoney")
    SendNUIMessage({
        action = "show",
        cash = cashAmount,
        bank = bankAmount,
        type = type,
    })
end)

RegisterNetEvent("hud:client:OnMoneyChange")
AddEventHandler("hud:client:OnMoneyChange", function(type, amount, isMinus)
    QBCore.Functions.GetPlayerData(function(PlayerData)
        cashAmount = PlayerData.money["cash"]
        bankAmount = PlayerData.money["bank"]
    end)
    
    if QBHud.Money.ShowConstant then
        SendNUIMessage({
            action = "open",
            cash = cashAmount,
            bank = bankAmount,
        })
    else
        SendNUIMessage({
            action = "update",
            cash = cashAmount,
            bank = bankAmount,
            amount = amount,
            minus = isMinus,
            type = type,
        })
    end
end)