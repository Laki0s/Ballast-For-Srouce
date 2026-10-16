--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests du module 1 : droits, réponses et cas limites des commandes
-- console ballast_hooks, ballast_hooks_reset et ballast_status.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local NORMAL = 0.03
local SPIKE = 0.1

--- Crée des mesures de hooks aux temps totaux connus.
local function fill_stats()
    Ballast.hook_stats["Think/a"] = { total = 1, calls = 10, max = 0.2 }
    Ballast.hook_stats["Think/b"] = { total = 3, calls = 10, max = 0.5 }
    Ballast.hook_stats["Tick/c"] = { total = 2, calls = 5, max = 0.4 }
end

--- Un joueur sans droits ne peut ni remettre à zéro ni lire le statut.
local function test_denied()
    local user = Mock.new_player(false)

    fill_stats()
    Mock.run_command("ballast_hooks_reset", user)
    Mock.run_command("ballast_status", user)
    Check.equal(Ballast.hook_stats["Think/a"].calls, 10, "mesures gardées")
    Check.equal(#user.messages, 0, "aucune réponse")
    Check.equal(#Ballast.logs, 0, "rien au journal")
end

Check.case("refus sans droits", test_denied)

--- Un superadmin reçoit le statut dans sa console, pas le serveur.
local function test_status_admin()
    local admin = Mock.new_player(true)

    Mock.run_command("ballast_status", admin)
    Check.equal(#admin.messages, 3, "trois lignes")
    Check.equal(#Mock.output, 0, "console serveur muette")
end

Check.case("statut pour un superadmin", test_status_admin)

--- Le statut affiche moyenne, maximum, budget et pics en millisecondes.
local function test_status_values()
    Mock.advance(NORMAL)
    hook.Run("Think")
    Mock.advance(SPIKE)
    hook.Run("Think")
    Mock.fire_timer("Ballast_FrameStats")
    Mock.run_command("ballast_status")
    Check.equal(Mock.output[1], Ballast.text("status_frame", 65, 100,
        1000 / 33), "ligne frame")
    Check.equal(Mock.output[3], Ballast.text("status_spikes", 1), "pics")
end

Check.case("valeurs du statut", test_status_values)

--- Un hook jamais appelé a une moyenne nulle, sans division par zéro.
local function test_zero_calls()
    Ballast.hook_stats["Tick/c"] = { total = 0, calls = 0, max = 0 }
    Mock.run_command("ballast_hooks")
    Check.equal(Mock.output[2], Ballast.text("hooks_line", 1, "Tick/c",
        0, 0, 0, 0), "moyenne nulle")
end

Check.case("hook sans appel", test_zero_calls)

--- Le classement accepte n plus grand que la liste, ou nul.
local function test_top_bounds()
    fill_stats()
    Check.equal(#Ballast.get_top_hooks(10), 3, "n trop grand")
    Check.equal(#Ballast.get_top_hooks(0), 0, "n nul")
end

Check.case("bornes du classement", test_top_bounds)

--- ballast_hooks s'arrête à top_hooks lignes.
local function test_top_config()
    fill_stats()
    Ballast.config.top_hooks = 1
    Mock.run_command("ballast_hooks")
    Check.equal(#Mock.output, 2, "en-tête et un hook")
    Check.equal(Mock.output[1], Ballast.text("hooks_header", 1), "en-tête")
end

Check.case("réglage top_hooks", test_top_config)

--- La remise à zéro est confirmée à la console serveur.
local function test_reset_reply()
    Mock.run_command("ballast_hooks_reset")
    Check.equal(Mock.output[1], "[Ballast] " .. Ballast.lang.hooks_reset,
        "confirmation")
end

Check.case("confirmation de remise à zéro", test_reset_reply)
