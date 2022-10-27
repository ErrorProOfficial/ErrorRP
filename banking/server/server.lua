RePCore = nil

TriggerEvent('RePCore:GetObject', function(obj) RePCore = obj end)

RePCore.Functions.CreateCallback("banking:server:get:private:account", function(source, cb)
    local Player = RePCore.Functions.GetPlayer(source)
    RePCore.Functions.ExecuteSql(false, "SELECT * FROM characters_accounts", function(result) 
        local AccountData = {}
        if result ~= nil then
            for k, v in pairs(result) do
                if v.type == 'private' then
                    if v.citizenid == Player.PlayerData.citizenid then
                        DatabaseData = {
                            Owner = v.citizenid,
                            Name = v.name,
                            BankId = v.bankid,
                            Balance = v.balance,
                        }
                        table.insert(AccountData, DatabaseData)
                    end
                end
            end
            cb(AccountData)
        end
    end)
end)

RePCore.Functions.CreateCallback("banking:server:get:shared:account", function(source, cb)
    local Player = RePCore.Functions.GetPlayer(source)
    RePCore.Functions.ExecuteSql(true, "SELECT * FROM characters_accounts", function(result) 
        local AccountData = {}
        if result ~= nil then
            for k, v in pairs(result) do
                if v.type == 'shared' then
                    local AuthData = json.decode(v.authorized)
                    for Auth, Authorized in pairs(AuthData) do
                        if Authorized == Player.PlayerData.citizenid then
                            DatabaseData = {
                                Owner = v.citizenid,
                                Name = v.name,
                                BankId = v.bankid,
                                Balance = v.balance,
                            }
                            table.insert(AccountData, DatabaseData)
                        end
                    end
                end
            end
            cb(AccountData)
        end
    end)
end)

RePCore.Functions.CreateCallback("banking:server:get:account:users", function(source, cb, bankid)
    local Player = RePCore.Functions.GetPlayer(source)
    RePCore.Functions.ExecuteSql(false, "SELECT * FROM characters_accounts WHERE `bankid` = '"..bankid.."'", function(result) 
        local UserData = {}     
         if result ~= nil then
             for k, v in pairs(result) do 
                 local AuthorizedData = json.decode(v.authorized)
                 for Auth, Authorized in pairs(AuthorizedData) do
                     RePCore.Functions.ExecuteSql(true, "SELECT * FROM characters_metadata WHERE `citizenid` = '"..Authorized.."'", function(CharResult) 
                         local DecodeCharInfo = json.decode(CharResult[1].charinfo)
                         AccountArrayData = {
                          Firstname = DecodeCharInfo.firstname,
                          Lastname = DecodeCharInfo.lastname,
                          CitizenId = Authorized,
                         }
                         table.insert(UserData, AccountArrayData)
                     end)
                 end
             end
             cb(UserData)
         end                 
    end)
end)

RePCore.Functions.CreateCallback("-banking:server:get:account:transactions", function(source, cb, bankid)
    RePCore.Functions.ExecuteSql(false, "SELECT * FROM characters_accounts WHERE `bankid` = '"..bankid.."'", function(result)
        local ReturnData = {}
        local TransactionData = json.decode(result[1].transactions)
         for k, v in pairs(TransactionData) do
             Transactions = {
                 Name = GetCharName(v.CitizenId),
                 Amount = v.Amount,
                 Type = v.Type,
                 CitizenId = v.CitizenId,
                 Date = v.Date,
                 Time = v.Time,
             }
             table.insert(ReturnData, Transactions)
         end
         cb(ReturnData)
    end)
end)

RegisterServerEvent('banking:server:withdraw')
AddEventHandler('banking:server:withdraw', function(RemoveAmount, BankId)
    local src = source
    local Player = RePCore.Functions.GetPlayer(source)
    if Player.PlayerData.charinfo.account ~= BankId then
        local Balance = GetAccountBalance(BankId)
        local Amount = tonumber(RemoveAmount)
        local NewBalance = Balance - Amount
        if Balance >= Amount then
         Player.Functions.AddMoney('cash', Amount, 'Bank Withdraw')
         TriggerEvent('banking:server:add:transaction', src, BankId, Amount, 'Remove')
         RePCore.Functions.ExecuteSql(false, "UPDATE characters_accounts SET `balance` = '" .. NewBalance .. "' WHERE `bankid` = '" ..BankId.. "'")
        end
    else
        local CurrentBalance = Player.PlayerData.money['bank']
        local Amount = tonumber(RemoveAmount)
        if CurrentBalance >= Amount then
            Player.Functions.RemoveMoney('bank', Amount, 'Bank Withdraw')
            Player.Functions.AddMoney('cash', Amount, 'Bank Withdraw')
        else
            TriggerClientEvent('banking:client:send:notify', source, 'Bank', 'error', 'Нямате достатъчно пари в банковата сметка..')
        end
    end
end)

RegisterServerEvent('banking:server:deposit')
AddEventHandler('banking:server:deposit', function(AddAmount, BankId)
    local src = source
    local Player = RePCore.Functions.GetPlayer(source)
    if Player.PlayerData.charinfo.account ~= BankId then
        local Balance = GetAccountBalance(BankId)
        local CurrentCash = Player.PlayerData.money['cash']
        local Amount = tonumber(AddAmount)
        local NewBalance = Balance + Amount
        if CurrentCash >= Amount then
         Player.Functions.RemoveMoney('cash', Amount, 'Bank Deposit')  
         TriggerEvent('banking:server:add:transaction', src, BankId, Amount, 'Add')
         RePCore.Functions.ExecuteSql(false, "UPDATE characters_accounts SET `balance` = '" .. NewBalance .. "' WHERE `bankid` = '" ..BankId.. "'")
        end
    else
        local CurrentCash = Player.PlayerData.money['cash']
        local Amount = tonumber(AddAmount)
        if CurrentCash >= Amount then
            Player.Functions.RemoveMoney('cash', Amount, 'Bank Deposit')
            Player.Functions.AddMoney('bank', Amount, 'Bank Deposit')
        else
            TriggerClientEvent('banking:client:send:notify', source, 'Bank', 'error', 'Нямате достатъчно пари в себе си')
        end
    end
end)

RegisterServerEvent('banking:server:create:account')
AddEventHandler('banking:server:create:account', function(AccountName, AccountType)
local Player = RePCore.Functions.GetPlayer(source)
local RandomAccountId = CreateRandomIban()
 RePCore.Functions.ExecuteSql(false, "INSERT INTO `characters_accounts` (`citizenid`, `type`, `name`, `bankid`, `authorized`) VALUES ('"..Player.PlayerData.citizenid.."', '"..AccountType.."', '"..AccountName.."', '"..RandomAccountId.."', '[\""..Player.PlayerData.citizenid.."\"]')")
 TriggerClientEvent('banking:client:refresh:bank', source)
end)

RegisterServerEvent('banking:server:add:user')
AddEventHandler('banking:server:add:user', function(BankId, TargetBsn)
    local src = source
    RePCore.Functions.ExecuteSql(false, "SELECT * FROM characters_accounts WHERE `bankid` = '"..BankId.."'", function(result)
        if result ~= nil then
            local Count = 0
            local UserData = json.decode(result[1].authorized)
            local NewUsers = {}
            for k, v in pairs(UserData) do
                Count = Count + 1
                table.insert(NewUsers, v)
            end
            if Count < 5 then
             table.insert(NewUsers, TargetBsn)
             RePCore.Functions.ExecuteSql(false, "UPDATE characters_accounts SET `authorized` = '" .. json.encode(NewUsers) .. "' WHERE `bankid` = '" ..BankId.. "'")
             TriggerClientEvent('banking:client:refresh:bank', src)
            else
             TriggerClientEvent('RePCore:Notify', src, "Можете да добавите максимум 4 човека към този акаунт..", 'error', 6500)
            end
        end
    end)
end)

RegisterServerEvent('banking:server:remove:user')
AddEventHandler('banking:server:remove:user', function(BankId, TargetBsn)
    local src = source
    RePCore.Functions.ExecuteSql(false, "SELECT * FROM characters_accounts WHERE `bankid` = '"..BankId.."'", function(result)
        if result ~= nil then
            local UserData = json.decode(result[1].authorized)
            local NewUsers = {}
            for k, v in pairs(UserData) do
                if v ~= TargetBsn then
                 table.insert(NewUsers, v)
                end
            end
            RePCore.Functions.ExecuteSql(false, "UPDATE characters_accounts SET `authorized` = '" .. json.encode(NewUsers) .. "' WHERE `bankid` = '" ..BankId.. "'")
            TriggerClientEvent('banking:client:refresh:bank', src)
        end
    end)
end)

RegisterServerEvent('banking:server:add:transaction')
AddEventHandler('banking:server:add:transaction', function(Source, BankId, Amount, Type)
    local src = Source
    local Player = RePCore.Functions.GetPlayer(src)
    RePCore.Functions.ExecuteSql(false, "SELECT * FROM characters_accounts WHERE `bankid` = '"..BankId.."'", function(result)
        if result ~= nil then
            local NewTransactionData = {}
            local TransactionData = json.decode(result[1].transactions)
            local AddTransaction = {Type = Type, Amount = Amount, CitizenId = Player.PlayerData.citizenid, Date = os.date('%d-'..'%m-'..'%y'), Time = os.date('%H:'..'%M')}
            for k, v in pairs(TransactionData) do
                table.insert(NewTransactionData, v)
            end
            table.insert(NewTransactionData, AddTransaction)
            RePCore.Functions.ExecuteSql(false, "UPDATE characters_accounts SET `transactions` = '" .. json.encode(NewTransactionData) .. "' WHERE `bankid` = '" ..BankId.. "'")
        end
    end)
end)

RegisterServerEvent('banking:server:remove:account')
AddEventHandler('banking:server:remove:account', function(BankId)
    RePCore.Functions.ExecuteSql(false, 'DELETE FROM `characters_accounts` WHERE `bankid` = "'..BankId..'"')
end)

RegisterNetEvent('banking:server:give:cash')
AddEventHandler('banking:server:give:cash', function(TargetPlayer, Amount)
    local SelfPlayer = RePCore.Functions.GetPlayer(source)
    local TargetPlayer = RePCore.Functions.GetPlayer(TargetPlayer)
    SelfPlayer.Functions.RemoveMoney('cash', Amount, 'Given Cash')
    TargetPlayer.Functions.AddMoney('cash', Amount, 'Given Cash')
    TriggerClientEvent('RePCore:Notify', SelfPlayer.PlayerData.source, "Дадохте €"..Amount.. "", "success", 4500)
    TriggerClientEvent('RePCore:Notify', TargetPlayer.PlayerData.source, "Получихте €"..Amount.. " от "..SelfPlayer.PlayerData.charinfo.firstname, "success", 4500)
    TriggerClientEvent("payanimation", src)
end)

RePCore.Commands.Add("givecash", "Даване кеш пари на някого", {{name="id", help="ID на гражданина."},{name="amount", help="Сума."}}, true, function(source, args)
    local SelfPlayer = RePCore.Functions.GetPlayer(source)
    local TargetPlayer = RePCore.Functions.GetPlayer(tonumber(args[1]))
    local Amount = tonumber(args[2])
    if TargetPlayer ~= nil then
        if TargetPlayer.PlayerData.source ~= SelfPlayer.PlayerData.source then
            if Amount ~= nil and Amount > 0 then
                if SelfPlayer.PlayerData.money['cash'] >= Amount then
                    TriggerClientEvent('banking:client:check:players:near', SelfPlayer.PlayerData.source, TargetPlayer.PlayerData.source, Amount)
                else
                    TriggerClientEvent('RePCore:Notify', source, "Нямате достатъчно пари..", "error", 4500)
                end
            end
        else
            TriggerClientEvent('RePCore:Notify', source, "Но защо?", "error", 4500)
        end
    else
        TriggerClientEvent('RePCore:Notify', source, "Този гражданин не е намерен..", "error", 4500)
    end
end)

function GetCharName(CitizenId)
    local CharName = nil
    RePCore.Functions.ExecuteSql(true, "SELECT * FROM characters_metadata WHERE `citizenid` = '"..CitizenId.."'", function(CharResult) 
        local DecodeCharInfo = json.decode(CharResult[1].charinfo)
        CharName = DecodeCharInfo.firstname..' '..DecodeCharInfo.lastname
    end)
    return CharName
end

function GetAccountBalance(BankId)
    local ReturnData = nil
    RePCore.Functions.ExecuteSql(true, "SELECT * FROM characters_accounts WHERE `bankid` = '"..BankId.."'", function(result)
        ReturnData = result[1].balance
    end)
    return ReturnData
end

function CreateRandomIban()
    return "BG0"..math.random(1,9).."TURB"..math.random(1111,9999)..math.random(1111,9999)..math.random(11,99)
end