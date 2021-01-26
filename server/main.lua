ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 

RegisterServerEvent("guille_drugsystem:sell")
AddEventHandler("guille_drugsystem:sell", function()

    local xPlayer = ESX.GetPlayerFromId(source)

    local num = math.random(1,5)
    
    local maria = xPlayer.getInventoryItem('femenineseed').count
    
    if maria > 1 then
        xPlayer.removeInventoryItem('femenineseed',num)
        xPlayer.addAccountMoney('black_money', (num * 20))
        TriggerClientEvent('esx:showNotification', source, 'You sold ' .. num .. ' drug/s!')
    end


end)

RegisterServerEvent("guille_drugsystem:police")
AddEventHandler("guille_drugsystem:police", function()

    local xPlayer = ESX.GetPlayerFromId(source)

    local xPlayers = ESX.GetPlayers()

    local police = 0
    
	for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        
        if xPlayer.job.name == 'police' then
            police = police + 1
        end
        
    end
    
    if police >= Config.numpol then
        TriggerClientEvent('guille_drugsystem:yespol', source)
    else
        TriggerClientEvent('guille_drugsystem:nopol', source)
    end

end)

RegisterServerEvent("guille_drugsystem:policecall")
AddEventHandler("guille_drugsystem:policecall", function()

	local xPlayer  = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    local ubi = xPlayer.getCoords()

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('esx:showNotification', xPlayers[i], (_U('advise')))
            TriggerClientEvent('guille_drugsystem:polblip', xPlayers[i], ubi)
        end
    end

end)

RegisterServerEvent("guille_drugsystem:drugcheck")
AddEventHandler("guille_drugsystem:drugcheck", function()

    local xPlayer = ESX.GetPlayerFromId(source)

    local maria = xPlayer.getInventoryItem('femenineseed').count

    if maria >= 1 then
        print("yesdrug")
        TriggerClientEvent('guille_drugsystem:yesdrug', source)
    else
        print("nodrug")
        TriggerClientEvent('guille_drugsystem:nodrug', source)
    end
end)

RegisterServerEvent("guille_drugsystem:steal")
AddEventHandler("guille_drugsystem:steal", function()

    local xPlayer = ESX.GetPlayerFromId(source)

    num = math.random(1,3)

    xPlayer.removeInventoryItem('femenineseed',num)

    TriggerClientEvent('esx:showNotification', source, 'You lost ' .. num .. ' drug/s!' )

end)


--         TriggerClientEvent('guille_drugsystem:yesdrug', source)


--         TriggerClientEvent('guille_drugsystem:nodrug', source)


