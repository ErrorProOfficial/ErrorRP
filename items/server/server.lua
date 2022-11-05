RePCore = nil

TriggerEvent('RePCore:GetObject', function(obj) RePCore = obj end)

-- Code

-- // Lockpick \\ --
RePCore.Functions.CreateUseableItem("advancedlockpick", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:use:lockpick', source, true)
    end
end)

RePCore.Functions.CreateUseableItem("trojan_usb", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('mdw', source, false)
    end
end)

RePCore.Functions.CreateUseableItem("lockpick", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:use:lockpick', source, false)
    end
end)

RePCore.Functions.CreateUseableItem("carradio", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('MusicEverywhere:ShowNui', source, false)
    end
end)

RePCore.Functions.CreateUseableItem("drill", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:use:drill', source)
    end
end)

RePCore.Functions.CreateUseableItem("cigarette", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('smoking:cigarette', source, false)
    end
end)

RePCore.Functions.CreateUseableItem("laptop", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('laptop:use', source, false)
    end
end)

-- // Eten \\ --
RePCore.Functions.CreateUseableItem("vodka", function(source, item)
    local Player = RePCore.Functions.GetPlayer(source)
    TriggerClientEvent("items:client:vodka", source, item.name)
end)

RePCore.Functions.CreateUseableItem("beer", function(source, item)
    local Player = RePCore.Functions.GetPlayer(source)
    TriggerClientEvent("items:client:beer", source, item.name)
end)

RePCore.Functions.CreateUseableItem("whiskey", function(source, item)
    local Player = RePCore.Functions.GetPlayer(source)
    TriggerClientEvent("items:client:whiskey", source, item.name)
end)

RePCore.Functions.CreateUseableItem("water", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:drink', source, 'water', 'water')
    end
end)

RePCore.Functions.CreateUseableItem("ecola", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:drink', source, 'ecola', 'cola')
    end
end)

RePCore.Functions.CreateUseableItem("sprunk", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:drink', source, 'sprunk', 'cola')
    end
end)

RePCore.Functions.CreateUseableItem("cleaningkit", function(source, item)
    local Player = RePCore.Functions.GetPlayer(source)
    TriggerClientEvent("clean:kit", source)
end)

RePCore.Functions.CreateUseableItem("slushy", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:drink:slushy', source)
    end
end)

RePCore.Functions.CreateUseableItem("sandwich", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:eat', source, 'sandwich', 'sandwich')
    end
end)

RePCore.Functions.CreateUseableItem("binoculars", function(source, item)
    local Player = RePCore.Functions.GetPlayer(source)
    TriggerClientEvent("binoculars:Toggle", source)
end)

RePCore.Functions.CreateUseableItem("chocolade", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:eat', source, 'chocolade', 'chocolade')
    end
end)

RePCore.Functions.CreateUseableItem("420-choco", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:eat', source, '420-choco', 'chocolade')
    end
end)

RePCore.Functions.CreateUseableItem("donut", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:eat', source, 'donut', 'donut')
    end
end)

RePCore.Functions.CreateUseableItem("coffee", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:drink', source, 'coffee', 'coffee')
    end
end)

RePCore.Functions.CreateUseableItem("banana", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:eat', source, 'banana', 'donut')
    end
end)

-- BurgerShot

RePCore.Functions.CreateUseableItem("burger-bleeder", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:eat', source, 'burger-bleeder', 'hamburger')
    end
end)

RePCore.Functions.CreateUseableItem("burger-moneyshot", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:eat', source, 'burger-moneyshot', 'hamburger')
    end
end)

RePCore.Functions.CreateUseableItem("burger-meetfree", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:eat', source, 'burger-meetfree', 'hamburger')
    end
end)

RePCore.Functions.CreateUseableItem("burger-torpedo", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:eat', source, 'burger-torpedo', 'hamburger')
    end
end)

RePCore.Functions.CreateUseableItem("burger-heartstopper", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:eat', source, 'burger-heartstopper', 'hamburger')
        TriggerServerEvent('hud:server:remove:stress', math.random(4, 8))
    end
end)

RePCore.Functions.CreateUseableItem("burger-softdrink", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:drink', source, 'burger-softdrink', 'burger-soft')
    end
end)

RePCore.Functions.CreateUseableItem("burger-fries", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:eat', source, 'burger-fries', 'burger-fries')
    end
end)

RePCore.Functions.CreateUseableItem("whitechocolatedonut", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:eat', source, 'whitechocolatedonut', 'donut')
    end
end)

RePCore.Functions.CreateUseableItem("strawberrydonut", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:eat', source, 'strawberrydonut', 'donut')
        TriggerServerEvent('hud:server:remove:stress', math.random(2, 4))
    end
end)

RePCore.Functions.CreateUseableItem("icecream", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:eat', source, 'icecream', 'icecream')
    end
end)

RePCore.Functions.CreateUseableItem("applepie", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:eat', source, 'applepie', 'sandwich')
    end
end)

RePCore.Functions.CreateUseableItem("burger-box", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('burgershot:client:open:box', source, item.info.boxid)
    end
end)

RePCore.Functions.CreateUseableItem("burger-coffee", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:drink', source, 'burger-coffee', 'coffee')
        StaminaEffect()
    end
end)

RePCore.Functions.CreateUseableItem("milkshake", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:drink', source, 'milkshake', 'milkshake')
    end
end)

-- // Other \\ --

RePCore.Functions.CreateUseableItem("duffel-bag", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        -- TriggerClientEvent('items:client:use:duffel-bag', source, item.info.bagid)
        TriggerClientEvent('RePCore:Notify', source, 'Чантите са спрени, ако сте имали нещо ценно, отворете тикет!', 'error', 10000)
    end
end)

RePCore.Functions.CreateUseableItem("armor", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:use:armor', source)
    end
end)

RePCore.Functions.CreateUseableItem("heavy-armor", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:use:heavy', source)
    end
end)

RePcore.Functions.CreateUseableItem("repairkit", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:use:repairkit', source)
    end
end)

RePCore.Functions.CreateUseableItem("toolkit", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:use:neon', source)
    end
end)

RePCore.Functions.CreateUseableItem("bandage", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('hospital:client:use:bandage', source)
    end
end)

RePCore.Functions.CreateUseableItem("health-pack", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('hospital:client:use:health-pack', source)
    end
end)

RePCore.Functions.CreateUseableItem("painkillers", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('hospital:client:use:painkillers', source)
    end
end)

RePCore.Functions.CreateUseableItem("joint", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:use:joint', source)
    end
end)

RePCore.Functions.CreateUseableItem("coke-bag", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:use:coke', source)
    end
end)

RePCore.Functions.CreateUseableItem("lsd-strip", function(source, item)
    local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("items:client:use:lsd", source)
    end
end)

RePCore.Functions.CreateUseableItem("coin", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('items:client:coinflip', source)
    end
end)

-- Weed

RePCore.Functions.CreateUseableItem("weed-nutrition", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('houseplants:client:feed:plants', source)
    end
end)

RePCore.Functions.CreateUseableItem("white-widow-seed", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('houseplants:client:plant', source, 'White Widow', 'White-Widow', 'white-widow-seed')
    end
end)

RePCore.Functions.CreateUseableItem("skunk-seed", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('houseplants:client:plant', source, 'Skunk', 'Skunk', 'skunk-seed')
    end
end)

RePCore.Functions.CreateUseableItem("purple-haze-seed", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('houseplants:client:plant', source, 'Purple Haze', 'Purple-Haze', 'purple-haze-seed')
    end
end)

RePCore.Functions.CreateUseableItem("og-kush-seed", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('houseplants:client:plant', source, 'Og Kush', 'Og-Kush', 'og-kush-seed')
    end
end)

RePCore.Functions.CreateUseableItem("amnesia-seed", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('houseplants:client:plant', source, 'Amnesia', 'Amnesia', 'amnesia-seed')
    end
end)

RePCore.Functions.CreateUseableItem("ak47-seed", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('houseplants:client:plant', source, 'AK47', 'AK47', 'ak47-seed')
    end
end)

RePCore.Functions.CreateUseableItem("maui-wowie-seed", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('houseplants:client:plant', source, 'Maui Wowie', 'Maui-Wowie', 'maui-wowie-seed')
    end
end)

-- // Coke \\ --

RePCore.Functions.CreateUseableItem("packed-coke-brick", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('illegal:client:unpack:coke', source)
    end
end)

RePCore.Functions.CreateUseableItem("packed-coke-brick", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('illegal:client:unpack:coke', source)
    end
end)

RePCore.Functions.CreateUseableItem("burner-phone", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('illegal:client:start:burner-call', source)
    end
end)



-- addons

RePCore.Functions.CreateUseableItem("parachute", function(source, item)
    local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("items:client:UseParachute", source)
    end
end)

RePCore.Commands.Add("packparachute", "Свали парашута", {}, false, function(source, args)
    local Player = RePCore.Functions.GetPlayer(source)
        TriggerClientEvent("items:client:ResetParachute", source)
end)

RegisterServerEvent("smallpenis:server:AddParachute")
AddEventHandler("smallpenis:server:AddParachute", function()
    local src = source
    local Ply = RePCore.Functions.GetPlayer(src)

    Ply.Functions.AddItem("parachute", 1)
end)

RePCore.Functions.CreateUseableItem("firework1", function(source, item)
    local Player = RePCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "proj_indep_firework")
end)

RePCore.Functions.CreateUseableItem("firework2", function(source, item)
    local Player = RePCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "proj_indep_firework_v2")
end)

RePCore.Functions.CreateUseableItem("firework3", function(source, item)
    local Player = RePCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "proj_xmas_firework")
end)

RePCore.Functions.CreateUseableItem("firework4", function(source, item)
    local Player = RePCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "scr_indep_fireworks")
end)




-- addons

-- // Sleutels \\ --
RePCore.Functions.CreateUseableItem("key-a", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('illegal:client:use:key', source, 'key-a')
    end
end)

RePCore.Functions.CreateUseableItem("key-b", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('illegal:client:use:key', source, 'key-b')
    end
end)

RePCore.Functions.CreateUseableItem("key-c", function(source, item)
	local Player = RePCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('illegal:client:use:key', source, 'key-c')
    end
end)

RePCore.Commands.Add("dice", "Хубави зарове", {{name="number", help="Брой зарчета"}, {name="number", help="Брой страни на зарчетата"}}, true, function(source, args)
    local Player = RePCore.Functions.GetPlayer(source)
    local DiceItems = Player.Functions.GetItemByName("dice")
    if args[1] ~= nil and args[2] ~= nil then 
      local Amount = tonumber(args[1])
      local Sides = tonumber(args[2])
      if DiceItems ~= nil then
         if (Sides > 0 and Sides <= 20) and (Amount > 0 and Amount <= 5) then 
             TriggerClientEvent('items:client:dice', source, Amount, Sides)
         else
             TriggerClientEvent('RePCore:Notify', source, "Твърде много страни или 0 (max: 5) или твърде много зарове или 0 (max: 20)", "error", 3500)
         end
      else
        TriggerClientEvent('RePCore:Notify', source, "Ти дори нямаш зарове..", "error", 3500)
      end
  end
end)

RePCore.Commands.Add("vestoff", "Свалете си жилетката", {}, false, function(source, args)
    local Player = RePCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("items:client:reset:armor", source)
    else
        TriggerClientEvent('chatMessage', source, "СИСТЕМНО", "error", "Тази команда е за аварийни служби!")
    end
end)

RePCore.Functions.CreateUseableItem("radio", function(source, item)
    TriggerClientEvent('Radio.ToggleItem', source)
end)

RePCore.Functions.CreateUseableItem("jerry_can_normal", function(source, item)
    TriggerClientEvent("fuel:client:refuelWithJerryCan", source)
end)

RePCore.Functions.CreateUseableItem("handcuffs-key", function(source, item)
    TriggerClientEvent("police:client:cuff:closest", source, true)
end)

RegisterServerEvent('items:server:removeItem')
AddEventHandler('items:server:removeItem', function(itemName, amount)
    local ply = RePCore.Functions.GetPlayer(source)
    ply.Functions.RemoveItem(itemName, amount)
    TriggerClientEvent('inventory:client:ItemBox', source, RePCore.Shared.Items[itemName], "remove")
end)

RegisterServerEvent('items:server:giveitem')
AddEventHandler('items:server:giveitem', function(ItemName, Amount)
    local ply = RePCore.Functions.GetPlayer(source)
    ply.Functions.AddItem(ItemName, Amount)
    TriggerClientEvent('inventory:client:ItemBox', source, RePCore.Shared.Items[ItemName], "add")
end)

RegisterServerEvent('items:server:removeItemGlobal')
AddEventHandler('items:server:removeItemGlobal', function(gameID, itemName, amount)
    local ply = RePCore.Functions.GetPlayer(gameID)
    ply.Functions.RemoveItem(itemName, amount)
    TriggerClientEvent('inventory:client:ItemBox', source, RePCore.Shared.Items[itemName], "remove")
end)

RegisterServerEvent('items:server:giveitemGlobal')
AddEventHandler('items:server:giveitemGlobal', function(gameID, ItemName, Amount)
    local ply = RePCore.Functions.GetPlayer(gameID)
    ply.Functions.AddItem(ItemName, Amount)
    TriggerClientEvent('inventory:client:ItemBox', source, RePCore.Shared.Items[ItemName], "add")
end)
