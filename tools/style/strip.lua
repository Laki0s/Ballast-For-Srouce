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

--- Trouve la fin d'une chaîne entre guillemets ouverte à start.
local function quoted_end(text, start)
    local quote = text:sub(start, start)
    local pos = start + 1
    local found = nil

    while true do
        found = text:find("[\\\n" .. quote .. "]", pos)
        if not found or text:sub(found, found) ~= "\\" then
            return found or #text
        end
        pos = found + 2
    end
end

--- Trouve la fin d'un bloc long ]==] de niveau level ouvert à start.
local function long_end(text, start, level)
    local _, finish = text:find("]" .. level .. "]", start, true)

    return finish or #text
end

--- Renvoie la fin et le remplissage du jeton spécial débutant à pos,
--- ou nil si pos n'ouvre ni chaîne ni commentaire.
local function special_end(text, pos)
    local c = text:sub(pos, pos)
    local level = text:match("^%[(=*)%[", pos)
    local comment = text:match("^%-%-%[(=*)%[", pos)

    if c == "\"" or c == "'" then
        return quoted_end(text, pos), STRING_FILL
    end
    if c == "[" and level then
        return long_end(text, pos, level), STRING_FILL
    end
    if comment then
        return long_end(text, pos, comment), COMMENT_FILL
    end
    if text:sub(pos, pos + 1) == "--" then
        return (text:find("\n", pos) or #text + 1) - 1, COMMENT_FILL
    end
    return nil
end

--- Ajoute à parts le code jusqu'à start puis le jeton spécial masqué ;
--- renvoie la position où reprendre la lecture.
local function append_token(parts, text, pos, start)
    local finish, fill = special_end(text, start)

    if not finish then
        parts[#parts + 1] = text:sub(pos, start)
        return start + 1
    end
    parts[#parts + 1] = text:sub(pos, start - 1)
    parts[#parts + 1] = blank(text:sub(start, finish), fill)
    return finish + 1
end

--- Masque chaînes (espaces) et commentaires (octet 1) en gardant les lignes.
function M.strip(text)
    local parts = {}
    local pos = 1
    local start = text:find(SPECIAL, pos)

    while start do
        pos = append_token(parts, text, pos, start)
        start = text:find(SPECIAL, pos)
    end
    parts[#parts + 1] = text:sub(pos)
    return table.concat(parts)
end

--- Découpe un texte en lignes, sans les retours à la ligne.
function M.split(text)
    local lines = {}
    local body = text

    if body:sub(-1) ~= "\n" then
        body = body .. "\n"
    end
    for line in body:gmatch("(.-)\n") do
        lines[#lines + 1] = line
    end
    return lines
end
