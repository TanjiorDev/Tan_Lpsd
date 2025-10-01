local zUI = exports["zUI-v2"]:getObject()
local ESX = exports["es_extended"]:getSharedObject()

-- Met à jour les données du joueur lorsqu'il se connecte
RegisterNetEvent('esx:playerLoaded', function(playerData)
    ESX.PlayerData = playerData
end)

RegisterNetEvent("esx:setJob", function(job)
    ESX.PlayerData = ESX.PlayerData or {}
    ESX.PlayerData.job = job
end)

local garageMenu = zUI.CreateMenu("Garage Police","INTERACTIONS", "Choix des véhicules :", ConfigPolice.themes)

-- ===== Helpers =====
local function loadModel(model)
    local hash = type(model) == "string" and GetHashKey(model) or model
    if not IsModelInCdimage(hash) or not IsModelAVehicle(hash) then
        ESX.ShowNotification(("Modèle introuvable: %s"):format(tostring(model)))
        return nil
    end
    RequestModel(hash)
    local timeout = GetGameTimer() + 8000
    while not HasModelLoaded(hash) do
        Wait(0)
        if GetGameTimer() > timeout then
            ESX.ShowNotification("Chargement modèle trop long.")
            return nil
        end
    end
    return hash
end

local function getSpawnPosition()
    -- 1) vector4 (pos système "pos.spawnPoliceVehicle.position")
    local posCfg = ConfigPolice.pos and ConfigPolice.pos.spawnPoliceVehicle and ConfigPolice.pos.spawnPoliceVehicle.position
    if posCfg then
        local x,y,z,w = posCfg.x or posCfg[1], posCfg.y or posCfg[2], posCfg.z or posCfg[3], posCfg.w or posCfg[4] or 0.0
        if x and y and z then
            return vector3(x,y,z), (w or 0.0)
        end
    end
    -- 2) vec3 + heading (système "Garage.Spawn")
    local spawn = ConfigPolice.Garage and ConfigPolice.Garage.Spawn or {}
    local coords = spawn.coords
    local heading = spawn.heading or 0.0
    if coords then
        return coords, heading
    end
    -- 3) fallback: position du joueur
    local ped = PlayerPedId()
    return GetEntityCoords(ped), GetEntityHeading(ped)
end

local function clearAreaForVehicle(coords)
    -- libère un peu la zone pour éviter les collisions au spawn
    ClearAreaOfEverything(coords.x, coords.y, coords.z, 3.0, false, false, false, false)
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
end

-- ===== Fonction UNIQUE de spawn =====
local function spawnPoliceCar(entry)
    if not entry then return end

    local model = type(entry) == "table" and entry.model or entry
    if not model then
        ESX.ShowNotification("Modèle non défini.")
        return
    end

    local hash = loadModel(model)
    if not hash then return end

    local coords, heading = getSpawnPosition()
    clearAreaForVehicle(coords)

    local veh = CreateVehicle(hash, coords.x, coords.y, coords.z, heading, true, false)
    if not DoesEntityExist(veh) then
        ESX.ShowNotification("Échec du spawn du véhicule.")
        SetModelAsNoLongerNeeded(hash)
        return
    end

    SetVehicleOnGroundProperly(veh)
    SetEntityAsMissionEntity(veh, true, true)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetVehRadioStation(veh, "OFF")
    SetVehicleDirtLevel(veh, 0.0)

    -- Plaque
    local cfg = type(entry) == "table" and entry or {}
    local plate = (cfg.plate or "LSPD") .. tostring(math.random(100, 999))
    SetVehicleNumberPlateText(veh, plate)

    -- Options (facultatives)
    if cfg.livery ~= nil then
        local l = tonumber(cfg.livery) or 0
        if GetVehicleLiveryCount(veh) > 0 then SetVehicleLivery(veh, l) end
    end
    if type(cfg.extras) == "table" then
        for id, enabled in pairs(cfg.extras) do
            local eid = tonumber(id)
            if eid and DoesExtraExist(veh, eid) then
                SetVehicleExtra(veh, eid, enabled and 0 or 1)
            end
        end
    end
    if cfg.windowTint ~= nil then SetVehicleWindowTint(veh, tonumber(cfg.windowTint) or 0) end

    -- Moteur
    SetVehicleEngineOn(veh, true, true, false)

    -- Mettre le joueur conducteur
    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)

    SetModelAsNoLongerNeeded(hash)
    ESX.ShowNotification(("Véhicule sorti : %s"):format(cfg.label or tostring(model)))
end

-- ===== Menu Garage =====
zUI.SetItems(garageMenu, function()
    if type(ConfigPolice.AuthorizedPoliceVehicles) ~= "table" or next(ConfigPolice.AuthorizedPoliceVehicles) == nil then
        zUI.Separator("Aucun véhicule disponible.")
        return
    end

    for _, v in ipairs(ConfigPolice.AuthorizedPoliceVehicles) do
        local label = v.label or v.model or "Véhicule"
        zUI.Button(label, "Sortir ce véhicule", {}, function(onSelected)
            if not onSelected then return end
            spawnPoliceCar(v)
            if zUI.CloseAll then zUI.CloseAll() else zUI.SetVisible(garageMenu, false) end
        end)
    end
end)



-- ========== Helpers ==========

local function ShowHelp(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local function notify(title, message, icon)
    if zUI and zUI.SendNotification then
        TriggerEvent('zUI:SendNotification', title or "", message or "", {
            type = "notification",
            icon = icon or "CHAR_DEFAULT",
            duration = 5000
        })
    else
        ESX.ShowNotification((title and ("%s"):format(title) or "") .. (message or ""))
    end
end

local function requestControl(entity, tries)
    tries = tries or 20
    if not DoesEntityExist(entity) then return false end
    while not NetworkHasControlOfEntity(entity) and tries > 0 do
        NetworkRequestControlOfEntity(entity)
        Wait(50)
        tries = tries - 1
    end
    return NetworkHasControlOfEntity(entity)
end

local function deleteVehicleSafe(veh)
    if not DoesEntityExist(veh) then return false end
    if not requestControl(veh) then return false end
    SetEntityAsMissionEntity(veh, true, true)
    SetVehicleAsNoLongerNeeded(veh)
    DeleteVehicle(veh)
    if DoesEntityExist(veh) then
        -- fallback
        DeleteEntity(veh)
    end
    return not DoesEntityExist(veh)
end

-- ========== Ranger Police ==========


CreateThread(function()
    local key = (ConfigPolice.Ranger and ConfigPolice.Ranger.PoliceRanger and ConfigPolice.Ranger.PoliceRanger.key) or 38 -- E
    local distMax = (ConfigPolice.Ranger and ConfigPolice.Ranger.PoliceRanger and ConfigPolice.Ranger.PoliceRanger.distance) or 2.5
    local target = ConfigPolice.Ranger and ConfigPolice.Ranger.PoliceRanger and ConfigPolice.Ranger.PoliceRanger.coords
    if not target then return end

    local targetVec = vector3(target.x, target.y, target.z)
    local uiShown = false

    while true do
        local wait = 250
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local dist = #(coords - targetVec)

        if dist <= distMax then
            wait = 0

            -- ✅ Affiche l'invite une seule fois quand on entre dans la zone
            if not uiShown then
                lib.showTextUI('[E] - pour ranger le véhicule de police', {
                    position = 'right-center',      -- optionnel
                    icon = 'fa-solid fa-gas-pump',  -- optionnel (FontAwesome via ox_lib)
                })
                uiShown = true
            end

            if IsControlJustReleased(0, key) then
                local veh = 0

                -- Priorité : le véhicule occupé par le joueur
                if IsPedInAnyVehicle(ped, false) then
                    veh = GetVehiclePedIsIn(ped, false)
                else
                    -- Sinon : le plus proche dans un petit rayon
                    veh = ESX.Game.GetClosestVehicle(coords)
                    if veh ~= 0 and #(GetEntityCoords(veh) - targetVec) > 6.0 then
                        veh = 0
                    end
                end

                if veh ~= 0 and DoesEntityExist(veh) then
                    local ok = deleteVehicleSafe(veh)
                    if ok then
                        notify("Rangement", "Véhicule de police rangé avec succès.", "CHAR_CALL911")
                    else
                        notify("Rangement", "Impossible de ranger ce véhicule (contrôle réseau).", "CHAR_BLOCKED")
                    end
                else
                    notify("Rangement", "Aucun véhicule à proximité.", "CHAR_BLOCKED")
                end
            end
        else
            -- ✅ Cache l'invite quand on sort de la zone
            if uiShown then
                lib.hideTextUI()
                uiShown = false
            end
        end

        Wait(wait)
    end
end)

-- ===== OX_TARGET zone =====
CreateThread(function()
    local zone = ConfigPolice.Garage and ConfigPolice.Garage.PoliceGarage
    if not zone then
        return
    end

    exports.ox_target:addBoxZone({
        coords = zone.coords,
        size = zone.size,
        drawSprite = true,
        options = {
            {
                name = zone.garageMenu.name,
                icon = zone.garageMenu.icon,
                label = zone.garageMenu.label,
                canInteract = function()
                    local p = ESX.PlayerData or ESX.GetPlayerData()
                    return p and p.job and p.job.name == (ConfigPolice.JobRequired or "police")
                end,
                onSelect = function()
                    OpenMenuGarage()
                end,
                distance = zone.garageMenu.distance or 2.0
            }
        }
    })
end)

function OpenMenuGarage()
    zUI.SetVisible(garageMenu, not zUI.IsVisible(garageMenu))
end
