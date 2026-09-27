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

## C-G : portée globale

| Règle | Gravité | Lua |
|---|---|---|
| Extensions de langage | Majeure | Pas de `!=`, `!`, `&&`, `\|\|`, `//`, `/* */` ni `continue` |
| C-G1 En-tête | Mineure | Bloc `--` au format du projet |
| C-G2 Séparation | Mineure | Une seule ligne vide entre deux fonctions |
| C-G4 Globales | Majeure | Seules `Ballast` et `BallastNative` ; le reste est `local` |
| C-G5 include | Majeure | `include()` et `AddCSLuaFile()` de fichiers du projet uniquement |
| C-G6 Fins de ligne | Mineure | LF uniquement, imposé par `.gitattributes` |
| C-G7 Espaces finaux | Mineure | Aucun |
| C-G8 Lignes vides | Mineure | Aucune au début, une au maximum à la fin |
| C-G9 Constantes | Mineure | Dans `Ballast.config` ou en `local` UPPER_SNAKE_CASE |
| C-G10 Code dynamique | **Fatale** | Ni `RunString`, ni `CompileString`, ni contenu téléchargé |

## C-F : fonctions

| Règle | Gravité | Lua |
|---|---|---|
| C-F1 Cohérence | Mineure | Une fonction fait une seule chose ; un hook appelle des fonctions nommées |
| C-F2 Nommage | Mineure | snake_case anglais avec un verbe (`Ballast.add_job`) |
| C-F3 Largeur | Majeure | 80 colonnes maximum |
| C-F4 Longueur | Majeure | Corps de 20 lignes maximum, fonctions anonymes comprises |
| C-F5 Paramètres | Majeure | 4 maximum ; au-delà, passer une table (`...` compte) |
| C-F7 Structures | Majeure | Les tables sont passées par référence : ne pas les copier |
| C-F8 Commentaires | Mineure | Aucun dans une fonction ; un `---` au-dessus |

## C-L : mise en page dans une fonction

| Règle | Gravité | Lua |
|---|---|---|
| C-L1 Une instruction par ligne | Majeure | Pas de `a, b = 1, 2`, pas de `if x then return end` sur une ligne |
| C-L2 Indentation | Mineure | 4 espaces, aucune tabulation |
| C-L3 Espaces | Mineure | Un espace après la virgule et autour des opérateurs, `..` et `=` compris |
| C-L4 Blocs | Mineure | `then` et `do` en fin de ligne ; `end`, `else`, `elseif` en début de ligne |
| C-L5 Déclarations | Majeure | Tous les `local` au début de la fonction, un par ligne |
| C-L6 Lignes vides | Mineure | Une ligne vide après les déclarations, aucune autre |

## C-V, C-C, C-H et C-A

| Règle | Gravité | Lua |
|---|---|---|
| C-V1 Identifiants | Mineure | snake_case ; constantes en UPPER_SNAKE_CASE ; API GMod en PascalCase |
| C-V2 Structures | Majeure | Tables séparées (`Ballast.config`, `Ballast.stats`) plutôt qu'une table fourre-tout |
| C-C1 Imbrication | Majeure | Profondeur de 3 ou plus interdite ; un `elseif` compte un niveau de plus |
| C-C2 Ternaires | Majeure | `a and b or c` simple, jamais imbriqué ; échoue si `b` vaut `false` ou `nil` |
| C-C3 goto | Majeure | Interdit, comme `continue` |
| C-H1 Contenu | Majeure | `sh_config.lua` ne contient que de la configuration, aucune logique |
| C-A1 Constance | Info | Une fonction ne modifie une table reçue que si son nom l'indique |
| C-A3 Saut final | Info | Obligatoire |
| C-A4 static | Info | `local` pour tout ce qui ne sort pas du fichier |

## Outils

| Outil | Vérifie |
|---|---|
| [glualint](https://github.com/FPtje/GLuaFixer) (`glualint.json`) | Espaces, syntaxe GMod, variables inutilisées, largeur |
| `tools/style_check.lua` | En-tête, largeur, fins de ligne, syntaxe GMod, code dynamique, C-L1, C-C1, C-C3, C-F2/F4/F5/F8, C-O3, C-L5/L6 |
| clang-format (`native/.clang-format`) | Mise en page du C++ |
| Relecture humaine | Cohérence (C-F1), nommage explicite (C-F2), taille des structures (C-V2) |

```sh
find lua tools tests -name '*.lua' | xargs luajit tools/style_check.lua
```

Le script compte les fonctions **nommées** pour C-O3 ; les fonctions
anonymes des hooks restent soumises à C-F4 et C-L5/L6.
