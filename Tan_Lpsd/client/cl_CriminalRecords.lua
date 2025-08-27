local zUI = exports["zUI-v2"]:getObject()
local ESX = exports["es_extended"]:getSharedObject()

-- Sync ESX
RegisterNetEvent('esx:playerLoaded', function(xPlayer) ESX.PlayerData = xPlayer end)
RegisterNetEvent('esx:setJob', function(job) ESX.PlayerData.job = job end)

-- ========= Helpers =========


local function starts(s, prefix)
    if not s or not prefix then return false end
    return s:sub(1, #prefix) == prefix
end

-- ========= State =========
local ItemsList   = {"Aucun","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
local filterIndex = 1
local itemIndex   = 1
local IsInEditMode = false

-- Saisie création
local nameSuspect, ageSuspect, heightSuspect, nationalitySuspect, sexSuspect
local nameOfSuspect, ageOfSuspect, heightOfSuspect, nationalityOfSuspect, sexOfSuspect

-- Sélection courant
local nameSelected, ageSelected, heightSelected, nationalitySelected, sexSelected, depositarySelected, dateSelected
local selectedMotif -- pour gestion d’un motif

-- Data (fournies par tes fonctions existantes)
listeData  = listeData  or {}
casierData = casierData or {}

-- ========= Menus zUI =========
local MainMenu     = zUI.CreateMenu("CASIER JUDICIAIRE", "INTERACTION", "MENU", ConfigPolice.themes)
local CreateMenu   = zUI.CreateSubMenu(MainMenu, "CRÉATION", "", "FORMULAIRE", ConfigPolice.themes)
local ListMenu     = zUI.CreateSubMenu(MainMenu, "LISTE INDIVIDU", "", "CITIZENS", ConfigPolice.themes)
local InfoMenu     = zUI.CreateSubMenu(ListMenu, "INFO", "", "DÉTAILS", ConfigPolice.themes)
local ViewMenu     = zUI.CreateSubMenu(InfoMenu, "CASIER", "", "DOSSIER", ConfigPolice.themes)
local FilterMenu   = zUI.CreateSubMenu(ListMenu, "FILTRE A-Z", "", "CHOISIR", ConfigPolice.themes)
local MotifMenu    = zUI.CreateSubMenu(ViewMenu, "GESTION MOTIF", "", "ACTIONS", ConfigPolice.themes)

-- Ouvre le menu principal
function OpenMenu()
    zUI.SetVisible(MainMenu, not zUI.IsVisible(MainMenu))
end

-- ========= Rendu Menus =========
-- ========= Rendu Menus =========
zUI.SetItems(MainMenu, function()
    -- Bouton: Créer un casier vierge
    zUI.Button("Créer un casier vierge", "", { RightLabel = "➤" }, function(onSelected)
        if not onSelected then return end
        -- Navigation auto via le 5e argument
    end, CreateMenu)

    -- Bouton: Consulter les casiers
    local count = type(listeData) == "table" and #listeData or 0
    local label = ("Consulter les Casiers (~g~%d~s~)"):format(count)

    zUI.Button(label, "", { RightLabel = "➤" }, function(onSelected)
        if not onSelected then return end
        if type(LoadListe) == "function" then LoadListe() end
        -- Navigation auto via le 5e argument
    end, ListMenu)
end)



-- CREATE MENU (version ox_lib inputDialog)
zUI.SetItems(CreateMenu, function()
    zUI.Separator("~b~Informations de l'individu")

    -- 📝 Formulaire complet (tout-en-un)
    zUI.Button("📝 Remplir via formulaire (ox_lib)", "Saisir toutes les infos en une fois", { RightLabel = "→" }, function(sel)
        if not sel then return end
                    local playerPed = PlayerPedId()

            -- ❄️ Geler le joueur
            FreezeEntityPosition(playerPed, true)
            SetEntityInvincible(playerPed, true)

            -- ✅ Bloquer seulement les mouvements (conserve la caméra + ox_target)
            SetPlayerControl(PlayerId(), false, 2) -- 2 = désactive déplacement/sprint/saut, pas la caméra
        if not lib or not lib.inputDialog then
            if ESX and ESX.ShowNotification then ESX.ShowNotification() end
            return
        end

        local out = lib.inputDialog('Création casier', {
            { type = 'input',  label = 'Nom & Prénom', default = nameSuspect or '', required = true, min = 2, max = 30, icon = 'id-card' },
            { type = 'number', label = 'Âge',           default = ageSuspect,        required = true, min = 0,  max = 130, icon = 'hashtag' },
            { type = 'number', label = 'Taille (cm)',   default = heightSuspect,     required = true, min = 50, max = 250, icon = 'ruler' },
            { type = 'input',  label = 'Nationalité',   default = nationalitySuspect or '', required = true, min = 2, max = 20, icon = 'flag' },
            { type = 'select', label = 'Sexe',          options = {
                    { label = 'Homme', value = 'H' },
                    { label = 'Femme', value = 'F' }
                }, default = sexSuspect or 'H', required = true, icon = 'venus-mars'
            },
        })
        -- 🔓 Défreeze proprement
            FreezeEntityPosition(playerPed, false)
            SetEntityInvincible(playerPed, false)
            SetPlayerControl(PlayerId(), true, 0)
        if out then
            nameSuspect, ageSuspect, heightSuspect, nationalitySuspect, sexSuspect =
                out[1], tonumber(out[2]), tonumber(out[3]), out[4], out[5]

            nameOfSuspect        = "~g~" .. (nameSuspect or "")
            ageOfSuspect         = "~g~" .. (ageSuspect or "")
            heightOfSuspect      = "~g~" .. (heightSuspect or "")
            nationalityOfSuspect = "~g~" .. (nationalitySuspect or "")
            sexOfSuspect         = "~g~" .. (sexSuspect or "")
        end
    end)

    -- Nom & Prénom (champ individuel)
    zUI.Button("Nom & Prénom :", nil, { RightLabel = nameOfSuspect or "~c~(vide)" }, function(sel)
        if not sel then return end
                    local playerPed = PlayerPedId()

            -- ❄️ Geler le joueur
            FreezeEntityPosition(playerPed, true)
            SetEntityInvincible(playerPed, true)

            -- ✅ Bloquer seulement les mouvements (conserve la caméra + ox_target)
            SetPlayerControl(PlayerId(), false, 2) -- 2 = désactive déplacement/sprint/saut, pas la caméra
        local v
        if lib and lib.inputDialog then
            local input = lib.inputDialog('Nom & Prénom', {
                { type = 'input', label = 'Nom & Prénom', default = nameSuspect or '', required = true, min = 2, max = 30 }
            })
                    -- 🔓 Défreeze proprement
            FreezeEntityPosition(playerPed, false)
            SetEntityInvincible(playerPed, false)
            SetPlayerControl(PlayerId(), true, 0)
            v = input and input[1]
        else
            v = TextInput("Nom et Prénom de l'individu", nameSuspect or "", 30)
        end

        if v and v ~= "" then
            nameSuspect = v
            nameOfSuspect = "~g~" .. v
        else
            if ESX and ESX.ShowNotification then ESX.ShowNotification("Champ invalide") end
        end
    end)

    -- Âge (champ individuel)
    zUI.Button("Âge :", nil, { RightLabel = ageOfSuspect or "~c~(vide)" }, function(sel)
        if not sel then return end
                    local playerPed = PlayerPedId()

            -- ❄️ Geler le joueur
            FreezeEntityPosition(playerPed, true)
            SetEntityInvincible(playerPed, true)

            -- ✅ Bloquer seulement les mouvements (conserve la caméra + ox_target)
            SetPlayerControl(PlayerId(), false, 2) -- 2 = désactive déplacement/sprint/saut, pas la caméra
        local n
        if lib and lib.inputDialog then
            local input = lib.inputDialog("Âge de l'individu", {
                { type = 'number', label = 'Âge', default = ageSuspect, required = true, min = 0, max = 130 }
            })
                    -- 🔓 Défreeze proprement
            FreezeEntityPosition(playerPed, false)
            SetEntityInvincible(playerPed, false)
            SetPlayerControl(PlayerId(), true, 0)
            n = input and tonumber(input[1])
        else
            n = NumberInput("Âge de l'individu", ageSuspect or "", 3)
        end

        if n then
            ageSuspect = n
            ageOfSuspect = "~g~" .. n
        else
            if ESX and ESX.ShowNotification then ESX.ShowNotification("Champ invalide") end
        end
    end)

    -- Taille (cm) (champ individuel)
    zUI.Button("Taille (cm) :", nil, { RightLabel = heightOfSuspect or "~c~(vide)" }, function(sel)
        if not sel then return end
                    local playerPed = PlayerPedId()

            -- ❄️ Geler le joueur
            FreezeEntityPosition(playerPed, true)
            SetEntityInvincible(playerPed, true)

            -- ✅ Bloquer seulement les mouvements (conserve la caméra + ox_target)
            SetPlayerControl(PlayerId(), false, 2) -- 2 = désactive déplacement/sprint/saut, pas la caméra
        local n
        if lib and lib.inputDialog then
            local input = lib.inputDialog("Taille de l'individu (cm)", {
                { type = 'number', label = 'Taille (cm)', default = heightSuspect, required = true, min = 50, max = 250 }
            })
                    -- 🔓 Défreeze proprement
            FreezeEntityPosition(playerPed, false)
            SetEntityInvincible(playerPed, false)
            SetPlayerControl(PlayerId(), true, 0)
            n = input and tonumber(input[1])
        else
            n = NumberInput("Taille de l'individu (cm)", heightSuspect or "", 3)
        end

        if n then
            heightSuspect = n
            heightOfSuspect = "~g~" .. n
        else
            if ESX and ESX.ShowNotification then ESX.ShowNotification("Champ invalide") end
        end
    end)

    -- Nationalité (champ individuel)
    zUI.Button("Nationalité :", nil, { RightLabel = nationalityOfSuspect or "~c~(vide)" }, function(sel)
        if not sel then return end
                    local playerPed = PlayerPedId()

            -- ❄️ Geler le joueur
            FreezeEntityPosition(playerPed, true)
            SetEntityInvincible(playerPed, true)

            -- ✅ Bloquer seulement les mouvements (conserve la caméra + ox_target)
            SetPlayerControl(PlayerId(), false, 2) -- 2 = désactive déplacement/sprint/saut, pas la caméra
        local v
        if lib and lib.inputDialog then
            local input = lib.inputDialog("Nationalité de l'individu", {
                { type = 'input', label = 'Nationalité', default = nationalitySuspect or '', required = true, min = 2, max = 20 }
            })
                    -- 🔓 Défreeze proprement
            FreezeEntityPosition(playerPed, false)
            SetEntityInvincible(playerPed, false)
            SetPlayerControl(PlayerId(), true, 0)
            v = input and input[1]
        else
            v = TextInput("Nationalité de l'individu", nationalitySuspect or "", 20)
        end

        if v and v ~= "" then
            nationalitySuspect = v
            nationalityOfSuspect = "~g~" .. v
        else
            if ESX and ESX.ShowNotification then ESX.ShowNotification("Champ invalide") end
        end
    end)

    -- Sexe (champ individuel)
    zUI.Button("Sexe :", nil, { RightLabel = sexOfSuspect or "~c~(H/F)" }, function(sel)
        if not sel then return end
                    local playerPed = PlayerPedId()

            -- ❄️ Geler le joueur
            FreezeEntityPosition(playerPed, true)
            SetEntityInvincible(playerPed, true)

            -- ✅ Bloquer seulement les mouvements (conserve la caméra + ox_target)
            SetPlayerControl(PlayerId(), false, 2) -- 2 = désactive déplacement/sprint/saut, pas la caméra
        local v
        if lib and lib.inputDialog then
            local input = lib.inputDialog("Sexe de l'individu", {
                { type = 'select', label = 'Sexe', options = {
                        { label = 'Homme', value = 'H' },
                        { label = 'Femme', value = 'F' }
                    }, default = sexSuspect or 'H', required = true
                }
            })
                    -- 🔓 Défreeze proprement
            FreezeEntityPosition(playerPed, false)
            SetEntityInvincible(playerPed, false)
            SetPlayerControl(PlayerId(), true, 0)
            v = input and input[1]
        else
            v = TextInput("Sexe de l'individu (H/F)", sexSuspect or "", 1)
        end

        if v and v ~= "" then
            sexSuspect = v
            sexOfSuspect = "~g~" .. v
        else
            if ESX and ESX.ShowNotification then ESX.ShowNotification("Champ invalide") end
        end
    end)

    -- Validation
    local ready = (nameSuspect and ageSuspect and heightSuspect and nationalitySuspect and sexSuspect) ~= nil
    if ready then
        zUI.Button("✅ Valider", "Créer le casier", { RightLabel = "✔" }, function(sel)
            if not sel then return end
            TriggerServerEvent("tan:create", nameSuspect, ageSuspect, heightSuspect, nationalitySuspect, sexSuspect)
            if type(LoadListe) == "function" then LoadListe() end
            -- reset
            nameOfSuspect, ageOfSuspect, heightOfSuspect, nationalityOfSuspect, sexOfSuspect = nil, nil, nil, nil, nil
            nameSuspect, ageSuspect, heightSuspect, nationalitySuspect, sexSuspect = nil, nil, nil, nil, nil
        end)
    else
        zUI.Button("~m~Valider", "Tous les champs ne sont pas remplis", { RightLabel = "🔒", disabled = true }, function() end)
    end
end)


zUI.SetItems(ListMenu, function()
    zUI.Button(("Filtre : ~b~%s"):format(ItemsList[filterIndex] or "Aucun"), "Choisir une lettre", { RightLabel = "🔎" }, function(sel)
        if sel then  end
    end,FilterMenu)

    zUI.Separator("")
    local list = listeData or {}
    if filterIndex == 1 then
        for i=1, #list do
            local e = list[i]
            zUI.Button(e.name or "—", nil, { RightLabel = "→→" }, function(sel)
                if not sel then return end
                nameSelected        = e.name
                ageSelected         = e.age
                heightSelected      = e.height
                nationalitySelected = e.nationality
                sexSelected         = e.sex
                depositarySelected  = e.depositary
                dateSelected        = e.date
            end,InfoMenu)
        end
    else
        local letter = ItemsList[filterIndex]
        for i=1, #list do
            local e = list[i]
            if e.name and starts(e.name:lower(), letter:lower()) then
                zUI.Button(e.name, nil, { RightLabel = "→→" }, function(sel)
                    if not sel then return end
                    nameSelected        = e.name
                    ageSelected         = e.age
                    heightSelected      = e.height
                    nationalitySelected = e.nationality
                    sexSelected         = e.sex
                    depositarySelected  = e.depositary
                    dateSelected        = e.date
                end,InfoMenu)
            end
        end
    end
end)

zUI.SetItems(FilterMenu, function()
    for i=1, #ItemsList do
        local label = ItemsList[i]
        zUI.Button(label, nil, { RightLabel = (i==filterIndex) and "✓" or "" }, function(sel)
            if not sel then return end
            filterIndex = i
        end,ListMenu)
    end
end)

zUI.SetItems(InfoMenu, function()
    zUI.Button("Identité :",         nil, { RightLabel = nameSelected        or "—" }, function() end)
    zUI.Button("Âge :",              nil, { RightLabel = ageSelected         or "—" }, function() end)
    zUI.Button("Taille :",           nil, { RightLabel = heightSelected      or "—" }, function() end)
    zUI.Button("Nationalité :",      nil, { RightLabel = nationalitySelected or "—" }, function() end)
    zUI.Button("Sexe :",             nil, { RightLabel = sexSelected         or "—" }, function() end)
    zUI.Button("Auteur du casier :", nil, { RightLabel = depositarySelected  or "—" }, function() end)
    zUI.Button("Date :",             nil, { RightLabel = dateSelected        or "—" }, function() end)

    zUI.Separator("")
    zUI.Button("Voir le contenu du casier", nil, { RightLabel = "→→" }, function(sel)
        if not sel then return end
        TriggerServerEvent("actualCasier:selected", nameSelected)
        if type(LoadCasier) == "function" then LoadCasier() end
    end,ViewMenu)

    if ESX.PlayerData and ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'boss' then
        zUI.Button("🛑 Détruire le casier", "Action irréversible", { RightLabel = "⚠️" }, function(sel)
            if not sel then return end
            TriggerServerEvent("tan:deletecasier", nameSelected)
            TriggerServerEvent("delete:allmotif", nameSelected)
            Wait(100)
            if type(LoadListe) == "function" then LoadListe() end
        end,ListMenu)
    else
        zUI.Button("~m~Détruire le casier", "Option réservée au Commandant", { RightLabel = "🔒", disabled = true }, function() end)
    end
end)

zUI.SetItems(ViewMenu, function()
    zUI.Button("Individu :", nil, { RightLabel = nameSelected or "—" }, function() end)

    -- Toggle édition
    zUI.Button(("Mode édition : %s"):format(IsInEditMode and "~g~ON" or "~r~OFF"), "Activer/Désactiver", {}, function(sel)
        if sel then IsInEditMode = not IsInEditMode end
    end)

    if IsInEditMode then
        zUI.Button("Ajouter un motif", nil, { RightLabel = "➕" }, function(sel)
            if not sel then return end
            local motif = TextInput("Motif", "", 200)
            if motif and motif ~= "" then
                TriggerServerEvent("tan:addmotif", nameSelected, motif)
                Wait(100)
                if type(LoadCasier) == "function" then LoadCasier() end
            end
        end)
    end

    zUI.Separator("~b~Contenu du casier")

    local list = casierData or {}
    if not IsInEditMode then
        for i=1, #list do
            local e = list[i]
            zUI.Button(e.motif or "—", ("Rédigé par ~g~%s~s~ le ~g~%s~s~"):format(e.depositary or "?", e.date or "?"), {}, function() end)
        end
    else
        for i=1, #list do
            local e = list[i]
            zUI.Button(e.motif or "—", "Modifier ou supprimer", { RightLabel = "⚙️" }, function(sel)
                if not sel then return end
                selectedMotif = e.motif
            end,MotifMenu)
        end
    end
end)

zUI.SetItems(MotifMenu, function()
    zUI.Separator(selectedMotif or "—")
    zUI.Button("✏️ Modifier", nil, {}, function(sel)
        if not sel then return end
        local newMotif = TextInput("Nouveau motif", selectedMotif or "", 200)
        if newMotif and newMotif ~= "" then
            TriggerServerEvent("edit:motif", nameSelected, selectedMotif, newMotif)
            Wait(100)
            if type(LoadCasier) == "function" then LoadCasier() end
        end
    end,ViewMenu)
    zUI.Button("🗑️ Supprimer", "Cette action est irréversible", {}, function(sel)
        if not sel then return end
        TriggerServerEvent("delete:motif", nameSelected, selectedMotif)
        Wait(100)
        if type(LoadCasier) == "function" then LoadCasier() end
    end,ViewMenu)
end)

-- ========= Zone d’interaction (E) =========
-- ✅ Conversion "interaction E" -> ox_target zones
-- Requiert: ox_target (client) et que configuration.casier contienne des positions

CreateThread(function()
    local points = (configuration and configuration.casier) or {}
    if type(points) ~= "table" or #points == 0 then return end

    for i, v in ipairs(points) do
        -- Récupère/normalise les données
        local coords = v.pos or v.coords
        if coords and coords.x then coords = vec3(coords.x, coords.y, coords.z) end

        local size      = v.size and vec3(v.size.x, v.size.y, v.size.z) or vec3(1.5, 1.5, 2.0)
        local rotation  = v.heading or v.rotation or 0.0
        local debug     = v.debug == true
        local label     = v.label or "Ordinateur — Casier judiciaire"
        local icon      = v.icon or "fa-solid fa-computer"
        local distance  = v.distance or 2.0

        if coords then
            exports.ox_target:addBoxZone({
                coords = coords,
                size = size,
                rotation = rotation,
                debug = debug,
                options = {
                    {
                        label = label,
                        icon = icon,
                        distance = distance,
                        -- 🔒 Restriction par job ESX (grade >= 0)
                        groups = { police = 0 },
                        onSelect = function()
                            if type(LoadListe) == "function" then LoadListe() end
                            if type(OpenMenu) == "function" then OpenMenu() end
                        end
                    }
                }
            })
        end
    end
end)

