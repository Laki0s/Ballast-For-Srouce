--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Point d'entrée unique : table racine puis chargement des fichiers par réalm.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local FOLDER = "ballast/"

if SERVER then
    AddCSLuaFile()
end
Ballast = Ballast or {}
Ballast.name = "Ballast for Source"
Ballast.slogan = "Keep your tick afloat"
Ballast.version = "0.1.0"
Ballast.author = "Laki0s_"
Ballast.original = Ballast.original or {}
