-- Script RDV Police
-- Développé avec Click&Build

-- Util : force en vec3 si la valeur vient d'une table
local function ensureVec3(v)
    if type(v) == 'vector3' then return v end
    if type(v) == 'table' then
        return vec3(v.x or v[1], v.y or v[2], v.z or v[3])
    end
    -- fallback si jamais c'est nil
    return vec3(0.0, 0.0, 0.0)
end

local policeStation = ensureVec3(ConfigPolice.PoliceStation) -- Position du commissariat MRPD
local textShown = false

-- Boucle pour afficher le marker et permettre l'interaction
CreateThread(function()
    while true do
        local wait = 1000
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = #(pos - policeStation) -- OK car policeStation est bien un vec3

        if dist < 10.0 then
            wait = 0

           

            if dist < 2.0 then
                if not textShown then
                    lib.showTextUI('[E] - 📅 Rendez-vous Police')
                    textShown = true
                end

                if IsControlJustReleased(0, 38) then -- E
                    OpenRdvMenu()
                end
            else
                if textShown then
                    lib.hideTextUI()
                    textShown = false
                end
            end
        else
            if textShown then
                lib.hideTextUI()
                textShown = false
            end
        end

        Wait(wait)
    end
end)

-- Nettoyage si la ressource s'arrête
AddEventHandler('onResourceStop', function(resName)
    if resName == GetCurrentResourceName() and textShown then
        lib.hideTextUI()
        textShown = false
    end
end)

-- Fonction d’ouverture du menu
function OpenRdvMenu()
    local input = lib.inputDialog("📅 Rendez-vous Police", {
        { type = "input", label = "Motif du rendez-vous", placeholder = "Plainte, audition, etc." },
        { type = "input", label = "Heure souhaitée", placeholder = "Exemple : 18h30" }
    })

    if input then
        TriggerServerEvent("rdv:sendToPolice", input[1], input[2])
        ESX.ShowNotification("✅ Votre demande de rendez-vous a été transmise à la police.")
        if textShown then
            lib.hideTextUI()
            textShown = false
        end
    end
end
