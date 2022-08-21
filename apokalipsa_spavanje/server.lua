ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
RegisterServerEvent('ata:addbasicneeds')
AddEventHandler('ata:addbasicneeds', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if Config.addhungerandthirst then
    TriggerClientEvent('esx_status:add', source, 'hunger', 200)
    TriggerClientEvent('esx_status:add', source, 'thirst', 200)
    end

end)




RegisterNetEvent('ata:sleep')
AddEventHandler('ata:sleep', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    if data == true then
    MySQL.Async.execute("UPDATE users SET sleep = @sleep WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier,
        ["@sleep"] = true
    })
    else
    MySQL.Async.execute("UPDATE users SET sleep = @sleep WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier,
        ["@sleep"] = false
    })
    end
end)


RegisterServerEvent("ata:gettired")
AddEventHandler("ata:gettired", function(output, id)
    if id == nil then
        id = source
    end
    local xPlayer, result = ESX.GetPlayerFromId(id)

    result = MySQL.Sync.fetchAll("SELECT tired FROM users WHERE identifier = @identifier", {["@identifier"] = xPlayer.identifier})
    output(result[1].tired)
    
end)


ESX.RegisterServerCallback("ata:gettired", function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local stock
    local result
    result = MySQL.Sync.fetchAll("SELECT tired FROM users WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    })
    if result ~= nil then
        stock = result[1].tired
        cb(stock)
        
    end
    
end)

function addtired()
    Citizen.CreateThread(function()
        local sleep = MySQL.Async.fetchAll('SELECT * FROM users',{},function(data)
            
            for _,sleeps in ipairs(data) do
                if sleeps["identifier"]~=nil then
                    if sleeps["sleep"] ~= 1 then
                        if sleeps["tired"] < 10 then
                        if sleeps["identifier"]~=nil  then
                            addtiredfun(sleeps["identifier"],1)
                        else
                            addtiredfun(sleeps["identifier"],1)
                        end
                    end
                    end
                end
            end
        end)
    end)
end




function removetired()
    Citizen.CreateThread(function()
        local sleep = MySQL.Async.fetchAll('SELECT * FROM users',{},function(data)
            
            for _,sleeps in ipairs(data) do
                if sleeps["identifier"]~=nil then
                    if sleeps["sleep"] == 1 then
                        if sleeps["tired"] > 0 then
                        local saddsa = 1
                        if sleeps["identifier"]~=nil  then
                            removetireds(sleeps["identifier"],saddsa)
                        else
                            removetireds(sleeps["identifier"],saddsa)
                        end
                    end
                    end

                end
            end
        end)
    end)
end

function removetireds(identifier,saddsa)
    if not identifier then return end
    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
    local tiredass = saddsa
    if xPlayer then
        MySQL.Sync.execute('UPDATE `users` SET `tired` = `tired` - @tired WHERE `identifier` = @identifier',{['@tired'] = tiredass, ['@identifier'] = identifier})
    elseif Config.removetiredofflineplayer then
        MySQL.Sync.execute('UPDATE `users` SET `tired` = `tired` - @tired WHERE `identifier` = @identifier',{['@tired'] = tiredass, ['@identifier'] = identifier})
        
    end
end

function addtiredfun(identifier,earnings)
    if not identifier then return end
    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
    local money = earnings
    if xPlayer then
        MySQL.Sync.execute('UPDATE `users` SET `tired` = `tired` + @tired WHERE `identifier` = @identifier',{['@tired'] = money, ['@identifier'] = identifier})
    elseif Config.addtiredofflineplayer then
        MySQL.Sync.execute('UPDATE `users` SET `tired` = `tired` + @tired WHERE `identifier` = @identifier',{['@tired'] = money, ['@identifier'] = identifier})
        
    end
end

runaddtired = function()
    
    function addtiredtime()
        
        addtired()
        SetTimeout(1000*60*Config.timeforaddtired , addtiredtime)
    end

    SetTimeout(1000*60*Config.timeforaddtired , addtiredtime)
end
runaddtired()

runremovetired = function()
    function removetiredtime()
        removetired()
        SetTimeout(1000*60*Config.timeforremovetired , removetiredtime)
    end

    SetTimeout(1000*60*Config.timeforremovetired , removetiredtime)
end
runremovetired()

RegisterNetEvent('ata:kickPlayer')
AddEventHandler('ata:kickPlayer', function()
    local playerSource = source
    DropPlayer(playerSource, "Kikovani ste zato sto ste bili afk.")
end)