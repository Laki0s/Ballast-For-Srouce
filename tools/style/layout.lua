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

--- C-L5 : les déclarations restent en tête de la fonction.
local function on_local(state, n, report)
    if state.phase ~= "decl" then
        report(n, "C-L5", "déclaration après une instruction")
    end
    state.has_locals = true
end

--- C-L6 : une seule ligne vide, juste après les déclarations.
local function on_blank(state, n, report)
    if state.phase == "decl" and state.has_locals then
        state.phase = "gap"
        return
    end
    report(n, "C-L6", "ligne vide inattendue dans une fonction")
end

--- C-L6 : la première instruction suit la ligne vide des déclarations.
local function on_other(state, n, report)
    if state.phase == "decl" and state.has_locals then
        report(n, "C-L6", "ligne vide attendue après les déclarations")
    end
    state.phase = "body"
end

--- Traitement de chaque type de ligne.
local VISITORS = {
    ["local"] = on_local,
    ["blank"] = on_blank,
    ["other"] = on_other,
}

--- Vérifie la mise en page des lignes qui appartiennent à la fonction info.
local function check_function(file, info, report)
    local state = { phase = "decl", has_locals = false }
    local prev = ""
    local kind = nil

    for n = info.line + 1, info.last - 1 do
        kind = file.owners[n] == info
            and classify(file.lines[n], file.code[n], prev) or nil
        if VISITORS[kind] then
            VISITORS[kind](state, n, report)
        end
        if kind and kind ~= "blank" then
            prev = file.code[n]
        end
    end
end

--- Applique les règles de mise en page à chaque fonction (après blocks).
function M.check(file, report)
    for _, info in ipairs(file.functions) do
        check_function(file, info, report)
    end
end

return M
