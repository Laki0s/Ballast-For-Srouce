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

--- C-G1 : en-tête standard du projet en tête de fichier.
local function check_header(file, report)
    for n, pattern in ipairs(HEADER) do
        if not (file.lines[n] or ""):match(pattern) then
            report(n, "C-G1", "en-tête du projet absent ou incomplet")
            return
        end
    end
    for n = #HEADER + 1, HEADER_SEARCH do
        if file.lines[n] == "--" then
            return
        end
    end
    report(#HEADER, "C-G1", "en-tête du projet non refermé par --")
end

--- C-F3 : 80 colonnes maximum.
local function check_width(file, report)
    for n, line in ipairs(file.lines) do
        if utf8_len(line) > MAX_WIDTH then
            report(n, "C-F3", "ligne de plus de 80 colonnes")
        end
    end
end

--- C-G7 : aucun espace en fin de ligne.
local function check_trailing(file, report)
    for n, line in ipairs(file.lines) do
        if line:match("[ \t]$") then
            report(n, "C-G7", "espace en fin de ligne")
        end
    end
end

--- C-L2 : indentation par 4 espaces, aucune tabulation.
local function check_indent(file, report)
    for n, line in ipairs(file.lines) do
        if line:find("\t", 1, true) then
            report(n, "C-L2", "tabulation interdite")
        end
        if #line:match("^ *") % INDENT ~= 0 then
            report(n, "C-L2", "indentation qui n'est pas un multiple de 4")
        end
    end
end

--- C-G6 : fins de ligne LF, sans \r ni \ final.
local function check_eol(file, report)
    for n, line in ipairs(file.lines) do
        if line:find("\r", 1, true) then
            report(n, "C-G6", "fin de ligne \\r interdite")
        end
        if file.code[n]:match("\\%s*$") then
            report(n, "C-G6", "\\ en fin de ligne interdit")
        end
    end
end
