# Ballast for Source

> *Keep your tick afloat*

Addon de stabilisation et d'optimisation serveur pour **Garry's Mod**,
pensé pour tenir un serveur d'environ 100 joueurs.

Projet français créé et maintenu par **Laki0s_**.

## Principe directeur

Le thread principal est la ressource la plus précieuse du serveur. Chaque
module de l'addon sert soit à **mesurer** ce qui le consomme, soit à le
**protéger**, soit à en **sortir du travail**.

On n'optimise pas ce qu'on ne mesure pas : le premier module est donc le
profiler.

## État du projet

| Module | Rôle | État |
|---|---|---|
| 1. Profiler | Temps de frame, pics de lag, coût des hooks | ✅ Disponible |
| 2. Scheduler | Étaler la charge avec un budget par tick | ⏳ Prévu |
| 3. Net guard | Limiter et valider les messages net | ⏳ Prévu |
| 4. Anti-lag physique | Geler les props sur pic de lag | ⏳ Prévu |
| 5. Edicts et transmission | Budget d'entités, culling | ⏳ Prévu |
| 6. Déport asynchrone | Sortir du thread principal | ⏳ Prévu |
| 8. Côté client | Rendu multicœur proposé au joueur | ⏳ Prévu |
| 9. Monitoring | Métriques vers Prometheus / Grafana | ⏳ Prévu |
| 10. Panel en jeu | État du serveur et journal des actions | ⏳ Prévu |

Le cadrage technique complet est dans
[`docs/`](docs/Ballast_for_Source_Cadrage_Technique%20(1).pdf).

## Installation

1. Copier le dossier du dépôt dans `garrysmod/addons/ballast-for-source/`.
2. Redémarrer le serveur (ou changer de map).
3. Vérifier dans la console serveur : `ballast_status`.

L'addon ne se charge que par `lua/autorun/ballast_init.lua`. Aucun réglage
n'est imposé aux joueurs.

## Convars et commandes

| Nom | Défaut | Effet |
|---|---|---|
| `ballast_profiler` | `1` | Mesure du temps de frame, des pics de lag et de l'état du serveur |
| `ballast_debug` | `0` | Profiler de hooks : mesure le coût de chaque hook (coûte du CPU) |

| Commande | Droits | Effet |
|---|---|---|
| `ballast_status` | console, superadmin | Temps de frame, edicts, joueurs, mémoire Lua |
| `ballast_hooks` | console, superadmin | Classement des hooks les plus coûteux |
| `ballast_hooks_reset` | console, superadmin | Remise à zéro des mesures des hooks |

Le détail du module 1 est dans [`docs/modules/profiler.md`](docs/modules/profiler.md).

## Développement

Le code suit le **coding style Ballast**, adapté de l'Epitech C Coding
Style : voir [`docs/CODING_STYLE.md`](docs/CODING_STYLE.md) et
[`CONTRIBUTING.md`](CONTRIBUTING.md).

```sh
# Coding style Ballast (script maison)
find lua tools tests -name '*.lua' | xargs luajit tools/style_check.lua

# glualint (https://github.com/FPtje/GLuaFixer)
glualint lint --config glualint.json lua tools tests

# Tests, avec l'API GMod simulée
luajit tests/run.lua tests/test_*.lua
```

Les trois vérifications tournent aussi dans la CI GitHub Actions.

## Licence

Tous droits réservés : voir [`LICENSE`](LICENSE). L'utilisation sans
modification sur vos propres serveurs est autorisée ; toute modification ou
redistribution demande l'accord écrit de Laki0s_, qui reste crédité comme
auteur original.
