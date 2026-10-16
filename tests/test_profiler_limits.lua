--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests du module 1 : cas limites du temps de frame (seuil exact, pause,
-- réactivation) et de l'échantillonnage serveur.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local NORMAL = 0.03
local SLOW = 0.05
local SPIKE = 0.1
local PAUSE = 11

--- Simule une frame de dt secondes.
local function frame(dt)
    Mock.advance(dt)
    hook.Run("Think")
end

--- Une frame d'exactement deux ticks n'est pas encore un pic.
local function test_threshold()
    frame(2 * engine.TickInterval())
    Check.equal(Ballast.stats.lag_spikes, nil, "seuil exact")
end

Check.case("seuil exact", test_threshold)

--- Réactiver le profiler repart de l'heure courante, sans faux pic.
local function test_restart()
    Mock.set_convar("ballast_profiler", "0")
    Mock.advance(5)
    Mock.set_convar("ballast_profiler", "1")
    frame(NORMAL)
    Check.equal(Ballast.stats.lag_spikes, nil, "aucun pic")
    Check.near(Ballast.frame_time, NORMAL, "temps de frame")
end

Check.case("réactivation sans faux pic", test_restart)

--- La pause n'entre ni dans la moyenne ni dans le maximum.
local function test_pause_stats()
    frame(NORMAL)
    frame(PAUSE)
    Mock.fire_timer("Ballast_FrameStats")
    Check.near(Ballast.frame_avg, NORMAL, "moyenne")
    Check.near(Ballast.frame_max, NORMAL, "maximum")
end

Check.case("pause hors statistiques", test_pause_stats)

--- La frame qui suit une pause est mesurée normalement.
local function test_after_pause()
    frame(PAUSE)
    frame(SPIKE)
    Check.near(Ballast.frame_time, SPIKE, "frame suivante")
    Check.equal(Ballast.stats.lag_spikes, 1, "pic suivant compté")
end

Check.case("frame après une pause", test_after_pause)

--- Les pics déjà journalisés ne réapparaissent pas la seconde suivante.
local function test_spike_log_reset()
    frame(SPIKE)
    Mock.fire_timer("Ballast_FrameStats")
    frame(NORMAL)
    Mock.fire_timer("Ballast_FrameStats")
    Check.equal(#Ballast.logs, 1, "une seule ligne")
    Check.equal(Ballast.stats.lag_spikes, 1, "compteur cumulé")
end

Check.case("journal remis à zéro", test_spike_log_reset)

--- L'historique perd ses plus anciennes valeurs en premier.
local function test_history_order()
    Ballast.config.history_size = 2
    for _, dt in ipairs({ NORMAL, SLOW, SPIKE }) do
        frame(dt)
        Mock.fire_timer("Ballast_FrameStats")
    end
    Check.near(Ballast.history[1], SLOW, "plus ancienne gardée")
    Check.near(Ballast.history[2], SPIKE, "plus récente")
end

Check.case("ordre de l'historique", test_history_order)

--- Les mesures serveur sont relevées dès l'activation, sans attendre.
local function test_server_immediate()
    Mock.edicts = 42
    Mock.set_convar("ballast_profiler", "0")
    Mock.set_convar("ballast_profiler", "1")
    Check.equal(Ballast.server.edicts, 42, "échantillon immédiat")
    Check.truthy(timer.Exists("Ballast_ServerStats"), "timer relancé")
end

Check.case("échantillon à l'activation", test_server_immediate)
