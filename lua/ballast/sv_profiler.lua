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
