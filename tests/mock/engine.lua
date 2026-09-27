--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests : moteur simulé (tick, edicts, joueurs) et chargement des fichiers.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local TICK_INTERVAL = 1 / 33

engine = {}
ents = {}
player = {}
Mock.sent = {}

--- Durée d'un tick à 33 ticks par seconde.
function engine.TickInterval()
    return TICK_INTERVAL
end

--- Nombre d'edicts, réglé par les tests via Mock.edicts.
function ents.GetEdictCount()
    return Mock.edicts
end

--- Nombre de joueurs, réglé par les tests via Mock.players.
function player.GetCount()
    return Mock.players
end

--- Retient les fichiers envoyés aux clients.
function AddCSLuaFile(path)
    Mock.sent[#Mock.sent + 1] = path or "autorun"
end

--- Exécute un fichier du dossier lua/ du dépôt.
function include(path)
    dofile(Mock.root .. "lua/" .. path)
end
