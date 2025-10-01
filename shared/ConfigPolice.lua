ConfigPolice = {}
-- Metez le webhook de votre salon disocrd configure pour le job ems 
-- ✅ Valeurs par défaut si non définies
ConfigPolice.JobPolice = "police"  -- Nom du job si besoin
ConfigPolice.CommandeMenu = "policemenu"  -- Commande pour ouvrir le menu
ConfigPolice.ToucheMenu = "F6"  -- Touche d'accès rapide
ConfigPolice.themes = "default"

ConfigPolice.Notifications = {
    ox_lib = false,         -- true pour utiliser ox_lib
    vms_notifyv2 = false,   -- true pour utiliser vms_notifyv2
    esx_notify = true       -- true pour utiliser ESX notifications natives
}

-- 📌 Webhook Discord
ConfigPolice.WebhookURL = "https://discord.com/api/webhooks/1341532384511918091/nSdgOq9HzY5-QH57PlQttka1JAe99a4hfVPdYZOWjpiMBckJ7LAthtX4wgQ0kDuZWd9c"

-- 📌 Nom affiché dans Discord
ConfigPolice.WebhookName = "📅 RDV Police"

-- 📌 Poste de police (interaction)
-- config.lua
ConfigPolice.PoliceStation = vector3(-813.08, -1232.75, 6.87)  
-- (vector3(...) marche aussi)


ConfigPolice.PoliceStations = {

	POLICE = {

		Blip = {
			Coords  = vec3(-813.08, -1232.75, 6.87),
			Sprite  = 60,
			Display = 4,
			Scale   = 0.5,
			Colour  = 29,
            Name    = "~g~Entreprise~s~ | LSPD"
		},
    }
}

--CriminalRecords

configuration = configuration or {}
configuration.casier = {
    { pos = vector3(439.634766,-979.566833,30.934891), size = vector3(1.8, 1.2, 2.0), heading = 0.0, label = "Ordinateur MRPD", debug = false },
    -- ajoute d'autres points si besoin...
    webhook = {
        ["createCasier"] = "",
        ["supprCasier"] = "", 
        ["addMotif"] = "", 
        ["supprMotif"] = "",
        ["editMotif"] = ""
    },
}

ConfigPolice.amende = {
    ["amende"] = {
        -- 🚦 Infractions routières légères
        {label = 'Usage abusif du klaxon', price = 100},
        {label = 'Franchir une ligne continue', price = 150},
        {label = 'Circulation à contresens', price = 250},
        {label = 'Demi-tour non autorisé', price = 200},
        {label = 'Circulation hors-route', price = 250},
        {label = 'Non-respect des distances de sécurité', price = 180},
        {label = 'Arrêt dangereux / interdit', price = 150},
        {label = 'Stationnement gênant / interdit', price = 100},

        -- 🚥 Priorités & feux
        {label = 'Non respect de la priorité à droite', price = 200},
        {label = 'Non-respect à un véhicule prioritaire', price = 300},
        {label = 'Non-respect d\'un stop', price = 250},
        {label = 'Non-respect d\'un feu rouge', price = 350},
        {label = 'Dépassement dangereux', price = 300},

        -- 🚗 Véhicule & permis
        {label = 'Véhicule non en état', price = 250},
        {label = 'Conduite sans permis', price = 1500},
        {label = 'Délit de fuite', price = 2000},


        -- 🚀 Excès de vitesse en ville
        {label = 'Ville - Excès de vitesse < 10 km/h', price = 100},
        {label = 'Ville - Excès de vitesse 10-20 km/h', price = 250},
        {label = 'Ville - Excès de vitesse 20-40 km/h', price = 600},
        {label = 'Ville - Excès de vitesse > 40 km/h', price = 1500},

        -- 🛣️ Excès de vitesse sur autoroute
        {label = 'Autoroute - Excès de vitesse < 10 km/h', price = 80},
        {label = 'Autoroute - Excès de vitesse 10-20 km/h', price = 200},
        {label = 'Autoroute - Excès de vitesse 20-40 km/h', price = 500},
        {label = 'Autoroute - Excès de vitesse > 40 km/h', price = 1200},
        {label = 'Autoroute - Excès de vitesse > 60 km/h', price = 2500},


        -- ⚖️ Divers
        {label = 'Entrave de la circulation', price = 400},
        {label = 'Dégradation de la voie publique', price = 600},
        {label = 'Trouble à l\'ordre publique', price = 800},
        {label = 'Entrave opération de police', price = 1500},
        {label = 'Insulte envers / entre civils', price = 200},
        {label = 'Outrage à agent de police', price = 800},
        {label = 'Menace verbale ou intimidation envers civil', price = 500},
        {label = 'Menace verbale ou intimidation envers policier', price = 1200},
        {label = 'Manifestation illégale', price = 1000},
        {label = 'Tentative de corruption', price = 5000},

        -- 🔫 Armes
        {label = 'Arme blanche sortie en ville', price = 1000},
        {label = 'Arme léthale sortie en ville', price = 2500},
        {label = 'Port d\'arme non autorisé (défaut de license)', price = 2000},
        {label = 'Port d\'arme illégal', price = 5000},

        -- 🚔 Criminalité
        {label = 'Pris en flag lockpick', price = 1500},
        {label = 'Vol de voiture', price = 2500},
        {label = 'Vente de drogue', price = 5000},
        {label = 'Fabrication de drogue', price = 8000},
        {label = 'Possession de drogue', price = 2500},
        {label = 'Prise d\'otage civil', price = 10000},
        {label = 'Prise d\'otage agent de l\'état', price = 15000},
        {label = 'Braquage particulier', price = 5000},
        {label = 'Braquage magasin', price = 10000},
        {label = 'Braquage de banque', price = 25000},

        -- 🔪 Violence
        {label = 'Tir sur civil', price = 7500},
        {label = 'Tir sur agent de l\'état', price = 10000},
        {label = 'Tentative de meurtre sur civil', price = 15000},
        {label = 'Tentative de meurtre sur agent de l\'état', price = 20000},
        {label = 'Meurtre sur civil', price = 25000},
        {label = 'Meurtre sur agent de l\'état', price = 30000},

        -- 💰 Fraude
        {label = 'Escroquerie à l\'entreprise', price = 4000},
    }
}


-- 📋 Props
ConfigPolice.Objects = {
    { label = "Sac",      model = "prop_big_bag_01" },
    { label = "Plot",     model = "prop_roadcone02a" },
    { label = "Barrière", model = "prop_barrier_work05" },
    { label = "Herse",    model = "p_ld_stinger_s" },
    { label = "Caisse",   model = "prop_boxpile_07d" },
}

-- 🧰 Liste des objets placés (stocke des NetIDs)
object = object or {}

-- Alias si ton ancien config utilise "weapon_rifle"
ConfigPolice.WeaponAliases = {
    weapon_rifle = 'weapon_carbinerifle'
}

-- Mappage arme → type de munition
ConfigPolice.AmmoTypeByWeapon = {
    weapon_pistol         = 'ammo-9',
    weapon_combatpistol   = 'ammo-9',
    weapon_smg            = 'ammo-9',
    weapon_carbinerifle   = 'ammo-rifle',
    weapon_assaultrifle   = 'ammo-rifle',
    weapon_pumpshotgun    = 'ammo-shotgun',
    weapon_assaultshotgun = 'ammo-shotgun',
}

-- Marque l’équipement donné par l’armurerie
function ConfigPolice.BuildAmmoMetadata(src)
    return { issued = true } -- ajoute dept='LSPD' si tu veux
end
function ConfigPolice.BuildWeaponMetadata(src)
    return { issued = true }
end

-- Équipements par grade (⚠️ remplace weapon_rifle par weapon_carbinerifle)
ConfigPolice.EquipmentByGrade = {
    [0] = {
        label = "Recrue",
        items = {
            { name = 'weapon_flashlight', count = 1, metadata = { issued = true } },
            { name = 'weapon_stungun',    count = 1, metadata = { issued = true } },
            { name = 'weapon_nightstick', count = 1, metadata = { issued = true } },
        }
    },
    [1] = {
        label = "Officier",
        items = {
            { name = 'weapon_pistol',     count = 1, metadata = { issued = true } },
            { name = 'weapon_stungun',    count = 1, metadata = { issued = true } },
            { name = 'weapon_nightstick', count = 1, metadata = { issued = true } },
            { name = 'weapon_flashlight', count = 1, metadata = { issued = true } },
            { name = 'ammo-9',            count = 42, metadata = { issued = true } },
        }
    },
    [2] = {
        label = "Sergent",
        items = {
            { name = 'weapon_pistol',       count = 1, metadata = { issued = true } },
            { name = 'weapon_flashlight',   count = 1, metadata = { issued = true } },
            { name = 'weapon_nightstick',   count = 1, metadata = { issued = true } },
            { name = 'weapon_stungun',      count = 1, metadata = { issued = true } },
            { name = 'ammo-9',              count = 100, metadata = { issued = true } },
            { name = 'weapon_carbinerifle', count = 1, metadata = { issued = true } },
        }
    },
    [3] = {
        label = "Lieutenant",
        items = {
            { name = 'weapon_pistol',         count = 1, metadata = { issued = true } },
            { name = 'weapon_flashlight',     count = 1, metadata = { issued = true } },
            { name = 'weapon_nightstick',     count = 1, metadata = { issued = true } },
            { name = 'weapon_stungun',        count = 1, metadata = { issued = true } },
            { name = 'ammo-9',                count = 120, metadata = { issued = true } },
            { name = 'weapon_carbinerifle',   count = 1, metadata = { issued = true } },
            { name = 'weapon_assaultshotgun', count = 1, metadata = { issued = true } },
        }
    },
    [4] = {
        label = "Boss",
        items = {
            { name = 'weapon_pistol',         count = 1, metadata = { issued = true } },
            { name = 'weapon_flashlight',     count = 1, metadata = { issued = true } },
            { name = 'weapon_nightstick',     count = 1, metadata = { issued = true } },
            { name = 'ammo-9',                count = 120, metadata = { issued = true } },
            { name = 'weapon_carbinerifle',   count = 1, metadata = { issued = true } },
            { name = 'weapon_assaultshotgun', count = 1, metadata = { issued = true } },
        }
    }
}

-- Armes à retirer (on cible d’abord les armes de service via metadata)
ConfigPolice.WeaponsToRemove = {
    { item = 'weapon_nightstick',     metadata = { issued = true } },
    { item = 'weapon_stungun',        metadata = { issued = true } },
    { item = 'weapon_pistol',         metadata = { issued = true } },
    { item = 'weapon_carbinerifle',   metadata = { issued = true } },
    { item = 'weapon_pumpshotgun',    metadata = { issued = true } },
    { item = 'weapon_smg',            metadata = { issued = true } },
    { item = 'weapon_flashlight',     metadata = { issued = true } },
    { item = 'weapon_assaultshotgun', metadata = { issued = true } },
    { item = 'weapon_assaultrifle',   metadata = { issued = true } }, -- si tu l’utilises
}

-- Munitions à retirer (priorité : piles issued → piles neutres)
ConfigPolice.AmmoToRemove = {
    { item = 'ammo-9',      count = 120, filters = { { issued = true }, {} } },
    { item = 'ammo-rifle',  count = 120, filters = { { issued = true }, {} } },
    { item = 'ammo-shotgun',count = 40,  filters = { { issued = true }, {} } },
}


-- Événements associés à l'armurerie
ConfigPolice.ArmoryEvent = 'armorypolice:giveEquipment' -- L'événement pour donner l'équipement
ConfigPolice.RemoveItemEvent = 'RemoveItem' -- L'événement pour retirer les armes et munitions
-- Configuration des jobs requis pour accéder à l'armurerie
ConfigPolice.JobRequired = 'police'  -- Par exemple, seulement les policiers peuvent accéder
-- Zone de l'armurerie (coordonnées et autres paramètres)
ConfigPolice.Armurerie = {
    coords = vector3(-785.764709,-1218.676147,7.449883),  -- Exemple de coordonnées pour l'armurerie
    size = vector3(1, 1, 2),
    rotation = 0,
    Armory = {
        name = 'armurerie_police',
        icon = 'fa-solid fa-gun',
        label = 'Ouvrir l\'Armurerie',
        distance = 2.0
    }
}
--############################
--########### Boss ##########
--############################
ConfigPolice.Boss = {
    PoliceBoss = {
        coords = vector3(447.188812,-974.053711,30.471796),
        size = vector3(2.0, 2.0, 2.0),
        society = 'police',
        bossMenu = {
            name = "open_bossmenu",
            icon = 'fa-solid fa-building',
            label = "Menu patron police",
            requiredGrade = 4,  -- Grade minimum requis pour interagir
            distance = 2.5
        }
    }
}

-- === Déclaration des stashes (IDs uniques) ===
ConfigPolice.Stashes = {
    Principal = {
        id     = 'police_principal',           -- ⚠️ ID unique
        label  = 'Coffre Principal - Police',
        slots  = 150,
        weight = 100000,
        owner  = false
    },
    Saisies = {
        id     = 'police_saisies',             -- ⚠️ ID unique différent
        label  = 'Coffre Saisies - Police',
        slots  = 250,
        weight = 150000,
        owner  = false
    }
}

-- === Zones d’interaction ===
ConfigPolice.Coffre = {
    PoliceCoffre = {
        coords      = vec3(-800.430115,-1212.892090,10.684449),
        size        = vec3(1, 1, 1),
        rotation    = 0.0,
        label       = "Ouvrir le coffre (Principal)",
        icon        = "fas fa-box-open",
        jobRequired = 'police',
        stashId     = ConfigPolice.Stashes.Principal.id, -- OK
        distance    = 2.0
    },
}

ConfigPolice.Saisies = {
    PoliceSaisies = {
        coords      = vec3(-790.805969,-1225.291016,7.204212),
        size        = vec3(1, 1, 1),
        rotation    = 0.0,
        label       = "Ouvrir le coffre de Saisies",
        icon        = "fas fa-box-open",
        jobRequired = 'police',
        stashId     = ConfigPolice.Stashes.Saisies.id,   -- ✅ Corrigé : pointer vers le stash Saisies
        distance    = 2.0
    },
}


-- Coffres fixes existants (Principal / Saisies)
ConfigPolice.Stashes = ConfigPolice.Stashes or {
    Principal = { id = 'police_principal', label = 'Coffre Principal - Police', slots = 150, weight = 100000, owner = false },
    Saisies   = { id = 'police_saisies',   label = 'Coffre Saisies - Police',   slots = 250, weight = 150000, owner = false },
}

-- Paramètres du système Evidence dynamique
ConfigPolice.Evidence = {
    job       = 'police',
    minGrade  = 0,            -- grade minimum (0 = tous les policiers)
    slots     = 80,
    weight    = 60000,
    webhook   = "https://discord.com/api/webhooks/1341532384511918091/nSdgOq9HzY5-QH57PlQttka1JAe99a4hfVPdYZOWjpiMBckJ7LAthtX4wgQ0kDuZWd9c",           -- URL Discord (optionnel). Laisse vide pour désactiver
    persistFile = "evidence.json",  -- nom du fichier persistant dans la ressource
    zone = {                  -- Une zone unique “Salle des preuves”
        coords   = vec3(-788.792664,-1221.544556,7.368668),
        size     = vec3(1,1,1),
        rotation = 0.0,
        distance = 2.0,
        icon     = "fas fa-box-archive",
        labelCreate = "Créer un coffre de saisie",
        labelBrowse = "Ouvrir les coffres de saisies"
    }
}

-- Tenues disponibles dans le vestiaire
--Vestiaire 
ConfigPolice.VestiaireCoords = vector3(-781.777283,-1212.728271,10.684095) -- Coordonnées du vestiaire
ConfigPolice.JobRequired = "police"  -- Job requis pour accéder au vestiaire
PoliceCloak = {
	clothes = {
        specials = {
            [0] = {
                label = "Tenue Civil",
                minimum_grade = 0,
                variations = {male = {}, female = {}},
                onEquip = function()
                    if not ESX then
                        ESX = exports["es_extended"]:getSharedObject()
                        if not ESX then
                            return
                        end
                    end
                
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                        TriggerEvent('skinchanger:loadSkin', skin)
                        SetPedArmour(PlayerPedId(), 0)
                    end)
                
                
                    SetPedArmour(PlayerPedId(), 0)
                end
            },

        },
         grades = {
            [0] = {
                label = "Tenue Recruit",
                minimum_grade = 0,
                variations = {
                    male = {
                        tshirt_1 = 58,  tshirt_2 = 0,
                        torso_1  = 55,  torso_2  = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms     = 41,
                        pants_1  = 35,  pants_2  = 0,
                        shoes_1  = 25,  shoes_2  = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1  = 0,   chain_2  = 0,
                        bproof_1 = 13,  bproof_2 = 1,
                        mask_1   = 0,   mask_2   = 0,
                        bags_1   = 0,   bags_2   = 0,
                        ears_1   = -1,  ears_2   = 0,
                        glasses_1 = 0,  glasses_2 = 0
                    },
                    female = {
                        tshirt_1 = 35,  tshirt_2 = 0,
                        torso_1  = 48,  torso_2  = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms     = 44,
                        pants_1  = 34,  pants_2  = 0,
                        shoes_1  = 27,  shoes_2  = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1  = 0,   chain_2  = 0,
                        bproof_1 = 13,  bproof_2 = 1,
                        mask_1   = 0,   mask_2   = 0,
                        bags_1   = 0,   bags_2   = 0,
                        ears_1   = -1,  ears_2   = 0,
                        glasses_1 = 5,  glasses_2 = 0
                    }
                },
                onEquip = function() end
            },

            [1] = {
                label = "Tenue Officer",
                minimum_grade = 1,
                variations = {
                    male = {
                        tshirt_1 = 58,  tshirt_2 = 0,
                        torso_1  = 55,  torso_2  = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms     = 41,
                        pants_1  = 35,  pants_2  = 0,
                        shoes_1  = 25,  shoes_2  = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1  = 0,   chain_2  = 0,
                        bproof_1 = 13,  bproof_2 = 1,
                        mask_1   = 0,   mask_2   = 0,
                        bags_1   = 0,   bags_2   = 0,
                        ears_1   = -1,  ears_2   = 0,
                        glasses_1 = 0,  glasses_2 = 0
                    },
                    female = {
                        tshirt_1 = 35,  tshirt_2 = 0,
                        torso_1  = 48,  torso_2  = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms     = 44,
                        pants_1  = 34,  pants_2  = 0,
                        shoes_1  = 27,  shoes_2  = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1  = 0,   chain_2  = 0,
                        bproof_1 = 13,  bproof_2 = 1,
                        mask_1   = 0,   mask_2   = 0,
                        bags_1   = 0,   bags_2   = 0,
                        ears_1   = -1,  ears_2   = 0,
                        glasses_1 = 5,  glasses_2 = 0
                    }
                },
                onEquip = function() end
            },

            [2] = {
                label = "Tenue Sergeant",
                minimum_grade = 2,
                variations = {
                    male = {
                        tshirt_1 = 58,  tshirt_2 = 0,
                        torso_1  = 55,  torso_2  = 0,
                        decals_1 = 0,   decals_2 = 0, -- insigne
                        arms     = 41,
                        pants_1  = 35,  pants_2  = 0,
                        shoes_1  = 25,  shoes_2  = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1  = 0,   chain_2  = 0,
                        bproof_1 = 13,  bproof_2 = 1,
                        mask_1   = 0,   mask_2   = 0,
                        bags_1   = 0,   bags_2   = 0,
                        ears_1   = -1,  ears_2   = 0,
                        glasses_1 = 0,  glasses_2 = 0
                    },
                    female = {
                        tshirt_1 = 35,  tshirt_2 = 0,
                        torso_1  = 48,  torso_2  = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms     = 44,
                        pants_1  = 34,  pants_2  = 0,
                        shoes_1  = 27,  shoes_2  = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1  = 0,   chain_2  = 0,
                        bproof_1 = 13,  bproof_2 = 1,
                        mask_1   = 0,   mask_2   = 0,
                        bags_1   = 0,   bags_2   = 0,
                        ears_1   = -1,  ears_2   = 0,
                        glasses_1 = 5,  glasses_2 = 0
                    }
                },
                onEquip = function() end
            },

            [3] = {
                label = "Tenue Lieutenant",
                minimum_grade = 3,
                variations = {
                    male = {
                        tshirt_1 = 58,  tshirt_2 = 0,
                        torso_1  = 55,  torso_2  = 0,
                        decals_1 = 0,  decals_2 = 0, -- autre insigne
                        arms     = 41,
                        pants_1  = 35,  pants_2  = 0,
                        shoes_1  = 25,  shoes_2  = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1  = 0,   chain_2  = 0,
                        bproof_1 = 13,  bproof_2 = 1,
                        mask_1   = 0,   mask_2   = 0,
                        bags_1   = 0,   bags_2   = 0,
                        ears_1   = -1,  ears_2   = 0,
                        glasses_1 = 0,  glasses_2 = 0
                    },
                    female = {
                        tshirt_1 = 35,  tshirt_2 = 0,
                        torso_1  = 48,  torso_2  = 0,
                        decals_1 = 0,  decals_2 = 0,
                        arms     = 44,
                        pants_1  = 34,  pants_2  = 0,
                        shoes_1  = 27,  shoes_2  = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1  = 0,   chain_2  = 0,
                        bproof_1 = 13,  bproof_2 = 1,
                        mask_1   = 0,   mask_2   = 0,
                        bags_1   = 0,   bags_2   = 0,
                        ears_1   = -1,  ears_2   = 0,
                        glasses_1 = 5,  glasses_2 = 0
                    }
                },
                onEquip = function() end
            },

            [4] = {
                label = "Tenue Boss",
                minimum_grade = 4,
                variations = {
                    male = {
                        tshirt_1 = 58,  tshirt_2 = 0,
                        torso_1  = 55,  torso_2  = 0,
                        decals_1 = 0,  decals_2 = 0, -- chef
                        arms     = 41,
                        pants_1  = 35,  pants_2  = 0,
                        shoes_1  = 25,  shoes_2  = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1  = 0,   chain_2  = 0,
                        bproof_1 = 13,  bproof_2 = 1,
                        mask_1   = 0,   mask_2   = 0,
                        bags_1   = 0,   bags_2   = 0,
                        ears_1   = -1,  ears_2   = 0,
                        glasses_1 = 0,  glasses_2 = 0
                    },
                    female = {
                        tshirt_1 = 35,  tshirt_2 = 0,
                        torso_1  = 48,  torso_2  = 0,
                        decals_1 = 0,  decals_2 = 0,
                        arms     = 44,
                        pants_1  = 34,  pants_2  = 0,
                        shoes_1  = 27,  shoes_2  = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1  = 0,   chain_2  = 0,
                        bproof_1 = 13,  bproof_2 = 1,
                        mask_1   = 0,   mask_2   = 0,
                        bags_1   = 0,   bags_2   = 0,
                        ears_1   = -1,  ears_2   = 0,
                        glasses_1 = 5,  glasses_2 = 0
                    }
                },
                onEquip = function() end
            },
        },
    }
}

--############################
--########### Garage #########
--############################
-- ConfigPolice.pos = {
--     spawnPoliceVehicle = {
--         position =  vector4(450.86, -1016.24, 28.15, 91.66)  -- Position de spawn du véhicule avec heading
--     }
-- }
-- ConfigPolice.Garage = {
--     PoliceGarage = {
--         coords = vector3(459.164398,-1008.063599,28.635828), -- Coordonnées du garage
--         size = vector3(3.0, 3.0, 3.0),
--         garageMenu = {
--             name = "police_garage",
--             icon = "fa-solid fa-car",
--             label = "Ouvrir le Garage police",
--             distance = 2.0
--         }
--     }
-- }

-- ConfigPolice.Ranger = {
--     PoliceRanger = {
--         coords = vector3( vector3(462.17, -1014.85, 27.74) ),  -- Exemple de coordonnées du garage
--         size = vector3(3.0, 3.0, 3.0),  -- Taille de la zone d'interaction
--         distance = 5.0,  -- Distance à partir de laquelle le joueur peut interagir
--         key = 38,  -- Touche E pour ranger (38 correspond à la touche E)
--     },
-- }
-- ConfigPolice.AuthorizedPoliceVehicles = {
--     {
--         label = "Vapid Police Cruiser",
--         model = "police",
--         image = "https://wiki.rage.mp/images/thumb/5/52/Police.png/164px-Police.png"
--     },
--     {
--         label = "Vapid Police Cruiser (Old)",
--         model = "police2",
--         image = "https://wiki.rage.mp/images/thumb/2/28/Police2.png/164px-Police2.png"
--     },
--     {
--         label = "Declasse Sheriff Cruiser",
--         model = "sheriff",
--         image = "https://wiki.rage.mp/images/thumb/6/68/Sheriff.png/164px-Sheriff.png"
--     },
--     {
--         label = "Declasse Sheriff SUV",
--         model = "sheriff2",
--         image = "https://wiki.rage.mp/images/thumb/c/c4/Sheriff2.png/164px-Sheriff2.png"
--     },
--     {
--         label = "Bravado Police Buffalo",
--         model = "police3",
--         image = "https://wiki.rage.mp/images/thumb/d/d5/Police3.png/164px-Police3.png"
--     },
--     {
--         label = "Vapid Police Stanier (Highway)",
--         model = "police4",
--         image = "https://wiki.rage.mp/images/thumb/4/4d/Police4.png/164px-Police4.png"
--     },
--     {
--         label = "Police Transport Van",
--         model = "policet",
--         image = "https://wiki.rage.mp/images/thumb/5/57/Policet.png/164px-Policet.png"
--     },
--     {
--         label = "Unmarked Cruiser",
--         model = "fbi",
--         image = "https://wiki.rage.mp/images/thumb/4/41/Fbi.png/164px-Fbi.png"
--     },
--     {
--         label = "Unmarked SUV",
--         model = "fbi2",
--         image = "https://wiki.rage.mp/images/thumb/6/69/Fbi2.png/164px-Fbi2.png"
--     },
--     {
--         label = "Police Riot",
--         model = "riot",
--         image = "https://wiki.rage.mp/images/thumb/3/33/Riot.png/164px-Riot.png"
--     },
--     {
--         label = "Police Motorcycle",
--         model = "policeb",
--         image = "https://wiki.rage.mp/images/thumb/2/2f/Policeb.png/164px-Policeb.png"
--     },
--     {
--         label = "Police Predator (Bateau)",
--         model = "predator",
--         image = "https://wiki.rage.mp/images/thumb/3/38/Predator.png/164px-Predator.png"
--     }
-- }

--############################
--########### ped #########
--############################
ConfigPolice.NPCs = {
    {
        model = "s_m_y_cop_01",
        coords =  vector4(454.05, -979.96, 30.69, 90.34),
        freeze = true,
        invincible = true,
        text = "👋 Ouvrir l\'Armurerie"
    },
        {
        model = "s_m_y_cop_01",
        coords =   vec4(-814.03, -1233.44, 6.87, 316.88) ,
        freeze = true,
        invincible = true,
        text = "👋 Ouvrir l\'RDV"
    },

}
