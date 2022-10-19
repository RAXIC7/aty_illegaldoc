QBCore = nil 

Citizen.CreateThread(function()
   while QBCore == nil do
   	TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
   	Citizen.Wait(250)
   end
end)

local illegaldoc = Config.Illegaldoc

Citizen.CreateThread(function()
    while true do
        local sleep = 2000
        local player = PlayerPedId()
        local playercoords = GetEntityCoords(player)
        local distance = GetDistanceBetweenCoords(playercoords, illegaldoc.x, illegaldoc.y, illegaldoc.z, true)
            if distance < 3 then
                sleep = 1
                DrawText3D(illegaldoc.x, illegaldoc.y, illegaldoc.z, '[E] Tedavi Ol')
                if IsControlJustReleased(0, 38) then
                    TriggerEvent("mythic_progbar:client:progress", {
                        name = "üzüm",
                        duration = Config.TedaviSuresi,
                        label = "Tedavi Ediliyorsun",
                        useWhileDead = true,
                        canCancel = false,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = true,
                            disableCombat = true,
                        },
                        animation = {
                            animDict = "missheistdockssetup1clipboard@idle_a",
                            anim = "idle_a",
                        },
                        prop = {
                            model = "prop_paper_bag_small",
                        }
                    }, function(status)
                        if not status then
                            TriggerEvent("hospital:client:Revive", GetPlayerServerId(PlayerPedId()))
                        end
                    end)
                end
            end

        Citizen.Wait(sleep)
    end
end)

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.30, 0.30)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 250
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 75)
end

Citizen.CreateThread(function()
    local NpcCoords = Config.NpcCoords
    RequestModel(GetHashKey(Config.Npc))
    while not HasModelLoaded(GetHashKey(Config.Npc)) do
        Wait(1)
    end
    npc = CreatePed(1, GetHashKey(Config.Npc), NpcCoords.x, NpcCoords.y, NpcCoords.z, NpcCoords.w, false, true)
    SetPedCombatAttributes(npc, 46, true)               
    SetPedFleeAttributes(npc, 0, 0)               
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetEntityAsMissionEntity(npc, true, true)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
end)

if Config.BlipAc then
    CreateThread(function()
        local blip = AddBlipForCoord(illegaldoc.x, illegaldoc.y, illegaldoc.z)
        SetBlipSprite(blip, 93)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.5)
        SetBlipColour(blip, 51)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.illegaldocad)
        EndTextCommandSetBlipName(blip)
    end)
end