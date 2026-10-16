--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests de la configuration et des textes : valeurs seules (C-H1), seuils
-- cohérents et traduction sans toucher au code.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local EDICT_ENGINE_LIMIT = 8192
local ALLOWED = { number = true, boolean = true, table = true }

--- sh_config ne contient que des valeurs, aucune fonction (C-H1).
local function test_config_values()
    for key, value in pairs(Ballast.config) do
        Check.truthy(ALLOWED[type(value)], "type de " .. key)
    end
end

Check.case("configuration sans logique", test_config_values)

--- Les seuils restent cohérents entre eux et avec le moteur.
local function test_config_limits()
    local config = Ballast.config

    Check.truthy(config.edict_limit < EDICT_ENGINE_LIMIT, "edicts")
    Check.truthy(config.job_budget < engine.TickInterval(), "budget")
    Check.truthy(config.spike_factor > 1, "facteur de pic")
    Check.truthy(config.pause_limit > config.stats_interval, "pause")
    Check.truthy(config.history_size > 0, "historique")
    Check.truthy(config.top_hooks > 0, "classement")
end

Check.case("seuils cohérents", test_config_limits)

--- Chaque texte est une chaîne non vide.
local function test_lang_strings()
    for key, value in pairs(Ballast.lang) do
        Check.truthy(type(value) == "string" and value ~= "", "texte " .. key)
    end
end

Check.case("textes", test_lang_strings)

--- Une traduction remplace un texte sans toucher au code des modules.
local function test_translation()
    Ballast.lang.hooks_reset = "Hook stats reset"
    Mock.run_command("ballast_hooks_reset")
    Check.equal(Mock.output[1], "[Ballast] Hook stats reset", "traduction")
end

Check.case("traduction", test_translation)
