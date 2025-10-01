-- ==========================
-- VESTIAIRE POLICE (zUI-v2 + anti CPed::SetVariation)
-- ==========================

local zUI = exports["zUI-v2"]:getObject()
local ESX = exports["es_extended"]:getSharedObject()

-- Sync ESX.PlayerData
RegisterNetEvent('esx:playerLoaded', function(playerData)
    ESX.PlayerData = playerData
end)

RegisterNetEvent("esx:setJob", function(job)
    ESX.PlayerData = ESX.PlayerData or {}
    ESX.PlayerData.job = job
end)

-- Menu unique
local vestiaireMenu = zUI.CreateMenu("👮 VESTIAIRE POLICE", "", "Vestiaire", ConfigPolice.themes)

-- ==========================
-- Helpers (grades/tri)
-- ==========================

local function getPlayerGrade()
    local pdata = ESX.PlayerData
    if not pdata or not pdata.job then
        pdata = ESX.GetPlayerData()
        ESX.PlayerData = pdata
    end
    local job = pdata and pdata.job
    return (job and (job.grade or job.grade_level)) or 0
end

local function sortedByGrade(gradesTbl)
    local arr = {}
    if type(gradesTbl) ~= "table" then return arr end
    for key, infos in pairs(gradesTbl) do
        local gnum = tonumber(key) or tonumber(infos.minimum_grade or infos.grade or 0) or 0
        table.insert(arr, { grade = gnum, data = infos })
    end
    table.sort(arr, function(a, b) return a.grade < b.grade end)
    return arr
end

-- ==========================
-- Helpers (anti CPed::SetVariation)
-- ==========================

-- Components (SetPedComponentVariation)
local COMPONENT_SLOTS = {
  mask_1=1, mask_2=1, hair_1=2, hair_2=2, arms=3,
  pants_1=4, pants_2=4, bags_1=5, bags_2=5, shoes_1=6, shoes_2=6,
  chain_1=7, chain_2=7, tshirt_1=8, tshirt_2=8,
  bproof_1=9, bproof_2=9,      -- gilet pare-balles
  decals_1=10, decals_2=10, torso_1=11, torso_2=11,
}

-- Props (SetPedPropIndex / ClearPedProp)
-- 0:hats 1:glasses 2:ears 6:watches 7:bracelets
local PROP_SLOTS = {
  helmet_1=0, helmet_2=0,
  glasses_1=1, glasses_2=1,
  ears_1=2, ears_2=2,
  watches_1=6, watches_2=6,
  bracelets_1=7, bracelets_2=7,
}

local function clamp(v, lo, hi)
    if v < lo then return lo elseif v > hi then return hi else return v end
end

local function sanitizeOutfit(ped, outfit)
    if type(outfit) ~= "table" then return {} end
    local safe = {}

    -- Components (drawable/texture)
    for k,v in pairs(outfit) do
        local slot = COMPONENT_SLOTS[k]
        if slot then
            if k:sub(-2) == "_1" then
                local draw = tonumber(v) or 0
                local maxDraw = GetNumberOfPedDrawableVariations(ped, slot)
                draw = clamp(draw, 0, math.max(0, maxDraw - 1))
                safe[k] = draw

                local texKey = k:gsub("_1","_2")
                local tex = tonumber(outfit[texKey] or 0) or 0
                local maxTex = GetNumberOfPedTextureVariations(ped, slot, draw)
                tex = clamp(tex, 0, math.max(0, maxTex - 1))
                safe[texKey] = tex
            elseif k == "arms" then
                local maxDraw = GetNumberOfPedDrawableVariations(ped, 3)
                safe.arms = clamp(tonumber(v) or 0, 0, math.max(0, maxDraw - 1))
            end
        end
    end

    -- Props
    for k,v in pairs(outfit) do
        local slot = PROP_SLOTS[k]
        if slot and k:sub(-2) == "_1" then
            local draw = tonumber(v) or -1
            if draw < 0 then
                safe[k] = -1
                safe[k:gsub("_1","_2")] = 0
            else
                local maxDraw = GetNumberOfPedPropDrawableVariations(ped, slot)
                draw = clamp(draw, 0, math.max(0, maxDraw - 1))
                safe[k] = draw

                local texKey = k:gsub("_1","_2")
                local tex = tonumber(outfit[texKey] or 0) or 0
                local maxTex = GetNumberOfPedPropTextureVariations(ped, slot, draw)
                tex = clamp(tex, 0, math.max(0, maxTex - 1))
                safe[texKey] = tex
            end
        end
    end

    -- Sécurité supplémentaire pour le gilet (slot 9)
    if safe.bproof_1 and safe.bproof_1 > 0 then
        local maxDraw = GetNumberOfPedDrawableVariations(ped, 9)
        if maxDraw == 0 then
            safe.bproof_1, safe.bproof_2 = 0, 0
        else
            local maxTex = GetNumberOfPedTextureVariations(ped, 9, safe.bproof_1)
            if maxTex == 0 or safe.bproof_2 >= maxTex then safe.bproof_2 = 0 end
        end
    end

    return safe
end

local function isFreemodePed(ped)
    local m = GetEntityModel(ped)
    return m == GetHashKey('mp_m_freemode_01') or m == GetHashKey('mp_f_freemode_01')
end

-- ==========================
-- Application tenue (safe)
-- ==========================

local function applySkinSpecific(outfit)
    if not outfit then return end

    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        if not skin then
            ESX.ShowNotification("Skin introuvable.")
            return
        end

        -- Support male/female OU variations.male/female
        local isMale  = (skin.sex == 0)
        local male    = outfit.male or (outfit.variations and outfit.variations.male)
        local female  = outfit.female or (outfit.variations and outfit.variations.female)
        local target  = isMale and male or female

        -- Si pas de variations (ex: Tenue Civil) -> onEquip direct
        if not target or next(target) == nil then
            if type(outfit.onEquip) == "function" then pcall(outfit.onEquip) end
            return
        end

        local ped = PlayerPedId()
        if not isFreemodePed(ped) then
            ESX.ShowNotification("Ped non compatible. Utilisez un ped MP (freemode).")
            return
        end

        local safe = sanitizeOutfit(ped, target)
        TriggerEvent('skinchanger:loadClothes', skin, safe)

        if outfit.label then
            ESX.ShowNotification(("Tenue appliquée : %s"):format(outfit.label))
        end

        if type(outfit.onEquip) == "function" then pcall(outfit.onEquip) end
    end)
end

-- ==========================
-- ITEMS DU MENU
-- ==========================

zUI.SetItems(vestiaireMenu, function()
    local grade = getPlayerGrade()

    local clothes   = (PoliceCloak and PoliceCloak.clothes) or {}
    local specials  = clothes.specials or {}
    local gradesTbl = clothes.grades or {}

    -- Spéciales
    zUI.Separator("Tenues spéciales")
    local anySpecial = false
    -- ⚠️ specials peut être indexé à partir de 0 -> pairs pour ne rien rater
    for _, infos in pairs(specials) do
        local minGrade = tonumber(infos.minimum_grade or 0) or 0
        if grade >= minGrade then
            anySpecial = true
            zUI.Button(infos.label or "Tenue spéciale", nil, {}, function(onSelected)
                if not onSelected then return end
                applySkinSpecific(infos)
            end)
        end
    end
    if not anySpecial then
        zUI.Separator("Aucune tenue spéciale disponible pour votre grade.")
    end

    -- Par grade
    zUI.Separator("Tenues par grade")
    local anyGrade = false
    local sorted = sortedByGrade(gradesTbl)
    for _, entry in ipairs(sorted) do
        local gnum  = entry.grade
        local infos = entry.data
        if grade >= gnum then
            anyGrade = true
            local label = infos.label or ("Tenue grade "..tostring(gnum))
            zUI.Button(label, nil, {}, function(onSelected)
                if not onSelected then return end
                applySkinSpecific(infos)
            end)
        end
    end
    if not anyGrade then
        zUI.Separator("Aucune tenue de grade disponible.")
    end
end)

-- ==========================
-- ox_target
-- ==========================

exports.ox_target:addBoxZone({
    coords   = ConfigPolice.VestiaireCoords,  -- vec3
    size     = vector3(1, 1, 2),
    rotation = 0,
    debug    = false,
    options  = {
        {
            name     = "vestiaire",
            icon     = "fa-solid fa-tshirt",
            label    = "Accéder au vestiaire",
            distance = 2.0,
            onSelect = function()
                local pdata = ESX.PlayerData or ESX.GetPlayerData()
                if pdata and pdata.job and pdata.job.name == (ConfigPolice.JobRequired) then
                    OpenMenuVestiaire()
                else
                    ESX.ShowNotification("Accès refusé.")
                end
            end,
        }
    }
})

-- ==========================
-- Toggle Menu
-- ==========================

function OpenMenuVestiaire()
    zUI.SetVisible(vestiaireMenu, not zUI.IsVisible(vestiaireMenu))
end
