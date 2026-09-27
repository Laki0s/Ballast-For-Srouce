--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Module 1 (Profiler) : coût de chaque hook, mesuré en enveloppant les
-- fonctions passées à hook.Add. Actif seulement avec ballast_debug 1.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local SysTime = SysTime

Ballast.hook_stats = Ballast.hook_stats or {}
Ballast.original.hooks = Ballast.original.hooks
    or setmetatable({}, { __mode = "k" })

--- Renvoie les mesures du hook key, créées au premier appel.
local function get_stat(key)
    local stat = Ballast.hook_stats[key]

    if not stat then
        stat = { total = 0, calls = 0, max = 0 }
        Ballast.hook_stats[key] = stat
    end
    return stat
end
