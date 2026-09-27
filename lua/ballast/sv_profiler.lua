--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Module 1 (Profiler) : temps de frame réel, détection des pics de lag,
-- moyenne et maximum par seconde avec leur historique.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local MS = 1000
local SysTime = SysTime
local config = Ballast.config

local last = 0
local acc = 0
local count = 0
local peak = 0
local spikes = 0

Ballast.frame_time = 0
Ballast.frame_avg = 0
Ballast.frame_max = 0
Ballast.frame_budget = engine.TickInterval()
Ballast.history = Ballast.history or {}

--- Signale un pic de lag aux autres modules via le hook Ballast_LagSpike.
local function report_spike(frame_time)
    spikes = spikes + 1
    Ballast.count("lag_spikes")
    hook.Run("Ballast_LagSpike", frame_time)
end

--- Cumule une frame pour la moyenne et le maximum de la seconde.
local function accumulate(frame_time)
    acc = acc + frame_time
    count = count + 1
    if frame_time > peak then
        peak = frame_time
    end
end

--- Mesure le temps écoulé depuis la frame précédente (hook Think).
local function measure_frame()
    local now = SysTime()
    local frame_time = now - last

    last = now
    if frame_time > config.pause_limit then
        return
    end
    Ballast.frame_time = frame_time
    accumulate(frame_time)
    if frame_time > Ballast.frame_budget * config.spike_factor then
        report_spike(frame_time)
    end
end

--- Ajoute une moyenne à l'historique, borné à history_size valeurs.
local function push_history(avg)
    local history = Ballast.history

    history[#history + 1] = avg
    while #history > config.history_size do
        table.remove(history, 1)
    end
end

--- Journalise en une seule ligne les pics de la seconde écoulée.
local function log_spikes()
    local worst = peak * MS

    if spikes == 0 then
        return
    end
    Ballast.log(Ballast.lang.cat_profiler,
        Ballast.text("lag_spikes", spikes, worst))
    spikes = 0
end

--- Publie moyenne et maximum de la seconde puis remet les cumuls à zéro.
local function flush_second()
    Ballast.frame_avg = count > 0 and acc / count or 0
    Ballast.frame_max = peak
    push_history(Ballast.frame_avg)
    log_spikes()
    acc = 0
    count = 0
    peak = 0
end

--- Branche la mesure : hook Think et timer d'agrégation.
local function start()
    last = SysTime()
    hook.Add("Think", "Ballast_FrameTime", measure_frame)
    timer.Create("Ballast_FrameStats", config.stats_interval, 0,
        flush_second)
end

--- Débranche la mesure : retire le hook et le timer.
local function stop()
    hook.Remove("Think", "Ballast_FrameTime")
    timer.Remove("Ballast_FrameStats")
end

--- Active ou désactive le module selon la convar ballast_profiler.
local function set_enabled(enabled)
    if enabled then
        start()
    else
        stop()
    end
end

Ballast.add_convar("profiler", "1", Ballast.lang.cvar_profiler)
Ballast.watch_convar("profiler", "Ballast_FrameTime", set_enabled)
