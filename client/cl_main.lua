CreateThread(function()
    while not ESX.PlayerLoaded do
        Wait(100)
    end

    Config.available = lib.callback.await("starterpack:configRequest")

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
    
    if Config.ped?.enable then
        local coords = Config.location
        local heading = Config.heading
        local model = type(Config.ped?.model) == "number" and Config.ped?.model or joaat(Config.ped?.model)
        if not HasModelLoaded(model) then
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait()
            end
        end

        local point = lib.points.new({
            coords = coords,
            distance = 50.0
        })
        
        local options = {
            {
                name = "claim_starterpack",
                icon = "fa-solid fa-gem",
                label = labelText("claim"),
                distance = 2.0,
                onSelect = function()
                    claimStarterPack()
                end
            },
        }
    
        function point:onEnter()
            if Config.ped?.enable then
                if not DoesEntityExist(ped) then
                    ped = CreatePed(0, model, coords.x, coords.y, coords.z - 1.0, heading, false, true)
                    FreezeEntityPosition(ped, true)
                    SetEntityInvincible(ped, true)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                end
            end
            exports["ox_target"]:addModel(model, options)
        end
    
        function point:onExit()
            if DoesEntityExist(ped) then
                DeleteEntity(ped)
            end
            exports["ox_target"]:removeModel(model, options.name)
        end
    
        function point:nearby()
            local wait = 1000
            local inArea = self.currentDistance < 2.5
            if inArea then
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
    end
end)