CreateThread(function()
    while not ESX.PlayerLoaded do
        Wait(100)
    end

    Config.available = lib.callback.await("starterpack:configRequest")

    local coords = Config.location
    local point = lib.points.new({
        coords = coords,
        distance = Config.distance
    })
    local ped

    if Config.blip then
        local prop = Config.blip
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

    if Config.target and Config.ped then
        local heading = Config.ped.heading
        local model = type(Config.ped.model) == "number" and Config.ped.model or joaat(Config.ped.model)
        if not HasModelLoaded(model) then
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait()
            end
        end

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
        exports["ox_target"]:addModel(model, options)

        function point:onEnter()
            if ped == nil or not DoesEntityExist(ped) then
                ped = CreatePed(0, model, coords.x, coords.y, coords.z - 1.0, heading, false, true)
                FreezeEntityPosition(ped, true)
                SetEntityInvincible(ped, true)
                SetBlockingOfNonTemporaryEvents(ped, true)
            end
        end

        function point:onExit()
            if DoesEntityExist(ped) then
                DeleteEntity(ped)
            end
        end

        function point:nearby()
            local wait = 1000
            if self.currentDistance < 2.5 then
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
    elseif Config.marker then
        function point:nearby()
            if self.currentDistance < 1.5 then
                if not textUI then
                    textUI = true
                    lib.showTextUI(labelText("claim"), {icon="e"})
                end
                if IsControlJustPressed(0, 38) then
                    claimStarterPack()
                    Wait(1000)
                end
            else
                if textUI then
                    textUI = false
                    lib.hideTextUI()
                end
            end
            DrawMarker(Config.marker.type, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.marker.scale, Config.marker.scale, Config.marker.scale, 200, 20, 20, 150, false, true, 2, false, nil, nil, false)
        end
    end
end)