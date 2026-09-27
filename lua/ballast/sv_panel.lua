--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Module 10 (Panel), étape 1 : compteurs cumulés et journal circulaire,
-- communs à tous les modules. L'interface arrivera avec le module 10.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local LOG_MAX = 100

Ballast.stats = Ballast.stats or {}
Ballast.logs = Ballast.logs or {}

--- Ajoute n (1 par défaut) au compteur cumulé key.
function Ballast.count(key, n)
    Ballast.stats[key] = (Ballast.stats[key] or 0) + (n or 1)
end
