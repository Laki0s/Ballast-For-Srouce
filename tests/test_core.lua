--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests du socle : table racine, chargement, compteurs, journal, textes
-- et convars.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local LOG_MAX = 100

--- La table racine porte l'identité du projet.
local function test_identity()
    Check.equal(Ballast.name, "Ballast for Source", "nom")
    Check.equal(Ballast.slogan, "Keep your tick afloat", "slogan")
    Check.equal(Ballast.version, "0.1.0", "version")
    Check.equal(Ballast.author, "Laki0s_", "auteur")
end

Check.case("identité", test_identity)

--- Tous les fichiers sont chargés et les partagés envoyés aux clients.
local function test_loading()
    Check.truthy(Ballast.config, "configuration")
    Check.truthy(Ballast.lang, "textes")
    Check.truthy(Ballast.log, "journal")
    Check.truthy(Ballast.get_top_hooks, "profiler")
    Check.equal(Mock.sent[2], "ballast/sh_config.lua", "envoi de sh_config")
    Check.equal(#Mock.sent, 3, "fichiers envoyés (autorun + 2 partagés)")
end

Check.case("chargement", test_loading)

--- Les compteurs cumulent 1 par défaut ou n.
local function test_count()
    Ballast.count("test")
    Ballast.count("test", 4)
    Check.equal(Ballast.stats.test, 5, "compteur")
end

Check.case("compteurs", test_count)

--- Le journal garde les entrées récentes en tête et reste borné.
local function test_log()
    for i = 1, LOG_MAX + 50 do
        Ballast.log("Test", tostring(i))
    end
    Check.equal(#Ballast.logs, LOG_MAX, "taille du journal")
    Check.equal(Ballast.logs[1].msg, tostring(LOG_MAX + 50), "plus récente")
    Check.equal(Ballast.logs[1].cat, "Test", "catégorie")
end

Check.case("journal borné", test_log)

--- Le journal n'écrit dans la console qu'en mode debug.
local function test_log_echo()
    Ballast.log("Test", "silencieux")
    Check.equal(#Mock.output, 0, "console hors debug")
    Ballast.config.debug = true
    Ballast.log("Test", "visible")
    Check.equal(Mock.output[1], "[Ballast] Test : visible", "console")
end

Check.case("journal en console", test_log_echo)

--- Ballast.text formate les textes, et renvoie la clé inconnue telle quelle.
local function test_text()
    Check.equal(Ballast.text("lag_spikes", 2, 75),
        "2 pic(s) de lag, pire frame : 75.0 ms", "texte formaté")
    Check.equal(Ballast.text("inconnu"), "inconnu", "clé inconnue")
end

Check.case("textes", test_text)

--- watch_convar prévient tout de suite puis à chaque changement.
local function test_convar()
    local seen = {}

    Ballast.add_convar("test", "0", "aide")
    Ballast.watch_convar("test", "Test", function(enabled)
        seen[#seen + 1] = enabled
    end)
    Mock.set_convar("ballast_test", "1")
    Check.equal(seen[1], false, "valeur initiale")
    Check.equal(seen[2], true, "après changement")
end

Check.case("convars", test_convar)
