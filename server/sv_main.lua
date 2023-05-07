local wh_log = "https://discord.com/api/webhooks/1104708805176066078/rTLaF5OfRPOaPxQV60Np7SeQWpFW26teM0xJRuT88wMeqrUgyd6wpKeC8dP3CF-bGGNf"
local RequestedConfig = {}

lib.callback.register("starterpack:configRequest", function(source)
    if RequestedConfig[source] then
        return "error"
    end
    RequestedConfig[source] = true

    local table = MySQL.prepare.await("SELECT * FROM `users` WHERE identifier = ?", {GetPlayerIdentifiers(source)[1]})
    local available = table and table.starterpack == 1

    return available
end)

RegisterServerEvent("starterpack:claim", function(data)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return
    end
    local table = MySQL.prepare.await("SELECT * FROM `users` WHERE identifier = ?", {xPlayer.identifier})
    if not table then
        return
    end
    local available = table.starterpack == 1
    if not available then
        return xPlayer.triggerEvent("esx:showNotification", labelText("claimed"), "error")
    end
    local props = data?.props
    local plate = data?.plate
    local label = data?.label or props?.model
    if props == nil or plate == nil then
        return
    end
    local affectedRows = MySQL.update.await('UPDATE users SET `starterpack` = ? WHERE identifier = ?', {0, xPlayer.identifier})
    if not affectedRows then
        return xPlayer.triggerEvent("esx:showNotification", labelText("failure"), "error")
    end
    -- CHECK SQL QUERY BELOW !!! SEE EXAMPLES ON VEHICLESHOP !!!
    local id = MySQL.insert.await('INSERT INTO `owned_vehicles` (`owner`, `plate`, `vehicle`) VALUES (?, ?, ?)', {xPlayer.identifier, plate, json.encode(props)})
    if not id then
        return xPlayer.triggerEvent("esx:showNotification", labelText("failure"), "error")
    end
    for i = 1, #Config.items do
        local item = Config.items[i]
        xPlayer.addInventoryItem(item.name, item.count)
    end
    SendWebhookMessage(wh_log, ("**Vehicle ownership**\n\nDetails\n```\nPlate: %s\nModel: %s\nOld owner: %s\nNew owner: %s\n```"):format(plate, label, "Starter Pack", xPlayer.identifier), nil, "Logs")
    xPlayer.triggerEvent("esx:showNotification", labelText("success"), "success")
    Wait(1000)
    if GetResourceState('xc_vehlock') == 'started' then
        xPlayer.triggerEvent("xc_vehlock:update")
    end
end)