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

-- === Utilitaires grade & tri ===
local function getPlayerGrade()
    local pdata = ESX.PlayerData or ESX.GetPlayerData()
    if not pdata or not pdata.job then return 0 end

    local g = pdata.job.grade
    if type(g) == 'number' then return g end
    if type(g) == 'table' then
        if type(g.level) == 'number' then return g.level end
        if type(g.grade) == 'number' then return g.grade end
        if type(g.id)    == 'number' then return g.id    end
    end
    if type(pdata.job.grade_level) == 'number' then return pdata.job.grade_level end
    return 0
end

-- Construit une liste triée des entrées { grade, data } à partir du config
local function getSortedGradeEntries()
    local entries, hasNumericKeys = {}, false

    -- Essaye d'abord comme dictionnaire (inclut 0 et "0")
    for k, v in pairs(ConfigPolice.EquipmentByGrade or {}) do
        local nk = tonumber(k)
        if nk ~= nil then
            entries[#entries+1] = { grade = nk, data = v }
            hasNumericKeys = true
        end
    end

    if hasNumericKeys then
        table.sort(entries, function(a, b) return a.grade < b.grade end)
        return entries
    end

    -- Fallback: tableau 1..N
    for i, v in ipairs(ConfigPolice.EquipmentByGrade or {}) do
        entries[#entries+1] = { grade = i, data = v }
    end
    return entries
end

-- === MENU ===
local armoryMenu = zUI.CreateMenu("MENU POLICE","INTERACTIONS", "Intéractions Police :", ConfigPolice.themes)

zUI.SetItems(armoryMenu, function()
    -- Déposer toutes les armes portées + signaler au serveur de retirer les items (armes/munitions)
    zUI.Button("Déposer ses armes", nil, {}, function(onSelected)
        if not onSelected then return end
        local ped = PlayerPedId()

        -- Retire TOUTES les armes du ped (plus fiable que boucler)
        RemoveAllPedWeapons(ped, true)

        ESX.ShowNotification("Vous avez déposé toutes vos armes.")
        -- Le serveur retirera les items (armes & munitions) dans ox_inventory
        TriggerServerEvent(ConfigPolice.RemoveItemEvent)
    end)

    -- Récupération grade joueur (robuste)
    local grade = getPlayerGrade()

    -- Affichage des équipements autorisés selon le grade (inclut la clé 0)
    local anyShown = false
    local entries = getSortedGradeEntries()

    for _, e in ipairs(entries) do
        local infos = e.data
        local gkey  = e.grade
        if grade >= gkey then
            anyShown = true
            zUI.Button(("Équipement de %s"):format(infos.label or ("grade " .. gkey)), nil, {}, function(onSelected)
                if not onSelected then return end
                -- Ne PAS envoyer le grade : le serveur le déduit côté ESX
                TriggerServerEvent('armorypolice:giveEquipment')
            end)
        end
    end

    if not anyShown then
        zUI.Separator("~y~Aucun équipement disponible pour votre grade.")
    end
end)

-- === Cible ox_target ===
exports.ox_target:addBoxZone({
    coords = ConfigPolice.Armurerie.coords,
    size = ConfigPolice.Armurerie.size,
    rotation = ConfigPolice.Armurerie.rotation,
    debug = false,
    options = {
        {
            name = ConfigPolice.Armurerie.Armory.name,
            event = 'ouvrir:armurerie', -- (tu peux supprimer 'event' si tu utilises onSelect)
            icon = ConfigPolice.Armurerie.Armory.icon,
            label = ConfigPolice.Armurerie.Armory.label,
            distance = ConfigPolice.Armurerie.Armory.distance,
            onSelect = function()
                if ESX.PlayerData.job and ESX.PlayerData.job.name == ConfigPolice.JobRequired then
                    OpenArmuriePolice()
                else
                    ESX.ShowNotification("~r~Vous n'êtes pas autorisé.")
                end
            end,
        }
    }
})

function OpenArmuriePolice()
    zUI.SetVisible(armoryMenu, not zUI.IsVisible(armoryMenu))
end
