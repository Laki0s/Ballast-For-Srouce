--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Module 1 (Profiler) : classement des hooks les plus coûteux et commandes
-- console ballast_hooks, ballast_hooks_reset et ballast_status.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local MS = 1000
local KB_PER_MB = 1024

--- Ordonne deux hooks par temps total décroissant.
local function by_total(a, b)
    return a.total > b.total
end

--- Renvoie les n hooks les plus coûteux, triés par temps total.
function Ballast.get_top_hooks(n)
    local list = {}

    for key, stat in pairs(Ballast.hook_stats) do
        list[#list + 1] = {
            name = key,
            total = stat.total,
            calls = stat.calls,
            max = stat.max,
        }
    end
    table.sort(list, by_total)
    for i = #list, n + 1, -1 do
        list[i] = nil
    end
    return list
end
