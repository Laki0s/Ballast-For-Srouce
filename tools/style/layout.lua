--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Vérificateur de style : mise en page dans une fonction, avec les local
-- en tête (C-L5) suivis d'une seule ligne vide (C-L6).
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local M = {}

--- Fins de ligne qui annoncent la suite de l'expression.
local OPEN_ENDS = {
    "[,%(%{%[=]%s*$",
    "%.%.%s*$",
    "%f[%w_]and%s*$",
    "%f[%w_]or%s*$",
    "%f[%w_]not%s*$",
    "[%+%-%*/%%%^<>]%s*$",
}

--- Débuts de ligne qui prolongent l'expression précédente.
local OPEN_STARTS = {
    "^%s*and%f[^%w_]",
    "^%s*or%f[^%w_]",
    "^%s*%.%.",
    "^%s*[%+%*/%%%^<>=~]",
}

--- Débuts de ligne qui ne font que fermer un bloc.
local CLOSERS = {
    "^%s*[%}%)%]]",
    "^%s*end%f[^%w_]",
    "^%s*until%f[^%w_]",
}

--- Indique si un des motifs de patterns apparaît dans code.
local function matches_any(code, patterns)
    for _, pattern in ipairs(patterns) do
        if code:find(pattern) then
            return true
        end
    end
    return false
end

--- Classe une ligne : blank, skip (suite ou fermeture), local ou other.
local function classify(line, code, prev)
    if line:match("^%s*$") then
        return "blank"
    end
    if matches_any(prev, OPEN_ENDS) or matches_any(code, OPEN_STARTS) then
        return "skip"
    end
    if matches_any(code, CLOSERS) then
        return "skip"
    end
    if code:match("^%s*local%s") then
        return "local"
    end
    return "other"
end
