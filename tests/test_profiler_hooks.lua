--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests du module 1 : profiler de hooks (enveloppe de hook.Add).
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local COST = 0.004

--- Simule un hook qui coûte COST secondes.
local function costly()
    Mock.advance(COST)
end

--- Hors mode debug, hook.Add n'est pas touché.
local function test_inactive()
    Check.equal(hook.Add, Mock.hook_add, "hook.Add d'origine")
    Check.equal(Ballast.config.debug, false, "mode debug")
end

Check.case("inactif par défaut", test_inactive)

--- ballast_debug 1 remplace hook.Add et le journalise.
local function test_enable()
    Mock.set_convar("ballast_debug", "1")
    Check.truthy(hook.Add ~= Mock.hook_add, "hook.Add remplacé")
    Check.equal(Ballast.config.debug, true, "mode debug")
    Check.equal(Ballast.logs[1].msg, Ballast.lang.hooks_on, "journal")
end

Check.case("activation", test_enable)

--- Les hooks ajoutés en mode debug sont mesurés.
local function test_measure()
    local stat = nil

    Mock.set_convar("ballast_debug", "1")
    hook.Add("Tick", "Test", costly)
    hook.Run("Tick")
    hook.Run("Tick")
    stat = Ballast.hook_stats["Tick/Test"]
    Check.equal(stat.calls, 2, "appels")
    Check.near(stat.total, 2 * COST, "temps total")
    Check.near(stat.max, COST, "maximum")
end

Check.case("mesure des nouveaux hooks", test_measure)

--- Les hooks déjà présents sont enveloppés à l'activation.
local function test_existing()
    hook.Add("Tick", "Test", costly)
    Mock.set_convar("ballast_debug", "1")
    hook.Run("Tick")
    Check.equal(Ballast.hook_stats["Tick/Test"].calls, 1, "hook existant")
end

Check.case("hooks existants", test_existing)

--- L'enveloppe rend tous les résultats, nil compris.
local function test_results()
    local wrapped = nil

    Mock.set_convar("ballast_debug", "1")
    hook.Add("Tick", "Test", function(a)
        return a, nil, 3
    end)
    wrapped = hook.GetTable().Tick.Test
    Check.equal(select("#", wrapped(1)), 3, "nombre de résultats")
    Check.equal(select(3, wrapped(1)), 3, "troisième résultat")
end

Check.case("résultats intacts", test_results)

--- ballast_debug 0 rend les fonctions et le hook.Add d'origine.
local function test_disable()
    Mock.set_convar("ballast_debug", "1")
    hook.Add("Tick", "Test", costly)
    Mock.set_convar("ballast_debug", "0")
    Check.equal(hook.GetTable().Tick.Test, costly, "fonction d'origine")
    Check.equal(hook.Add, Mock.hook_add, "hook.Add d'origine")
    Check.equal(Ballast.logs[1].msg, Ballast.lang.hooks_off, "journal")
end

Check.case("retour à l'origine", test_disable)

--- Réactiver n'enveloppe pas deux fois la même fonction.
local function test_no_double_wrap()
    hook.Add("Tick", "Test", costly)
    Mock.set_convar("ballast_debug", "1")
    Mock.set_convar("ballast_debug", "0")
    Mock.set_convar("ballast_debug", "1")
    hook.Add("Tick", "Test", hook.GetTable().Tick.Test)
    hook.Run("Tick")
    Check.equal(Ballast.hook_stats["Tick/Test"].calls, 1, "un seul appel")
    Check.near(Ballast.hook_stats["Tick/Test"].total, COST, "coût unique")
end

Check.case("pas de double enveloppe", test_no_double_wrap)

--- Un identifiant objet reste passé en premier argument.
local function test_object_id()
    local owner = Mock.new_player(false)
    local seen = nil

    Mock.set_convar("ballast_debug", "1")
    hook.Add("Tick", owner, function(self)
        seen = self
    end)
    hook.Run("Tick")
    Check.equal(seen, owner, "objet transmis")
end

Check.case("identifiant objet", test_object_id)
