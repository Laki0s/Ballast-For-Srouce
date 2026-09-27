# Module 1 : mesurer (le profiler)

On n'optimise pas ce qu'on ne mesure pas. Le profiler est le premier module
de Ballast : sans lui, tous les autres travaillent à l'aveugle.

| Fichier | Rôle |
|---|---|
| `lua/ballast/sv_profiler.lua` | Temps de frame, pics de lag, moyenne et maximum par seconde |
| `lua/ballast/sv_profiler_server.lua` | Edicts, joueurs et mémoire Lua |
| `lua/ballast/sv_profiler_hooks.lua` | Coût de chaque hook (mode debug) |
| `lua/ballast/sv_profiler_report.lua` | Classement des hooks et commandes console |

## Temps de frame et pics de lag

Le hook `Think` `Ballast_FrameTime` mesure avec `SysTime()` le temps écoulé
depuis la frame précédente, dans `Ballast.frame_time`.

- Budget du tick : `Ballast.frame_budget = engine.TickInterval()`, soit
  ~30 ms à 33 ticks et ~15 ms à 66 ticks.
- **Pic de lag** : une frame dépasse `spike_factor × TickInterval`
  (2 par défaut). Le hook `Ballast_LagSpike` est alors appelé avec la durée
  de la frame : c'est le déclencheur des modules physique et scheduler.
- Une frame de plus de `pause_limit` secondes (10 par défaut) est une pause
  du serveur (hibernation sans joueur), pas un pic : elle est ignorée.

```lua
hook.Add("Ballast_LagSpike", "MonAddon_Reaction", function(frame_time)
    print("Pic de lag : " .. math.Round(frame_time * 1000) .. " ms")
end)
```

## Moyenne et maximum par seconde

Le timer `Ballast_FrameStats` publie chaque seconde :

- `Ballast.frame_avg` et `Ballast.frame_max` : moyenne et pic de la
  seconde écoulée ;
- `Ballast.history` : les 60 dernières moyennes (`history_size`), pour le
  graphe du futur panel.

Les pics d'une même seconde tiennent sur **une seule ligne** du journal
(`Ballast.log`), et le compteur `lag_spikes` les cumule depuis le
démarrage.

## Edicts, joueurs et mémoire

Le timer `Ballast_ServerStats` remplit `Ballast.server` chaque seconde :
`edicts` (`ents.GetEdictCount()`), `players` (`player.GetCount()`) et
`memory` (`collectgarbage("count")`, en Ko), chacun avec son maximum
(`edicts_max`...).

## Coût de chaque hook (mode debug)

Avec `ballast_debug 1`, `hook.Add` est remplacé par une version qui
enveloppe chaque fonction et mesure son temps avec `SysTime()` dans
`Ballast.hook_stats["Evenement/identifiant"]` (`total`, `calls`, `max`).
On obtient un classement du type « le hook Think de tel addon coûte 4 ms ».

- Les hooks déjà enregistrés sont enveloppés à l'activation : l'ordre de
  chargement des addons n'a pas d'importance.
- `ballast_debug 0` rend le `hook.Add` d'origine (gardé dans
  `Ballast.original.hook_add`) et la fonction d'origine de chaque hook.
- `hook.Remove` reste compatible : l'identifiant ne change pas.
- Les résultats des hooks sont rendus intacts, `nil` compris.
- Les temps sont **inclusifs** : un hook qui en déclenche un autre compte
  aussi le temps de ce dernier.

L'instrumentation a elle-même un coût : elle ne tourne qu'en mode debug.
FProfiler reste la référence pour une analyse plus fine.

## Convars et commandes

| Nom | Défaut | Effet |
|---|---|---|
| `ballast_profiler` | `1` | Temps de frame, pics de lag et état du serveur |
| `ballast_debug` | `0` | Profiler de hooks et recopie du journal en console |
| `ballast_status` | | Frame (moyenne, max, budget), edicts, joueurs, mémoire, pics |
| `ballast_hooks` | | Les `top_hooks` (10) hooks les plus coûteux |
| `ballast_hooks_reset` | | Remet à zéro les mesures des hooks |

Les commandes sont réservées à la console serveur et aux superadmins.

## Mesurer avant/après

Chaque module doit documenter son effet mesuré. Protocole avec le
profiler :

1. Laisser tourner le serveur 10 minutes en charge normale.
2. Relever `ballast_status` (moyenne, max, pics) et, en mode debug,
   `ballast_hooks`.
3. Activer ou désactiver le module testé par sa convar, puis refaire la
   même mesure dans les mêmes conditions.
4. Reporter les deux séries de chiffres dans la pull request et dans le
   `CHANGELOG.md`.

Coût du profiler lui-même : un hook `Think` sans allocation et deux timers
à 1 Hz. Le profiler de hooks ajoute deux appels à `SysTime()` par appel de
hook : ne l'activer que le temps d'une analyse.
