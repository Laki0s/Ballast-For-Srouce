--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests du module 1 : classement des hooks et commandes console.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local COST = 0.002

--- Crée des mesures de hooks aux temps totaux connus.
local function fill_stats()
    Ballast.hook_stats["Think/a"] = { total = 1, calls = 10, max = 0.2 }
    Ballast.hook_stats["Think/b"] = { total = 3, calls = 10, max = 0.5 }
    Ballast.hook_stats["Tick/c"] = { total = 2, calls = 0, max = 0 }
end

--- Le classement est trié par temps total et tronqué à n.
local function test_top()
    local top = nil

    fill_stats()
    top = Ballast.get_top_hooks(2)
    Check.equal(#top, 2, "taille")
    Check.equal(top[1].name, "Think/b", "premier")
    Check.equal(top[2].name, "Tick/c", "second")
end

Check.case("classement", test_top)

--- La remise à zéro garde les enveloppes branchées sur leurs mesures.
local function test_reset()
    Mock.set_convar("ballast_debug", "1")
    hook.Add("Tick", "Test", function()
        Mock.advance(COST)
    end)
    hook.Run("Tick")
    Mock.run_command("ballast_hooks_reset")
    Check.equal(Ballast.hook_stats["Tick/Test"].calls, 0, "après reset")
    hook.Run("Tick")
    Check.equal(Ballast.hook_stats["Tick/Test"].calls, 1, "mesure reprise")
    Check.equal(Ballast.logs[1].msg, Ballast.lang.hooks_reset, "journal")
end

Check.case("remise à zéro", test_reset)

--- Seuls la console et les superadmins lisent les mesures.
local function test_rights()
    local user = Mock.new_player(false)
    local admin = Mock.new_player(true)

    fill_stats()
    Mock.run_command("ballast_hooks", user)
    Mock.run_command("ballast_hooks", admin)
    Check.equal(#user.messages, 0, "joueur sans droits")
    Check.equal(#admin.messages, 4, "en-tête et 3 hooks")
    Check.equal(admin.messages[2], Ballast.text("hooks_line", 1, "Think/b",
        3000, 10, 500, 300), "ligne formatée")
end

Check.case("droits", test_rights)

--- Sans mesure, ballast_hooks explique comment activer le profiler.
local function test_empty()
    Mock.run_command("ballast_hooks")
    Check.equal(Mock.output[1], Ballast.text("hooks_empty"), "aide")
end

Check.case("aucune mesure", test_empty)

--- ballast_status résume frame, serveur et pics en trois lignes.
local function test_status()
    Mock.edicts = 300
    Mock.fire_timer("Ballast_ServerStats")
    Mock.run_command("ballast_status")
    Check.equal(#Mock.output, 3, "trois lignes")
    Check.truthy(Mock.output[2]:find("Edicts : 300", 1, true), "edicts")
end

Check.case("statut", test_status)
