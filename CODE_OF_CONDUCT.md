# Code de conduite

Ballast for Source est un projet communautaire français créé par
**Laki0s_**. Ce code de conduite s'applique à tous les espaces du projet :
dépôt GitHub, Discord, commentaires Workshop, issues et pull requests.

## 1. Respect et bienveillance

- On critique le code, jamais les personnes. Les retours sont précis,
  argumentés et constructifs.
- Aucune insulte, moquerie, discrimination ni harcèlement, quel qu'en soit
  le motif.
- Les débutants sont les bienvenus : on explique plutôt que de juger.
- Le français est la langue principale du projet ; l'anglais est accepté
  pour que chacun puisse participer.

## 2. Engagements de confiance envers les serveurs

Un addon serveur a un accès total au serveur et aux joueurs. Ballast
s'engage donc à :

- **Aucune backdoor** : aucun accès caché, aucun privilège réservé au
  créateur ou aux contributeurs.
- **Aucun code obfusqué** : tout le code est lisible et vérifiable.
- **Aucune exécution de code distant** : jamais de `RunString` ou de
  `CompileString` sur du contenu téléchargé.
- **Aucune collecte cachée** : les métriques restent sur le serveur ou vont
  uniquement vers l'endpoint configuré par l'administrateur. Aucune donnée
  de joueur (SteamID, IP, chat) n'est envoyée à des tiers.
- **Aucune fonctionnalité cachée** : tout ce que fait l'addon est visible
  dans le panel et le journal.
- **Respect des joueurs** : aucun réglage n'est forcé côté client ; le
  rendu multicœur est proposé, jamais imposé.

## 3. Sécurité et divulgation responsable

- Une faille (exploit net, crash, contournement de droits) se signale
  **en privé** à Laki0s_, jamais publiquement en premier.
- Le mainteneur accuse réception, corrige, puis publie un correctif avec
  crédit au découvreur (s'il le souhaite).
- Il est interdit d'exploiter une faille de Ballast sur un serveur tiers.

## 4. Règles de contribution

- Toute contribution passe par une pull request relue avant fusion.
- Une optimisation doit être **mesurée** : chiffres avant/après (temps de
  frame, mémoire, edicts) dans la description.
- Les conventions de nommage et de code du projet s'appliquent à tous.
- Chaque contributeur est crédité dans [`CREDITS.md`](CREDITS.md).
- Le créateur Laki0s_ reste crédité comme auteur original dans tout fork
  ou redistribution, selon les termes de la licence.

## 5. Modération

Laki0s_ et les modérateurs désignés par le mainteneur font respecter ce
code. Les sanctions sont graduées : rappel à l'ordre, avertissement,
exclusion temporaire, puis exclusion définitive. Un comportement grave
(harcèlement, menaces, diffusion de code malveillant) peut mener
directement à l'exclusion.

## 6. Licence

La licence du projet est dans [`LICENSE`](LICENSE) : l'utilisation sans
modification sur vos propres serveurs est libre, toute modification ou
redistribution (Workshop compris) demande l'accord écrit de Laki0s_, et
l'auteur original est toujours crédité.
