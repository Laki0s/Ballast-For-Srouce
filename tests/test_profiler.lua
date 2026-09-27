--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests du module 1 : temps de frame, pics de lag, moyenne et historique.
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

--- Le temps de frame est l'écart entre deux Think.
local function test_frame_time()
    frame(NORMAL)
    Check.near(Ballast.frame_time, NORMAL, "temps de frame")
    Check.near(Ballast.frame_budget, 1 / 33, "budget du tick")
end

Check.case("temps de frame", test_frame_time)

--- Une frame au-delà de 2 ticks déclenche Ballast_LagSpike.
local function test_spike()
    local seen = nil

    hook.Add("Ballast_LagSpike", "Test", function(frame_time)
        seen = frame_time
    end)
    frame(NORMAL)
    Check.equal(seen, nil, "pas de pic sous le seuil")
    frame(SPIKE)
    Check.near(seen, SPIKE, "pic transmis")
    Check.equal(Ballast.stats.lag_spikes, 1, "compteur de pics")
end

Check.case("pic de lag", test_spike)

--- Une très longue frame (hibernation) n'est pas un pic.
local function test_pause()
    frame(NORMAL)
    frame(PAUSE)
    Check.near(Ballast.frame_time, NORMAL, "pause ignorée")
    Check.equal(Ballast.stats.lag_spikes, nil, "aucun pic")
end

Check.case("pause ignorée", test_pause)

--- Chaque seconde publie moyenne et maximum, puis repart de zéro.
local function test_flush()
    frame(NORMAL)
    frame(SLOW)
    Mock.fire_timer("Ballast_FrameStats")
    Check.near(Ballast.frame_avg, (NORMAL + SLOW) / 2, "moyenne")
    Check.near(Ballast.frame_max, SLOW, "maximum")
    Check.near(Ballast.history[1], Ballast.frame_avg, "historique")
    Mock.fire_timer("Ballast_FrameStats")
    Check.equal(Ballast.frame_avg, 0, "seconde sans frame")
end

Check.case("moyenne et maximum", test_flush)

--- L'historique ne dépasse jamais history_size valeurs.
local function test_history()
    Ballast.config.history_size = 3
    for _ = 1, 5 do
        frame(NORMAL)
        Mock.fire_timer("Ballast_FrameStats")
    end
    Check.equal(#Ballast.history, 3, "taille de l'historique")
end

Check.case("historique borné", test_history)

--- Les pics d'une seconde tiennent sur une seule ligne du journal.
local function test_spike_log()
    frame(SPIKE)
    frame(SPIKE)
    Mock.fire_timer("Ballast_FrameStats")
    Check.equal(#Ballast.logs, 1, "une seule ligne")
    Check.equal(Ballast.logs[1].msg,
        Ballast.text("lag_spikes", 2, SPIKE * 1000), "ligne agrégée")
end

Check.case("journal agrégé", test_spike_log)

--- ballast_profiler 0 retire le hook et le timer.
local function test_disable()
    Mock.set_convar("ballast_profiler", "0")
    Check.equal(hook.GetTable().Think.Ballast_FrameTime, nil, "hook Think")
    Check.equal(timer.Exists("Ballast_FrameStats"), false, "timer")
    Mock.set_convar("ballast_profiler", "1")
    Check.truthy(hook.GetTable().Think.Ballast_FrameTime, "réactivation")
end

Check.case("désactivation", test_disable)
