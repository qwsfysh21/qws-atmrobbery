ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('qws_atmrobbery:check_hackerdevice')
AddEventHandler('qws_atmrobbery:check_hackerdevice', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getInventoryItem('hackerdevice').count >= 1 then
        TriggerClientEvent('qws:atmrobberyM', src)
    else
        TriggerClientEvent('qws:manglerhackerdevice', src)
    end
end)

RegisterServerEvent('qws_atmrobbery:modtagpenge')
AddEventHandler('qws_atmrobbery:modtagpenge', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local amount = math.random(2800, 8700)

    if xPlayer.canCarryItem("money", amount) then
        xPlayer.addInventoryItem("money", amount)
        xPlayer.removeInventoryItem('hackerdevice', 1)
    else
        TriggerClientEvent("qws:manglerplads_atm", src)
    end
end)
