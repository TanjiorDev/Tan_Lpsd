-- client.lua (zUI-v2 only)
local zUI = exports["zUI-v2"]:getObject()
local ESX = exports["es_extended"]:getSharedObject()

-- ===== ESX sync =====
RegisterNetEvent('esx:playerLoaded', function(playerData)
    ESX.PlayerData = playerData
end)
RegisterNetEvent('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

-- ===== Helpers =====
local function hasJob(requiredJob, minGrade)
    local data = ESX.GetPlayerData()
    if not data or not data.job or data.job.name ~= requiredJob then return false end
    local grade = data.job.grade or data.job.grade_level or 0
    return grade >= (minGrade or 0)
end

local function canUseInventory()
    if LocalPlayer and LocalPlayer.state and LocalPlayer.state.invBusy then
        ESX.ShowNotification("~r~Impossible d'ouvrir l'inventaire (action en cours).")
        return false
    end
    return true
end

-- ===== State =====
local _evidenceCache = {}
local _selectedEvidence = nil

-- ===== Menus =====
local evidenceListMenu    = zUI.CreateMenu("Coffres de Saisies", "Sélection", "Actifs", ConfigPolice.themes)
local evidenceActions     = zUI.CreateSubMenu(evidenceListMenu, "Coffre sélectionné", "Actions", "Gestion du coffre", ConfigPolice.themes)
local evidenceConfirmDel  = zUI.CreateSubMenu(evidenceActions, "Confirmer la suppression", "Attention", "Action définitive", ConfigPolice.themes)
local evidenceConfirmForce= zUI.CreateSubMenu(evidenceActions, "Suppression FORCÉE", "Danger", "Perte définitive", ConfigPolice.themes)

-- ===== Fetch depuis le serveur =====
local _lastIncludeClosed = false
local function fetchEvidenceList(includeClosed, cb)
    _lastIncludeClosed = includeClosed and true or false
    lib.callback('police:evidence:list', false, function(list)
        _evidenceCache = list or {}
        if cb then cb(_evidenceCache) end
    end, _lastIncludeClosed)
end

local function OpenEvidenceList(includeClosed)
    fetchEvidenceList(includeClosed, function()
                local visible = zUI.IsVisible(evidenceListMenu)
        zUI.SetVisible(evidenceListMenu, not visible)
    end)
end

-- ===== Création (form ox_lib) =====
local function OpenCreateEvidenceDialog()
    local input = lib.inputDialog('Créer un coffre de saisie', {
        { type = 'input',   label = 'Suspect (nom/pseudonyme)', required = true, min = 2, max = 60, placeholder = 'Ex: John Doe' },
        { type = 'input',   label = 'Affaire / Référence (ex: EV-123)', required = true, min = 2, max = 32, placeholder = 'Ex: EV-123' },
        { type = 'textarea',label = 'Notes (optionnel)', required = false, max = 300, placeholder = 'Détails, contexte, etc.' }
    })
    if not input then return end

    local function trim(s) return (s or ""):gsub("^%s*(.-)%s*$", "%1") end
    local suspect = trim(input[1])
    local caseId  = trim(input[2])
    local notes   = input[3] or ""

    if #suspect < 2 or #caseId < 2 then
        ESX.ShowNotification("Champs invalides.")
        return
    end

    TriggerServerEvent('police:evidence:create', { suspect = suspect, caseId = caseId, notes = notes })
end

RegisterNetEvent('police:evidence:created', function(data)
    ESX.ShowNotification(("Coffre créé : %s"):format(data.label or data.id))
    if data and data.id then
        TriggerServerEvent('police:evidence:requestOpen', data.id)
        if zUI.IsVisible(evidenceListMenu) then
            fetchEvidenceList(_lastIncludeClosed)
        end
    end
end)

-- ===== Menu : Liste =====
zUI.SetItems(evidenceListMenu, function()
    zUI.Separator(_lastIncludeClosed and "Coffres (actifs + scellés)" or "Coffres actifs")

    if not _evidenceCache or #_evidenceCache == 0 then
        zUI.Separator("~o~Aucun coffre de saisie disponible.")
        return
    end

    for _, e in ipairs(_evidenceCache) do
        if _lastIncludeClosed or not e.closed then
            local desc  = ("Affaire: %s\nSuspect: %s\nDate: %s"):format(e.caseId or "—", e.suspect or "—", e.prettyTime or "—")
            local right = e.closed and "Scellé" or "Ouvert"
            zUI.Button(e.label or ("Coffre %s"):format(e.id), desc, { RightLabel = right }, function(sel)
                if not sel then return end
                _selectedEvidence = e
            end,evidenceActions)
        end
    end

    zUI.Line()
    zUI.Button(_lastIncludeClosed and "Afficher uniquement les actifs" or "Afficher aussi les scellés", nil, {}, function(sel)
        if not sel then return end
        OpenEvidenceList(not _lastIncludeClosed)
    end)
end)

-- ===== Menu : Actions =====
zUI.SetItems(evidenceActions, function()
    local e = _selectedEvidence
    if not e then
        zUI.Separator("Aucun coffre sélectionné.")
        return
    end

    zUI.Separator(("ID: %s"):format(e.id))
    zUI.Separator(("Affaire: %s | Suspect: %s"):format(e.caseId or "—", e.suspect or "—"))
    zUI.Separator(("Date: %s"):format(e.prettyTime or "—"))

    -- Ouvrir
    local canOpen = not e.closed
    zUI.Button("🔓 Ouvrir", canOpen and "Accéder à l'inventaire du coffre" or "~c~Coffre scellé", { Disabled = not canOpen }, function(sel)
        if not sel or not canOpen then return end
        if not canUseInventory() then return end
        if LocalPlayer.state.invOpen then
            exports.ox_inventory:closeInventory()
            Wait(100)
        end
        TriggerServerEvent('police:evidence:requestOpen', e.id)
        zUI.CloseAll()
    end)

    -- Sceller
    local canSeal = not e.closed
    zUI.Button(canSeal and "🧷 Sceller" or "✅ Déjà scellé", canSeal and "Interdire toute ouverture" or "~c~Aucune action nécessaire", { Disabled = not canSeal }, function(sel)
        if not sel or not canSeal then return end
        TriggerServerEvent('police:evidence:close', e.id)
        ESX.ShowNotification("Coffre scellé.")
        e.closed = true
        fetchEvidenceList(_lastIncludeClosed, function()
        end)
    end,evidenceListMenu)

    zUI.Line()

    -- Supprimer (non forcé)
    zUI.Button("🗑️ Supprimer", "Refusé si le coffre contient des objets", { RightLabel = "~r~Définitif" }, function(sel)
        if sel then zUI.OpenMenu(evidenceConfirmDel) end
    end)

    -- Supprimer (FORCÉ)
    zUI.Button("🗑️❗ Supprimer (FORCÉ)", "Supprime même s'il reste des objets", { RightLabel = "~r~Danger" }, function(sel)
        if sel then  end
    end,evidenceConfirmForce)
end)

-- ===== Menu : Confirmation suppression (non forcée) =====
zUI.SetItems(evidenceConfirmDel, function()
    local e = _selectedEvidence
    if not e then
        zUI.Separator("Aucun coffre sélectionné.")
        return
    end

    zUI.Separator("Cette action est définitive.")
    zUI.Separator(("Coffre: %s | Affaire: %s"):format(e.id, e.caseId or "—"))

    zUI.Button("❌ Annuler", nil, {}, function(sel)
        -- navigation via 5e param
    end, evidenceActions)

    zUI.Button("✅ Supprimer", "Irréversible", { RightLabel = "Confirmer" }, function(sel)
        if not sel then return end
        TriggerServerEvent('police:evidence:delete', e.id, false)
        ESX.ShowNotification("Suppression demandée.")
        fetchEvidenceList(_lastIncludeClosed, function()
            _selectedEvidence = nil
       
        end)
    end,evidenceListMenu)
end)

-- ===== Menu : Confirmation suppression (FORCÉE) =====
zUI.SetItems(evidenceConfirmForce, function()
    local e = _selectedEvidence
    if not e then
        zUI.Separator("Aucun coffre sélectionné.")
        return
    end

    zUI.Separator("Suppression FORCÉE : tous les objets seront perdus.")
    zUI.Separator(("Coffre: %s | Affaire: %s"):format(e.id, e.caseId or "—"))

    zUI.Button("❌ Annuler", nil, {}, function(sel)
        -- navigation via 5e param
    end, evidenceActions)

    zUI.Button("✅ Supprimer (FORCÉ)", "~r~Irréversible", { RightLabel = "~r~Confirmer" }, function(sel)
        if not sel then return end
        TriggerServerEvent('police:evidence:delete', e.id, true)
        ESX.ShowNotification("~g~Suppression (forcée) demandée.")
        fetchEvidenceList(_lastIncludeClosed, function()
            _selectedEvidence = nil
        end)
    end,evidenceListMenu)
end)

-- ===== Ouverture effective (serveur -> client) =====
RegisterNetEvent('police:evidence:open', function(stashId)
    exports.ox_inventory:openInventory('stash', stashId)
end)

-- ===== Compat éventuelle : ouvrir un ID reçu d’ailleurs =====
RegisterNetEvent('police:evidence:list:select', function(args)
    if type(args) ~= 'table' or not args.id then return end
    local id = args.id
    local found
    for _, e in ipairs(_evidenceCache) do
        if e.id == id then
            found = e
            break
        end
    end
    _selectedEvidence = found or { id = id, closed = args.closed and true or false, label = ("Coffre: %s"):format(id) }
    zUI.OpenMenu(evidenceActions)
end)

-- ===== Commande utilitaire =====
RegisterCommand("evidences", function(_, args)
    OpenEvidenceList(args[1] == "all")
end)

-- ===== Zones ox_target =====
-- Coffre Principal (fixe)
exports.ox_target:addBoxZone({
    coords   = ConfigPolice.Coffre.PoliceCoffre.coords,
    size     = ConfigPolice.Coffre.PoliceCoffre.size,
    rotation = ConfigPolice.Coffre.PoliceCoffre.rotation,
    debug    = false,
    options  = {{
        name  = "coffre_police_principal",
        icon  = ConfigPolice.Coffre.PoliceCoffre.icon,
        label = ConfigPolice.Coffre.PoliceCoffre.label,
        canInteract = function()
            return hasJob(ConfigPolice.Coffre.PoliceCoffre.jobRequired, 0)
        end,
        onSelect = function()
            exports.ox_inventory:openInventory('stash', ConfigPolice.Coffre.PoliceCoffre.stashId)
        end,
        distance = ConfigPolice.Coffre.PoliceCoffre.distance
    }}
})

-- Coffre Saisies (fixe)
exports.ox_target:addBoxZone({
    coords   = ConfigPolice.Saisies.PoliceSaisies.coords,
    size     = ConfigPolice.Saisies.PoliceSaisies.size,
    rotation = ConfigPolice.Saisies.PoliceSaisies.rotation,
    debug    = false,
    options  = {{
        name  = "coffre_police_saisies_fixe",
        icon  = ConfigPolice.Saisies.PoliceSaisies.icon,
        label = ConfigPolice.Saisies.PoliceSaisies.label,
        canInteract = function()
            return hasJob(ConfigPolice.Saisies.PoliceSaisies.jobRequired, 0)
        end,
        onSelect = function()
            exports.ox_inventory:openInventory('stash', ConfigPolice.Saisies.PoliceSaisies.stashId)
        end,
        distance = ConfigPolice.Saisies.PoliceSaisies.distance
    }}
})

-- Salle des preuves (dynamiques)
exports.ox_target:addBoxZone({
    coords   = ConfigPolice.Evidence.zone.coords,
    size     = ConfigPolice.Evidence.zone.size,
    rotation = ConfigPolice.Evidence.zone.rotation,
    debug    = false,
    options  = {
        {
            name  = "evidence_create",
            icon  = ConfigPolice.Evidence.zone.icon,
            label = ConfigPolice.Evidence.zone.labelCreate,
            distance = ConfigPolice.Evidence.zone.distance,
            canInteract = function()
                return hasJob(ConfigPolice.Evidence.job, ConfigPolice.Evidence.minGrade)
            end,
            onSelect = function()
                OpenCreateEvidenceDialog()
            end,
        },
        {
            name  = "evidence_browse",
            icon  = ConfigPolice.Evidence.zone.icon,
            label = ConfigPolice.Evidence.zone.labelBrowse,
            distance = ConfigPolice.Evidence.zone.distance,
            canInteract = function()
                return hasJob(ConfigPolice.Evidence.job, ConfigPolice.Evidence.minGrade)
            end,
            onSelect = function()
                OpenEvidenceList(false) -- true pour afficher aussi les scellés
            end,
        },
    }
})
