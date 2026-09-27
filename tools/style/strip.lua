--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Vérificateur de style : sépare le code des chaînes et des commentaires
-- pour que les règles ne s'appliquent qu'au code.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local SPECIAL = "[\"'%[%-]"
local COMMENT_FILL = "\1"
local STRING_FILL = " "

local M = {}

--- Remplace chaque caractère par fill, sauf les retours à la ligne.
local function blank(chunk, fill)
    return (chunk:gsub("[^\n]", fill))
end
