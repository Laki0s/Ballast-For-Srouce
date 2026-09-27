--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Module 1 (Profiler) : edicts, joueurs et mémoire Lua, échantillonnés
-- à chaque intervalle avec leur maximum depuis le démarrage.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

Ballast.server = Ballast.server or {}

--- Enregistre la valeur courante d'une mesure et met à jour son maximum.
local function record(key, value)
    local server = Ballast.server
    local max_key = key .. "_max"

    server[key] = value
    if value > (server[max_key] or 0) then
        server[max_key] = value
    end
end

--- Échantillonne edicts, joueurs et mémoire Lua (en Ko).
local function sample()
    record("edicts", ents.GetEdictCount())
    record("players", player.GetCount())
    record("memory", collectgarbage("count"))
end

--- Démarre ou arrête l'échantillonnage selon la convar ballast_profiler.
local function set_enabled(enabled)
    if not enabled then
        timer.Remove("Ballast_ServerStats")
        return
    end
    sample()
    timer.Create("Ballast_ServerStats", Ballast.config.stats_interval, 0,
        sample)
end

Ballast.watch_convar("profiler", "Ballast_ServerStats", set_enabled)
