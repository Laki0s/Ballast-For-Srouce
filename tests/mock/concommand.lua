--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests : commandes console simulées.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local commands = {}

concommand = {}

--- Enregistre la commande console name.
function concommand.Add(name, fn)
    commands[name] = fn
end

--- Lance la commande name ; ply vaut nil pour la console serveur.
function Mock.run_command(name, ply, args)
    commands[name](ply, name, args or {}, "")
end
