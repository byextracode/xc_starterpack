function labelText(text, ...)
    local library = Config.translation[Config.Locale]
    if library == nil then
        return ("Translation [%s] does not exist"):format(Config.Locale)
    end
    if library[text] == nil then
        return ("Translation [%s][%s] does not exist"):format(Config.Locale, text)
    end
    return library[text]:format(...) 
end

function claimStarterPack()
    if not Config.available then
        return ESX.ShowNotification(labelText("claimed"), "error")
    end
    local plate = exports["esx_vehicleshop"]:GeneratePlate()
    local model = type(Config.vehicle?.model) == "number" and Config.vehicle?.model or joaat(Config.vehicle?.model)
    if not IsModelInCdimage(model) then
        return
    end
    if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(100)
        end
    end
    local vehicle = CreateVehicle(model, Config.vehicle?.coords, Config.vehicle?.heading, false, false)
    SetVehicleNumberPlateText(vehicle, plate)
    local props = ESX.Game.GetVehicleProperties(vehicle)
    DeleteEntity(vehicle)    
    local carname = GetDisplayNameFromVehicleModel(model)
    local vehicleName = GetLabelText(carname)   
    local data = {
        plate = plate,
        props = props,
        label = vehicleName
    }
    Config.available = false
    TriggerServerEvent("starterpack:claim", data)
end