--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests : bibliothèque hook simulée, fidèle à celle de GMod.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local unpack = table.unpack or unpack
local hooks = {}

hook = {}

--- Enregistre fn pour l'événement event sous l'identifiant id.
function hook.Add(event, id, fn)
    hooks[event] = hooks[event] or {}
    hooks[event][id] = fn
end

--- Retire le hook id de l'événement event.
function hook.Remove(event, id)
    if hooks[event] then
        hooks[event][id] = nil
    end
end

--- Renvoie la table des hooks : événement, puis identifiant, puis fonction.
function hook.GetTable()
    return hooks
end

--- Appelle fn comme GMod : un identifiant objet est passé en premier.
local function call_one(id, fn, ...)
    if type(id) == "string" then
        return fn(...)
    end
    return fn(id, ...)
end

--- Regroupe des résultats, nil compris, avec leur nombre.
local function pack(...)
    return { n = select("#", ...), ... }
end

--- Appelle les hooks de event ; le premier résultat non nil arrête tout.
function hook.Call(event, _, ...)
    local results = nil

    for id, fn in pairs(hooks[event] or {}) do
        results = pack(call_one(id, fn, ...))
        if results[1] ~= nil then
            return unpack(results, 1, results.n)
        end
    end
    return nil
end

--- Déclenche l'événement event avec ses arguments.
function hook.Run(event, ...)
    return hook.Call(event, nil, ...)
end

Mock.hook_add = hook.Add
