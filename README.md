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
