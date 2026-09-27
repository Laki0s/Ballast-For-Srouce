--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests du module 1 : edicts, joueurs et mémoire Lua.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

--- Chaque échantillon relève edicts, joueurs et mémoire.
local function test_sample()
    Mock.edicts = 120
    Mock.players = 5
    Mock.fire_timer("Ballast_ServerStats")
    Check.equal(Ballast.server.edicts, 120, "edicts")
    Check.equal(Ballast.server.players, 5, "joueurs")
    Check.truthy(Ballast.server.memory > 0, "mémoire Lua")
end

Check.case("échantillon", test_sample)

--- Le maximum survit à la baisse de la valeur courante.
local function test_max()
    Mock.edicts = 200
    Mock.fire_timer("Ballast_ServerStats")
    Mock.edicts = 50
    Mock.fire_timer("Ballast_ServerStats")
    Check.equal(Ballast.server.edicts, 50, "valeur courante")
    Check.equal(Ballast.server.edicts_max, 200, "maximum")
end

Check.case("maximum conservé", test_max)

--- ballast_profiler 0 arrête l'échantillonnage.
local function test_disable()
    Mock.set_convar("ballast_profiler", "0")
    Check.equal(timer.Exists("Ballast_ServerStats"), false, "timer")
end

Check.case("désactivation", test_disable)
