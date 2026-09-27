--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests : enregistrement des cas et assertions, sans dépendance externe.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local EPSILON = 1e-9

Check = { cases = {} }

--- Enregistre un cas de test du fichier en cours.
function Check.case(name, fn)
    Check.cases[#Check.cases + 1] = { name = name, fn = fn }
end

--- Échoue si actual est différent de expected.
function Check.equal(actual, expected, what)
    if actual ~= expected then
        error(string.format("%s : attendu %s, obtenu %s", what,
            tostring(expected), tostring(actual)), 2)
    end
end

--- Échoue si actual s'écarte de expected de plus d'EPSILON.
function Check.near(actual, expected, what)
    if math.abs(actual - expected) > EPSILON then
        error(string.format("%s : attendu %.9f, obtenu %.9f", what,
            expected, actual), 2)
    end
end

--- Échoue si value est faux ou nil.
function Check.truthy(value, what)
    if not value then
        error(what .. " : valeur fausse", 2)
    end
end
