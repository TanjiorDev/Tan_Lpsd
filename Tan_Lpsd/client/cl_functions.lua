-- ========= INPUTS via ox_lib (fallback natif si ox_lib absent) =========

-- Remplace directement ta fonction existante :
function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    if lib and lib.inputDialog then
        local input = lib.inputDialog(TextEntry or 'Saisie', {
            { type = 'input', label = TextEntry or 'Texte', default = ExampleText or '' }
        })
        if not input then return nil end
        local v = input[1]
        if v == '' then return nil end
        return v
    end

    -- Fallback natif (ton ancien code)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry or 'Saisir…')
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText or "", "", "", "", MaxStringLenght or 60)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do Wait(0) end
    if UpdateOnscreenKeyboard() == 1 then
        return GetOnscreenKeyboardResult()
    end
    return nil
end

-- Helpers pratiques (facultatifs) :

function OxInputText(title, label, default)
    if lib and lib.inputDialog then
        local input = lib.inputDialog(title or 'Saisie', {
            { type='input', label=label or 'Texte', default=default or '' }
        })
        return (input and input[1] ~= '' and input[1]) or nil
    else
        return KeyboardInput(label or title or 'Saisir…', default or '', 60)
    end
end

function OxInputNumber(title, label, default)
    if lib and lib.inputDialog then
        local input = lib.inputDialog(title or 'Nombre', {
            { type='number', label=label or 'Valeur', default=default or 0 }
        })
        return (input and tonumber(input[1])) or nil
    else
        local v = KeyboardInput(label or title or 'Nombre', tostring(default or ''), 10)
        return v and tonumber(v) or nil
    end
end

-- Select (liste déroulante)
-- options = { {label='Option A', value='a'}, {label='Option B', value='b'} }
function OxSelect(title, label, options, defaultValue)
    options = options or {}
    if lib and lib.inputDialog then
        local input = lib.inputDialog(title or 'Sélection', {
            { type='select', label=label or 'Choisir', options=options, default=defaultValue }
        })
        return input and input[1] or nil
    else
        -- fallback simple: retourne nil (ou fais un KeyboardInput si tu veux)
        return nil
    end
end

-- Couleur (RGB) → renvoie r,g,b
function OxInputColorRGB(title, label, defaultRgbString)
    if lib and lib.inputDialog then
        local input = lib.inputDialog(title or 'Couleur', {
            { type='color', label=label or 'Couleur', format='rgb', default=defaultRgbString or 'rgb(255,255,255)' }
        })
        if not input then return nil end
        local c = input[1] or 'rgb(255,255,255)'
        local r, g, b = string.match(c, "rgb%((%d+),%s*(%d+),%s*(%d+)%)")
        return tonumber(r), tonumber(g), tonumber(b)
    else
        -- fallback: 3 inputs natifs
        local r = OxInputNumber('Couleur', 'Rouge (0-255)', 255); if not r then return nil end
        local g = OxInputNumber('Couleur', 'Vert (0-255)', 255);  if not g then return nil end
        local b = OxInputNumber('Couleur', 'Bleu (0-255)', 255);  if not b then return nil end
        return math.max(0,math.min(255,r)), math.max(0,math.min(255,g)), math.max(0,math.min(255,b))
    end
end

function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

listeData = {}
function LoadListe()
    ESX.TriggerServerCallback("tan:getList", function(data)
        listeData = data
    end)
end

casierData = {}
function LoadCasier()
    ESX.TriggerServerCallback("tan:getCasier", function(data)
        casierData = data
    end)
end
