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
