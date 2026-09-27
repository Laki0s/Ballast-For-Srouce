# Contribuer à Ballast for Source

Merci de votre intérêt ! Ce guide résume ce qu'une pull request doit
respecter pour être fusionnée. Le [code de conduite](CODE_OF_CONDUCT.md)
s'applique à tous les échanges.

## Noms et préfixes

Un nom unique et des préfixes cohérents évitent les conflits avec les
autres addons.

| Élément | Convention | Exemple |
|---|---|---|
| Namespace Lua | une seule table globale : `Ballast` | `Ballast.log(...)` |
| Module C++ | table globale séparée `BallastNative` | `BallastNative.submit(...)` |
| Dossier Lua | `lua/ballast/` + préfixe de réalm | `lua/ballast/sv_profiler.lua` |
| Autorun | un seul point d'entrée | `lua/autorun/ballast_init.lua` |
| Hooks | `Ballast_` + rôle ou événement | `Ballast_FrameTime`, `Ballast_LagSpike` |
| Messages net | `Ballast_` + action | `Ballast_Sub`, `Ballast_Data` |
| Timers | `Ballast_` + rôle | `Ballast_FrameStats` |
| Convars | `ballast_` en minuscules | `ballast_profiler 1`, `ballast_debug 0` |
| Fonctions, variables | snake_case anglais, verbe pour les fonctions | `Ballast.get_top_hooks`, `frame_time` |
| Constantes | UPPER_SNAKE_CASE | `LOG_MAX` |
| Clés de stats | snake_case anglais | `lag_spikes` |
| Fichiers de données | `data/ballast/` | `data/ballast/stats.json` |

## Règles de code

- Tout le code suit le **coding style Ballast** :
  [`docs/CODING_STYLE.md`](docs/CODING_STYLE.md).
- Identifiants en anglais et en snake_case ; commentaires, documentation et
  messages de commit en français.
- Les textes affichés aux joueurs sont en français, centralisés dans
  `Ballast.lang` (`lua/ballast/sh_lang.lua`).
- Une fonction de GMod remplacée (`hook.Add`, `net.Incoming`...) est
  toujours conservée dans `Ballast.original`, avec un retour en arrière
  quand le module est désactivé.
- Chaque module a une convar d'activation, appelle `Ballast.count` et
  `Ballast.log`, et documente une mesure avant/après.
- Dans les hooks fréquents, les micro-optimisations LuaJIT (globales
  localisées, aucune allocation dans `Think`...) sont obligatoires.

## Git

- Branches : `main` (versions publiées, stables) et `dev` (développement) ;
  une branche par fonctionnalité (`feat/panel-modules`).
- Commits au format [Conventional Commits](https://www.conventionalcommits.org/fr/),
  rédigés en français : `feat(netguard): limite par message`,
  `fix(panel): graphe vide au démarrage`, `perf(scheduler): budget adaptatif`.
- Chaque version publiée a son entrée dans [`CHANGELOG.md`](CHANGELOG.md),
  avec les gains mesurés quand il y en a.

## Avant d'ouvrir une pull request

```sh
find lua tools tests -name '*.lua' | xargs luajit tools/style_check.lua
glualint lint --config glualint.json lua tools tests
luajit tests/run.lua tests/test_*.lua
```

Les trois commandes doivent passer sans erreur ; la CI les relance sur
chaque pull request. Joignez à la description les chiffres avant/après
(temps de frame, mémoire, edicts) de toute optimisation.
