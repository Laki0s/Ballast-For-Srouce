--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Vérificateur de style : règles sur les fonctions (taille, paramètres,
-- nombre par fichier, nommage, commentaires).
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local MAX_LINES = 20
local MAX_PARAMS = 4
local MAX_FUNCTIONS = 10
local MAX_PUBLIC = 5
local SNAKE_CASE = "^[a-z_][a-z0-9_]*$"

local M = {}

--- C-F4 : corps de 20 lignes maximum, fonctions anonymes comprises.
local function check_length(file, report)
    local body = 0

    for _, info in ipairs(file.functions) do
        body = info.last - info.line - 1
        if body > MAX_LINES then
            report(info.line, "C-F4", "corps de " .. body .. " lignes")
        end
    end
end

--- C-F5 : 4 paramètres maximum, ... compris.
local function check_params(file, report)
    for _, info in ipairs(file.functions) do
        if info.params > MAX_PARAMS then
            report(info.line, "C-F5", info.params .. " paramètres")
        end
    end
end

--- C-O3 : 10 fonctions nommées par fichier, dont 5 publiques.
local function check_counts(file, report)
    local named = 0
    local public = 0

    for _, info in ipairs(file.functions) do
        if info.name ~= "" then
            named = named + 1
            public = public + (info.is_local and 0 or 1)
        end
    end
    if named > MAX_FUNCTIONS then
        report(1, "C-O3", named .. " fonctions dans le fichier")
    end
    if public > MAX_PUBLIC then
        report(1, "C-O3", public .. " fonctions publiques dans le fichier")
    end
end

--- C-F8 : un commentaire --- au-dessus de chaque fonction nommée.
local function check_doc(file, report)
    local above = nil

    for _, info in ipairs(file.functions) do
        above = file.lines[info.line - 1] or ""
        if info.name ~= "" and not above:match("^%s*%-%-%-") then
            report(info.line, "C-F8", "commentaire --- manquant")
        end
    end
end

--- C-F8 : aucun commentaire à l'intérieur d'une fonction.
local function check_inner_comments(file, report)
    for n, is_comment in ipairs(file.comments) do
        if is_comment and file.owners[n] then
            report(n, "C-F8", "commentaire dans une fonction")
        end
    end
end

--- Indique si le nom de la fonction relève du projet (local ou Ballast.*).
local function is_project_name(info)
    return info.name ~= ""
        and (info.is_local or info.name:match("^Ballast%.") ~= nil)
end

--- C-F2 : fonctions locales et Ballast.* en snake_case anglais.
local function check_names(file, report)
    local short = nil

    for _, info in ipairs(file.functions) do
        short = info.name:match("([^%.:]+)$") or ""
        if is_project_name(info) and not short:match(SNAKE_CASE) then
            report(info.line, "C-F2", info.name .. " n'est pas en snake_case")
        end
    end
end
