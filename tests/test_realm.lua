--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests du socle : chargement côté client et rechargement à chaud de
-- l'addon (lua refresh), qui ne doit rien perdre ni rien doubler.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local INIT = "lua/autorun/ballast_init.lua"
local COST = 0.004
local NORMAL = 0.03

--- Simule un hook qui coûte COST secondes.
local function costly()
    Mock.advance(COST)
end

--- Recharge l'addon sans toucher à l'API simulée, comme un lua refresh.
local function reload()
    dofile(Mock.root .. INIT)
end

--- Côté client, seuls les fichiers sh_ s'exécutent et rien n'est envoyé.
local function test_client()
    Ballast = nil
    SERVER = false
    CLIENT = true
    Mock.sent = {}
    reload()
    Check.truthy(Ballast.config, "configuration partagée")
    Check.truthy(Ballast.text, "textes partagés")
    Check.equal(Ballast.log, nil, "journal (serveur)")
    Check.equal(Ballast.get_top_hooks, nil, "profiler (serveur)")
    Check.equal(#Mock.sent, 0, "aucun envoi")
end

Check.case("chargement côté client", test_client)

--- Le rechargement garde journal, compteurs et historique.
local function test_reload_state()
    Ballast.log("Test", "avant")
    Ballast.count("test")
    Mock.fire_timer("Ballast_FrameStats")
    reload()
    Check.equal(Ballast.logs[1].msg, "avant", "journal")
    Check.equal(Ballast.stats.test, 1, "compteur")
    Check.equal(#Ballast.history, 1, "historique")
end

Check.case("rechargement : état conservé", test_reload_state)

--- Recharger en mode debug ne double pas les mesures et garde le retour.
local function test_reload_debug()
    Mock.set_convar("ballast_debug", "1")
    hook.Add("Tick", "Test", costly)
    reload()
    Check.equal(Ballast.config.debug, true, "mode debug conservé")
    hook.Run("Tick")
    Check.equal(Ballast.hook_stats["Tick/Test"].calls, 1, "un seul appel")
    Mock.set_convar("ballast_debug", "0")
    Check.equal(hook.GetTable().Tick.Test, costly, "fonction d'origine")
    Check.equal(hook.Add, Mock.hook_add, "hook.Add d'origine")
end

Check.case("rechargement en mode debug", test_reload_debug)

--- Le temps passé avant un rechargement ne compte pas comme un pic.
local function test_reload_frame()
    Mock.advance(1)
    reload()
    Mock.advance(NORMAL)
    hook.Run("Think")
    Check.equal(Ballast.stats.lag_spikes, nil, "aucun pic")
    Check.near(Ballast.frame_time, NORMAL, "temps de frame")
end

Check.case("rechargement sans faux pic", test_reload_frame)
