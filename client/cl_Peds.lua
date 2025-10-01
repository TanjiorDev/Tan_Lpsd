--############################
--########### CLIENT #########
--############################

Citizen.CreateThread(function()
    for _, npc in pairs(ConfigPolice.NPCs) do
        local hash = GetHashKey(npc.model)
        RequestModel(hash)
        while not HasModelLoaded(hash) do Wait(20) end

        local ped = CreatePed(4, npc.model, npc.coords.x, npc.coords.y, npc.coords.z - 1, npc.coords.w, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, npc.freeze)
        SetEntityInvincible(ped, npc.invincible)
        SetModelAsNoLongerNeeded(hash)

        npc.handle = ped
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local dist = #(p - vector3(x, y, z))
    local scale = 200 / (GetGameplayCamFov() * dist)

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, npc in pairs(ConfigPolice.NPCs) do
            if npc.handle and DoesEntityExist(npc.handle) then
                local coords = GetEntityCoords(npc.handle)
                local dist = #(playerCoords - coords)
                if dist < 10.0 then -- 👈 distance max pour voir le texte
                    DrawText3D(coords.x, coords.y, coords.z + 1.0, npc.text or "PNJ")
                end
            end
        end
    end
end)
