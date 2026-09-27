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
