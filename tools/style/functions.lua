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
