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

--- Aide des convars d'activation.
Ballast.lang.cvar_profiler = "Active le profiler (temps de frame, pics)"
Ballast.lang.cvar_debug = "Active le profiler de hooks (coûte du CPU)"

--- Journal : pics de lag agrégés sur une seconde.
Ballast.lang.lag_spikes = "%d pic(s) de lag, pire frame : %.1f ms"

--- Journal : activation du profiler de hooks.
Ballast.lang.hooks_on = "Profiler de hooks activé"
Ballast.lang.hooks_off = "Profiler de hooks désactivé"

--- Commande ballast_hooks : classement des hooks les plus coûteux.
Ballast.lang.cmd_hooks = "Affiche les hooks les plus coûteux"
Ballast.lang.hooks_header = "[Ballast] Top %d des hooks par temps total :"
Ballast.lang.hooks_line = "%2d. %s : %.2f ms, %d appels, max %.3f ms, "
    .. "moy. %.3f ms"
Ballast.lang.hooks_empty = "[Ballast] Aucune mesure : ballast_debug 1."
