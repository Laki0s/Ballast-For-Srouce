--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Vérificateur de style : règles ligne à ligne (en-tête, largeur, espaces,
-- fins de ligne, lignes vides).
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local MAX_WIDTH = 80
local INDENT = 4
local HEADER = {
    "^%-%-$",
    "^%-%- BALLAST FOR SOURCE PROJECT, %d%d%d%d$",
    "^%-%- ballast_for_source$",
    "^%-%- File description:$",
    "^%-%- %S",
}
local HEADER_SEARCH = 15

local M = {}

--- Compte les caractères UTF-8 d'une ligne (et non ses octets).
local function utf8_len(line)
    return #line - select(2, line:gsub("[\128-\191]", ""))
end
