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
