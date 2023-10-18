 --  ________ ________ _  __
 -- |__  / _ \__  /_ _| |/ /
 --   / / | | |/ / | || ' / 
 --  / /| |_| / /_ | || . \ 
 -- /____\___/____|___|_|\_\
                         

ESX = exports['es_extended']:getSharedObject()

RegisterServerEvent('zozik:checkPolice')
AddEventHandler('zozik:checkPolice', function() 
    local onlinePolice = 0
    local Players = ESX.GetPlayers()

    for i = 1, #Players do
        local xPlayer = ESX.GetPlayerFromId(Players[i])

        if xPlayer["job"]["name"] == Config.police then
            onlinePolice = onlinePolice + 1
        end
    end

    if onlinePolice >= Config.minimalCops then
        TriggerClientEvent("zozik:startRobbery", source)
    else
        TriggerClientEvent('esx:showNotification', source, Config.locales.limitCops)
    end
end)

RegisterServerEvent('zozik:giveMoney')
AddEventHandler('zozik:giveMoney', function() 
    local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    local reward = math.random(Config.minMoney, Config.maxMoney)

    exports.ox_inventory:AddItem(_source, Config.money, reward)

end)

RegisterServerEvent('zozik:policeAlarm')
AddEventHandler('zozik:policeAlarm', function(coords) 
    TriggerClientEvent('zozik:policeAlarmOnMap', -1, coords.x, coords.y, coords.z)
end)

