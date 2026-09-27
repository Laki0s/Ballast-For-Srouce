--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Vérificateur de style : syntaxe GMod non standard, code dynamique,
-- instructions compactes et affectations multiples.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local M = {}

--- C-G : opérateurs propres à GMod, avec leur équivalent Lua.
local OPERATORS = {
    { "!=", "!= interdit : écrire ~=" },
    { "![^=]", "! interdit : écrire not" },
    { "!$", "! interdit : écrire not" },
    { "&&", "&& interdit : écrire and" },
    { "||", "|| interdit : écrire or" },
    { "//", "// interdit : écrire --" },
    { "/%*", "/* */ interdit : écrire --[[ ]]" },
}

--- C-C3 : ni goto ni continue.
local JUMPS = {
    { "%f[%w_]goto%f[^%w_]", "goto interdit" },
    { "%f[%w_]continue%f[^%w_]", "continue interdit" },
}

--- C-G10 (fatale) : aucune exécution de code dynamique.
local DYNAMIC = {
    { "%f[%w_]RunString%f[^%w_]", "RunString interdit (fatal)" },
    { "%f[%w_]RunStringEx%f[^%w_]", "RunStringEx interdit (fatal)" },
    { "%f[%w_]CompileString%f[^%w_]", "CompileString interdit (fatal)" },
    { "%f[%w_]CompileFile%f[^%w_]", "CompileFile interdit (fatal)" },
    { "%f[%w_]loadstring%f[^%w_]", "loadstring interdit (fatal)" },
}

--- C-L1 : une instruction par ligne, aucune affectation multiple.
local COMPACT = {
    { "%f[%w_]then%s+%S", "instruction après then" },
    { "%f[%w_]do%s+%S", "instruction après do" },
    { "%f[%w_]else%s+%S", "instruction après else" },
    { "%f[%w_]end%s+[%w_]", "instruction après end" },
    { "%f[%w_]function%s*[%w_%.:]*%s*%b()%s*[^%s%)]", "corps sur la ligne" },
    { ";", "point-virgule : une instruction par ligne" },
    { "^%s*[%w_%.%[%]]+%s*,[^=]*[^=~<>]=[^=]", "affectation multiple" },
}
