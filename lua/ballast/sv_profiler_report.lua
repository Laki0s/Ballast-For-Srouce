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

--- Remet les mesures à zéro sans casser les enveloppes déjà posées.
function Ballast.reset_hook_stats()
    for _, stat in pairs(Ballast.hook_stats) do
        stat.total = 0
        stat.calls = 0
        stat.max = 0
    end
end

--- Envoie une ligne à l'appelant : console serveur ou console du joueur.
local function reply(ply, text)
    if IsValid(ply) then
        ply:PrintMessage(HUD_PRINTCONSOLE, text)
    else
        MsgN(text)
    end
end

--- Indique si l'appelant peut lire les mesures : console ou superadmin.
local function is_allowed(ply)
    return not IsValid(ply) or ply:IsSuperAdmin()
end

--- Formate une ligne du classement des hooks.
local function format_hook(rank, entry)
    local avg = entry.calls > 0 and entry.total / entry.calls or 0

    return Ballast.text("hooks_line", rank, entry.name, entry.total * MS,
        entry.calls, entry.max * MS, avg * MS)
end

--- Commande ballast_hooks : affiche les hooks les plus coûteux.
local function cmd_hooks(ply)
    local top = nil

    if not is_allowed(ply) then
        return
    end
    top = Ballast.get_top_hooks(Ballast.config.top_hooks)
    if #top == 0 then
        reply(ply, Ballast.text("hooks_empty"))
        return
    end
    reply(ply, Ballast.text("hooks_header", #top))
    for rank, entry in ipairs(top) do
        reply(ply, format_hook(rank, entry))
    end
end

--- Commande ballast_hooks_reset : remet les mesures des hooks à zéro.
local function cmd_reset(ply)
    if not is_allowed(ply) then
        return
    end
    Ballast.reset_hook_stats()
    Ballast.log(Ballast.lang.cat_profiler, Ballast.text("hooks_reset"))
    reply(ply, "[Ballast] " .. Ballast.text("hooks_reset"))
end
