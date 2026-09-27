--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests : convars simulées, avec leurs callbacks de changement.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local convars = {}
local callbacks = {}

cvars = {}

--- Valeur booléenne d'une convar simulée.
local function get_bool(self)
    return (tonumber(self.value) or 0) ~= 0
end

--- Crée la convar name si elle n'existe pas, puis la renvoie.
function CreateConVar(name, default)
    if not convars[name] then
        convars[name] = { value = default, GetBool = get_bool }
    end
    return convars[name]
end

--- Renvoie la convar name.
function GetConVar(name)
    return convars[name]
end

--- Enregistre fn, appelée à chaque changement de la convar name.
function cvars.AddChangeCallback(name, fn, id)
    callbacks[name] = callbacks[name] or {}
    callbacks[name][id or #callbacks[name] + 1] = fn
end

--- Change la valeur d'une convar et prévient ses callbacks, comme le moteur.
function Mock.set_convar(name, value)
    local convar = convars[name]
    local old = convar.value

    convar.value = value
    for _, fn in pairs(callbacks[name] or {}) do
        fn(name, old, value)
    end
end
