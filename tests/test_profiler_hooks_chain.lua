--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests du module 1 : profiler de hooks face aux autres addons (hook.Add
-- remplacé après Ballast), aux erreurs et aux valeurs inattendues.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local COST = 0.004

--- Simule un hook qui coûte COST secondes.
local function costly()
    Mock.advance(COST)
end

--- Simule un hook qui échoue.
local function broken()
    error("hook cassé")
end

--- Simule un autre addon qui enveloppe hook.Add à son tour.
local function chain(previous)
    return function(event, id, fn)
        return previous(event, id, fn)
    end
end

--- Le hook.Add d'un autre addon posé après Ballast n'est pas écrasé.
local function test_other_addon_kept()
    local other = nil

    Mock.set_convar("ballast_debug", "1")
    other = chain(hook.Add)
    hook.Add = other
    Mock.set_convar("ballast_debug", "0")
    Check.equal(hook.Add, other, "hook.Add de l'autre addon")
end

Check.case("autre addon conservé", test_other_addon_kept)

--- ballast_debug 0 coupe les mesures même derrière un autre addon.
local function test_other_addon_disable()
    Mock.set_convar("ballast_debug", "1")
    hook.Add("Tick", "Test", costly)
    hook.Add = chain(hook.Add)
    Mock.set_convar("ballast_debug", "0")
    Check.equal(Ballast.config.debug, false, "mode debug")
    Check.equal(hook.GetTable().Tick.Test, costly, "fonction d'origine")
    Check.equal(Ballast.logs[1].msg, Ballast.lang.hooks_off, "journal")
    hook.Add("Tick", "New", costly)
    Check.equal(hook.GetTable().Tick.New, costly, "nouveau hook intact")
end

Check.case("désactivation derrière un autre addon", test_other_addon_disable)

--- Réactiver derrière un autre addon reprend les mesures, sans boucle.
local function test_other_addon_enable()
    Mock.set_convar("ballast_debug", "1")
    hook.Add = chain(hook.Add)
    Mock.set_convar("ballast_debug", "0")
    Mock.set_convar("ballast_debug", "1")
    hook.Add("Tick", "Test", costly)
    hook.Run("Tick")
    Check.equal(Ballast.hook_stats["Tick/Test"].calls, 1, "mesure reprise")
end

Check.case("réactivation derrière un autre addon", test_other_addon_enable)

--- Une erreur dans un hook mesuré remonte telle quelle.
local function test_error()
    local result = nil

    Mock.set_convar("ballast_debug", "1")
    hook.Add("Tick", "Test", broken)
    result = { pcall(hook.Run, "Tick") }
    Check.equal(result[1], false, "erreur propagée")
    Check.truthy(tostring(result[2]):find("hook cassé", 1, true), "message")
end

Check.case("erreur propagée", test_error)

--- Une valeur qui n'est pas une fonction est transmise sans mesure.
local function test_not_function()
    Mock.set_convar("ballast_debug", "1")
    hook.Add("Tick", "Test", "pas une fonction")
    Check.equal(hook.GetTable().Tick.Test, "pas une fonction", "valeur")
    Check.equal(Ballast.hook_stats["Tick/Test"], nil, "aucune mesure")
end

Check.case("valeur non fonction", test_not_function)

--- hook.Remove retire aussi un hook enveloppé.
local function test_remove()
    local calls = 0

    Mock.set_convar("ballast_debug", "1")
    hook.Add("Tick", "Test", function()
        calls = calls + 1
    end)
    hook.Remove("Tick", "Test")
    hook.Run("Tick")
    Check.equal(calls, 0, "hook retiré")
end

Check.case("retrait d'un hook mesuré", test_remove)
