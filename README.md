# Streamlined Heisting

Streamlined Heisting is a full streamlining mod that makes a lot of the game's enemy mechanics more consistent. It is intended to build on what I think the vanilla game tried to do rather than being a full rebalance mod that completely changes how the game works and as such won't adds tons of new features and enemies, weapons etc.

## What it does

### Improves CopActionShoot

- Gives cops linear damage falloff between their entries in the ``FALLOFF`` table instead of sudden drops after a distance threshold is reached
- Removes weapon spread from NPC accuracy calculation as it didn't really affect players anyways and just made NPC vs NPC situations very inconsistent
- Fixes accuracy values being ignored for single fire weapons in NPC vs NPC situations
- Removes (ignores, to be more accurate) the clunky fire mode system which defines how cops shoot their guns and interpolates ``autofire_rounds`` based on distance instead
- Properly implements ``aim_delay`` and ``focus_delay`` handling, the vanilla code barely worked (and only for players)

### Standardizes difficulty weapon presets

- Creates weapon presets based on the current difficulty instead of reusing presets (i.e. ``expert`` preset being used on both Overkill and Mayhem)
- Uses only one base preset which scales damage multipliers, accuracy, melee damage, focus delay and aim delay based on difficulty
- Make use of aim and focus delays (which was set to 0 for all presets in vanilla) which affects how long cops take to shoot at you and reach their full accuracy when you enter their line of sight
- Changes shotgun preset significantly, giving them very good accuracy to simulate multiple pellets but very harsh damage falloff

### Overhauls spawn groups

- Makes spawn group code less convoluted, the base spawn groups are the same for every difficulty, only the chances of some of them appearing are changing
- Restores original spawn groups that were disabled by Overkill, adding back shotgunners, flanking squads, Taser rush spawn groups and hostage rescue units
- Adds a chance for SMG units to spawn with Tasers or to occasionally spawn in rifle flanking groups
- Tweaks spawn groups and makes them more interesting adding the occasional medic to bulldozer spawns (chance dependent on difficulty) and more

### Standardizes cop factions

- Adds missing units to every faction, based on the units present in the GenSec faction (consisting of a Rifle, Shotgun and SMG unit)
- Adds different weapons for different factions, similar how GenSec uses different weapons
- Adds armor plates to the heavy SWAT on Normal and Hard, to be in line with the heavy SWATs on other difficulties
- Gives heavy shotgunners the helmet treatment of the light shotgunners to make them more distinct from their rifle counterparts
- Replaces the lazy recolors for Mexican police with slightly less lazy recolors and less seen cop models

### Improves the difficulty curve
- Adds proper difficulty scaling such that every difficulty feels different from the previous one instead of either barely a change or an extreme change
- Gives custom min damage intervals (I-frames) to players scaling with difficulty (the default one of .45 on Overkill scaling down to the min .35 on DS)

## Other things it does

- Makes shield units use the SMG unit model
- Removes all but light, fire and poison hurt animations from heavy SWAT but scales their damage lower than their light counterparts
- Improves the surrender presets, different enemies have different chances to surrender
