--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests du vérificateur de style : règles ligne à ligne (largeur, espaces,
-- indentation, fins de ligne, lignes vides), nombre et nom des fonctions.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local HEADER = "--\n-- BALLAST FOR SOURCE PROJECT, 2026\n"
    .. "-- ballast_for_source\n-- File description:\n-- Test.\n--\n\n"
local MODULES = {
    "lines.lua",
    "syntax.lua",
    "blocks.lua",
    "functions.lua",
    "layout.lua",
}

--- Vérifie text et renvoie l'ensemble des règles enfreintes.
local function lint(text)
    local dir = Mock.root .. "tools/style/"
    local file = dofile(dir .. "strip.lua").build("test.lua", text)
    local rules = {}

    for _, name in ipairs(MODULES) do
        dofile(dir .. name).check(file, function(_, rule)
            rules[rule] = true
        end)
    end
    return rules
end

--- Répète count fonctions documentées, nommées par prefix.
local function make_functions(prefix, count)
    local text = ""

    for i = 1, count do
        text = text .. "--- Doc.\n" .. prefix .. i .. "()\nend\n\n"
    end
    return text:sub(1, -2)
end

--- C-F3 : 80 colonnes maximum, comptées en caractères UTF-8.
local function test_width()
    local wide = "-- " .. string.rep("a", 78) .. "\n"
    local accents = "-- " .. string.rep("é", 77) .. "\n"

    Check.truthy(lint(HEADER .. wide)["C-F3"], "81 colonnes")
    Check.truthy(lint(HEADER .. accents)["C-F3"] == nil, "80 accents")
end

Check.case("largeur", test_width)

--- C-G7 et C-L2 : espaces finaux, tabulations et indentation.
local function test_spaces()
    Check.truthy(lint(HEADER .. "local a = 1 \n")["C-G7"], "espace final")
    Check.truthy(lint(HEADER .. "local a = {\n\t1,\n}\n")["C-L2"], "tab")
    Check.truthy(lint(HEADER .. "local a = {\n   1,\n}\n")["C-L2"],
        "3 espaces")
end

Check.case("espaces et indentation", test_spaces)

--- C-G6 : ni \r ni \ en fin de ligne.
local function test_eol()
    Check.truthy(lint(HEADER .. "local a = 1\r\n")["C-G6"], "CRLF")
    Check.truthy(lint(HEADER .. "local a = b \\\n")["C-G6"], "antislash")
end

Check.case("fins de ligne", test_eol)

--- C-G8 et C-G2 : lignes vides en bord de fichier ou en double.
local function test_blank_lines()
    Check.truthy(lint("\n" .. HEADER)["C-G8"], "vide au début")
    Check.truthy(lint(HEADER .. "local a = 1\n\n")["C-G8"], "vide à la fin")
    Check.truthy(lint(HEADER .. "local a = 1\n\n\nlocal b = 2\n")["C-G2"],
        "deux lignes vides")
end

Check.case("lignes vides", test_blank_lines)

--- C-L6 : aucune ligne vide dans le corps, après les déclarations.
local function test_body_blank()
    local body = "--- Doc.\nlocal function f()\n    g()\n\n    h()\nend\n"

    Check.truthy(lint(HEADER .. body)["C-L6"], "ligne vide dans le corps")
end

Check.case("ligne vide dans une fonction", test_body_blank)

--- C-O3 : 10 fonctions nommées par fichier, dont 5 publiques.
local function test_counts()
    local ten = make_functions("local function f", 10)
    local eleven = make_functions("local function f", 11)
    local public = make_functions("function Ballast.f", 6)

    Check.truthy(lint(HEADER .. ten)["C-O3"] == nil, "10 fonctions")
    Check.truthy(lint(HEADER .. eleven)["C-O3"], "11 fonctions")
    Check.truthy(lint(HEADER .. public)["C-O3"], "6 publiques")
end

Check.case("nombre de fonctions", test_counts)

--- C-F2 : snake_case pour le projet, PascalCase libre pour l'API GMod.
local function test_names()
    local camel = "--- Doc.\nfunction Ballast.addJob()\nend\n"
    local gmod = "--- Doc.\nfunction GM:PlayerSpawn()\nend\n"

    Check.truthy(lint(HEADER .. camel)["C-F2"], "camelCase refusé")
    Check.truthy(lint(HEADER .. gmod)["C-F2"] == nil, "API GMod acceptée")
end

Check.case("nommage des fonctions", test_names)
