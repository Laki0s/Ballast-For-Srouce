--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Configuration partagée : seuils et réglages de chaque module.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

Ballast.config = Ballast.config or {}

--- Module 2 : 2 ms de jobs maximum par tick (conseillé : 1 à 3 ms).
Ballast.config.job_budget = 0.002

--- Module 5 : refus des spawns au-delà (limite du moteur : 8192).
Ballast.config.edict_limit = 7500

--- Module 3 : taille maximale d'un message net entrant, en bits.
Ballast.config.net_max_bits = 64 * 1024 * 8

--- Module 3 : messages par seconde et par joueur, par nom de message.
--- Exemple : Ballast.config.net_limits["mon_message"] = 10
Ballast.config.net_limits = {}

--- Module 3 : limite par défaut des messages absents de net_limits.
Ballast.config.net_default = 30

--- Module 1 : pic de lag quand une frame dépasse spike_factor ticks.
Ballast.config.spike_factor = 2

--- Module 1 : au-delà (en secondes), une frame est une pause du serveur
--- (hibernation sans joueur) et non un pic de lag.
Ballast.config.pause_limit = 10

--- Module 1 : nombre de moyennes conservées pour le graphe (60 s).
Ballast.config.history_size = 60

--- Module 1 : intervalle d'agrégation des mesures, en secondes.
Ballast.config.stats_interval = 1
