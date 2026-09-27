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

--- Renvoie le préfixe de réalm d'un fichier : sv_, cl_ ou sh_.
local function get_realm(name)
    return string.sub(name, 1, 3)
end

--- Envoie un fichier aux clients s'il doit y être exécuté.
local function send_file(name, realm)
    if realm ~= "sv_" then
        AddCSLuaFile(FOLDER .. name)
    end
end

--- Indique si un fichier de ce réalm s'exécute ici.
local function should_run(realm)
    if realm == "sh_" then
        return true
    end
    if realm == "sv_" then
        return SERVER == true
    end
    return CLIENT == true
end

--- Charge un fichier du dossier ballast/ selon son préfixe de réalm.
local function load_file(name)
    local realm = get_realm(name)

    if SERVER then
        send_file(name, realm)
    end
    if should_run(realm) then
        include(FOLDER .. name)
    end
end

load_file("sh_config.lua")
load_file("sh_lang.lua")
load_file("sv_convars.lua")
load_file("sv_panel.lua")
load_file("sv_profiler.lua")
load_file("sv_profiler_server.lua")
load_file("sv_profiler_hooks.lua")
