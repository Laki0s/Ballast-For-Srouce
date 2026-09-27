# Coding style Ballast

Ballast adopte l'**Epitech C Coding Style (v8)** comme base, pour le C++
comme pour le Lua. Chaque règle garde son code d'origine (C-O1, C-F4...),
puis est adaptée au langage. Face à un choix, on prend l'option qui rend le
code **plus clair, plus ergonomique et plus flexible**.

Le style reste une convention de forme : il ne remplace jamais un code qui
fonctionne et qui est mesuré.

## Niveaux de gravité

| Niveau | Signification |
|---|---|
| **Fatale** | Touche à la nature du projet ou à la sécurité des serveurs : contribution refusée sans relecture. |
| **Majeure** | Touche à la structure du code : correction obligatoire avant fusion. |
| **Mineure** | Touche à la présentation : à corriger ; des infractions répétées bloquent la fusion. |
| **Info** | Bonne pratique attendue. |

Toute tentative de contourner le style (règle découpée artificiellement,
vérification désactivée) entraîne le refus de la contribution.

## En-tête de fichier (C-G1)

```lua
--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Module 3 (Net Guard) : limite et valide les messages net entrants.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--
```

En C++, le même contenu dans un bloc `/* ** */`.

## C-O : organisation des fichiers

| Règle | Gravité | C++ | Lua |
|---|---|---|---|
| C-O1 Contenu du dépôt | Majeure | Aucun binaire ni `build/` | Aucun fichier temporaire ; `.gitignore` obligatoire |
| C-O2 Extensions | Majeure | `.cpp` et `.hpp` | `.lua` |
| C-O3 Cohérence | Majeure | 10 fonctions max, dont 5 non-`static` | 10 fonctions max, dont 5 publiques, les autres en `local function` |
| C-O4 Nommage | Mineure | snake_case explicite | snake_case avec préfixe de réalm (`sv_net_guard.lua`) |
