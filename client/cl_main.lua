CreateThread(function()
    while not ESX.PlayerLoaded do
        Wait(100)
    end

    Config.available = lib.callback.await("starterpack:configRequest")

    local function claimStarterPack()
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
        TriggerServerEvent("starterpack:claim", data, Money)
    end
    
    if Config.ped?.enable then
        local model = type(Config.ped?.model) == "number" and Config.ped?.model or joaat(Config.ped?.model)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait()
        end
        local coords = Config.location
        local heading = Config.heading
        local ped = CreatePed(0, model, coords.x, coords.y, coords.z - 1.0, heading, false, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        local options = {
            {
                name = "claim_starterpack",
                icon = "fa-solid fa-gem",
                label = labelText("claim"),
                distance = 2.0,
                onSelect = function()
                    claimStarterPack()
                end,
                canInteract = function(entity, distance, coords, name, bone)
                    local inArea = #(GetEntityCoords(PlayerPedId()) - Config.location) <= 3.0
                    return inArea
                end,
            },
        }

        exports["ox_target"]:addModel(model, options)
    end

    if Config.blip?.enable then
        local prop = Config.blip
        local coords = Config.location
        local blip = AddBlipForCoord(coords)
        SetBlipScale(blip, prop.scale)
        SetBlipDisplay(blip, 4)
        SetBlipSprite(blip, prop.sprite)
        SetBlipColour(blip, prop.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(prop.label)
        EndTextCommandSetBlipName(blip)
    end

    local textUI
    while true do
        local wait = 1000
        local coords  = GetEntityCoords(PlayerPedId())
        if #(coords - Config.location) < 2.5 then
            if not textUI then
                textUI = true
                lib.showTextUI(labelText("textui"), {icon="eye"})
            end
        else
            if textUI then
                textUI = false
                lib.hideTextUI()
            end
        end
        Wait(wait)
    end
end)