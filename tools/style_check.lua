--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Vérificateur du coding style Ballast pour le Lua. Usage :
-- luajit tools/style_check.lua fichier.lua [...]
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local DIR = (arg[0]:match("^(.*)[/\\]") or ".") .. "/style/"
local strip = dofile(DIR .. "strip.lua")
local CHECKERS = {
    dofile(DIR .. "lines.lua"),
    dofile(DIR .. "syntax.lua"),
    dofile(DIR .. "blocks.lua"),
    dofile(DIR .. "functions.lua"),
    dofile(DIR .. "layout.lua"),
}

--- Lit un fichier en entier ; nil s'il est illisible.
local function read_file(path)
    local handle = io.open(path, "rb")
    local text = nil

    if not handle then
        return nil
    end
    text = handle:read("*a")
    handle:close()
    return text
end
