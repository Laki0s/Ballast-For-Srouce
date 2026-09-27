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

--- Enregistre la durée d'un appel puis renvoie ses résultats intacts.
local function record_call(stat, start, ...)
    local elapsed = SysTime() - start

    stat.total = stat.total + elapsed
    stat.calls = stat.calls + 1
    if elapsed > stat.max then
        stat.max = elapsed
    end
    return ...
end

--- Enveloppe fn pour mesurer chacun de ses appels.
local function wrap(event, id, fn)
    local stat = get_stat(event .. "/" .. tostring(id))
    local wrapper = function(...)
        local start = SysTime()

        return record_call(stat, start, fn(...))
    end

    Ballast.original.hooks[wrapper] = fn
    return wrapper
end

--- Remplaçant de hook.Add pendant le mode debug.
local function profiled_add(event, id, fn)
    local raw_add = Ballast.original.hook_add

    if type(fn) ~= "function" or Ballast.original.hooks[fn] then
        return raw_add(event, id, fn)
    end
    return raw_add(event, id, wrap(event, id, fn))
end

--- Copie la liste des hooks pour la modifier sans casser le parcours.
local function list_hooks()
    local list = {}

    for event, hooks in pairs(hook.GetTable()) do
        for id, fn in pairs(hooks) do
            list[#list + 1] = { event = event, id = id, fn = fn }
        end
    end
    return list
end

--- Enveloppe les hooks enregistrés avant l'activation.
local function wrap_existing()
    for _, entry in ipairs(list_hooks()) do
        profiled_add(entry.event, entry.id, entry.fn)
    end
end

--- Rend à chaque hook enveloppé sa fonction d'origine.
local function unwrap_existing()
    local originals = Ballast.original.hooks

    for _, entry in ipairs(list_hooks()) do
        if originals[entry.fn] then
            hook.Add(entry.event, entry.id, originals[entry.fn])
        end
    end
end

--- Remplace hook.Add en retenant la version courante pour le retour.
local function install()
    if hook.Add ~= Ballast.original.hook_profiler then
        Ballast.original.hook_add = hook.Add
    end
    Ballast.original.hook_profiler = profiled_add
    hook.Add = profiled_add
    wrap_existing()
end
