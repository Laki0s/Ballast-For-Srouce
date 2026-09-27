--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Convars d'activation des modules : création et suivi des changements.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local PREFIX = "ballast_"
local FLAGS = { FCVAR_ARCHIVE, FCVAR_NOTIFY }

--- Crée la convar ballast_<name> (0 ou 1) avec son texte d'aide.
function Ballast.add_convar(name, default, help)
    return CreateConVar(PREFIX .. name, default, FLAGS, help, 0, 1)
end

--- Appelle on_change(actif) tout de suite puis à chaque changement.
function Ballast.watch_convar(name, id, on_change)
    local full = PREFIX .. name

    cvars.AddChangeCallback(full, function(_, _, value)
        on_change((tonumber(value) or 0) ~= 0)
    end, id)
    on_change(GetConVar(full):GetBool())
end
