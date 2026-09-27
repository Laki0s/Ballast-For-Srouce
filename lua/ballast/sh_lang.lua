--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Textes affichés, en français par défaut : une autre langue se traduit ici
-- sans toucher au code des modules.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

Ballast.lang = Ballast.lang or {}

--- Formate le texte key de Ballast.lang avec ses arguments.
function Ballast.text(key, ...)
    return string.format(Ballast.lang[key] or key, ...)
end

--- Catégorie du journal pour les actions du profiler.
Ballast.lang.cat_profiler = "Profiler"
