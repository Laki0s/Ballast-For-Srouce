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

--- Formate une infraction, en annotation GitHub dans la CI.
local function format_violation(path, line, rule, message)
    if os.getenv("GITHUB_ACTIONS") then
        return string.format("::error file=%s,line=%d::[%s] %s",
            path, line, rule, message)
    end
    return string.format("%s:%d: [%s] %s", path, line, rule, message)
end

--- Crée la fonction de signalement d'un fichier, qui compte les infractions.
local function make_reporter(path, total)
    return function(line, rule, message)
        total.count = total.count + 1
        print(format_violation(path, line, rule, message))
    end
end

--- Vérifie un fichier et ajoute ses infractions au total.
local function check_file(path, total)
    local text = read_file(path)
    local report = make_reporter(path, total)
    local file = nil

    if not text then
        report(1, "IO", "fichier illisible")
        return
    end
    file = strip.build(path, text)
    for _, checker in ipairs(CHECKERS) do
        checker.check(file, report)
    end
end
