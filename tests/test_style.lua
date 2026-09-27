--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests du vérificateur de style : chaque règle détecte son infraction et
-- un code conforme passe sans remarque.
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

--- Un fichier conforme ne déclenche aucune règle.
local function test_clean()
    local rules = lint(HEADER .. "--- Double a.\nlocal function double(a)\n"
        .. "    local b = a * 2\n\n    return b\nend\n")

    Check.equal(next(rules), nil, "première règle enfreinte")
end

Check.case("code conforme", test_clean)

--- Les opérateurs GMod et goto sont refusés.
local function test_gmod_syntax()
    Check.truthy(lint(HEADER .. "local a = b != c\n")["C-G"], "!=")
    Check.truthy(lint(HEADER .. "local a = b && c\n")["C-G"], "&&")
    Check.truthy(lint(HEADER .. "local a = not b\n")["C-G"] == nil, "not")
    Check.truthy(lint(HEADER .. "goto fin\n")["C-C3"], "goto")
end

Check.case("syntaxe GMod", test_gmod_syntax)

--- Une ligne ne porte qu'une instruction.
local function test_compact()
    Check.truthy(lint(HEADER .. "if a then return end\n")["C-L1"], "if")
    Check.truthy(lint(HEADER .. "a, b = 1, 2\n")["C-L1"], "affectation")
    Check.truthy(lint(HEADER .. "local a = \"x then y\"\n")["C-L1"] == nil,
        "then dans une chaîne")
end

Check.case("instructions compactes", test_compact)

--- Corps de plus de 20 lignes et plus de 4 paramètres.
local function test_function_size()
    local long = "--- Long.\nlocal function f()\n"
        .. string.rep("    g()\n", 21) .. "end\n"
    local wide = "--- Large.\nlocal function f(a, b, c, d, e)\nend\n"

    Check.truthy(lint(HEADER .. long)["C-F4"], "21 lignes")
    Check.truthy(lint(HEADER .. wide)["C-F5"], "5 paramètres")
end

Check.case("taille des fonctions", test_function_size)

--- Trois niveaux d'imbrication sont refusés, deux sont acceptés.
local function test_depth()
    local two = "--- Deux.\nlocal function f()\n    if a then\n"
        .. "        if b then\n            g()\n        end\n    end\nend\n"
    local three = "--- Trois.\nlocal function f()\n    for i = 1, 2 do\n"
        .. "        if a then\n            if b then\n                g()\n"
        .. "            end\n        end\n    end\nend\n"

    Check.truthy(lint(HEADER .. two)["C-C1"] == nil, "profondeur 2")
    Check.truthy(lint(HEADER .. three)["C-C1"], "profondeur 3")
end

Check.case("imbrication", test_depth)

--- Déclarations en tête, suivies d'une seule ligne vide.
local function test_declarations()
    local late = "--- Tard.\nlocal function f()\n    g()\n"
        .. "    local a = 1\nend\n"
    local glued = "--- Collé.\nlocal function f()\n    local a = 1\n"
        .. "    g(a)\nend\n"

    Check.truthy(lint(HEADER .. late)["C-L5"], "local après instruction")
    Check.truthy(lint(HEADER .. glued)["C-L6"], "ligne vide manquante")
end

Check.case("déclarations", test_declarations)

--- Commentaire --- obligatoire au-dessus, interdit à l'intérieur.
local function test_comments()
    local missing = "local function f()\n    g()\nend\n"
    local inner = "--- Doc.\nlocal function f()\n    -- non\n    g()\nend\n"

    Check.truthy(lint(HEADER .. missing)["C-F8"], "commentaire manquant")
    Check.truthy(lint(HEADER .. inner)["C-F8"], "commentaire interne")
end

Check.case("commentaires", test_comments)

--- En-tête du projet et code dynamique (règle fatale).
local function test_header_and_dynamic()
    Check.truthy(lint("local a = 1\n")["C-G1"], "en-tête absent")
    Check.truthy(lint(HEADER .. "RunString(code)\n")["C-G10"], "RunString")
    Check.truthy(lint(HEADER .. "local a = 1")["C-A3"], "saut final")
end

Check.case("en-tête et code dynamique", test_header_and_dynamic)
