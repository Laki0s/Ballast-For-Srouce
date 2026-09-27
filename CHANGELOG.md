# Changelog

Toutes les évolutions notables de Ballast for Source sont notées ici.
Le format suit [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/) et
le projet respecte le [versionnage sémantique](https://semver.org/lang/fr/).
Chaque version publiée indique les gains mesurés quand il y en a.

## [Non publié]

### Ajouté

- Structure du dépôt, conventions et coding style Ballast.
- Point d'entrée unique `lua/autorun/ballast_init.lua` et chargement par réalm.
- Configuration partagée `sh_config.lua` et textes centralisés `sh_lang.lua`.
- Compteurs cumulés (`Ballast.count`) et journal borné (`Ballast.log`).
- Module 1 (profiler) : temps de frame, pics de lag (`Ballast_LagSpike`),
  moyenne et maximum par seconde, historique de 60 secondes.
- Module 1 : edicts, joueurs et mémoire Lua avec leur maximum.
- Module 1 : profiler de hooks en mode debug (`ballast_debug 1`).
- Commandes `ballast_status`, `ballast_hooks` et `ballast_hooks_reset`.
- Vérificateur de style `tools/style_check.lua`, tests avec l'API GMod
  simulée et CI GitHub Actions.
