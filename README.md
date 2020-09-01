# Streamlined Heisting

Streamlined Heisting is a full streamlining mod that makes a lot of the game's enemy mechanics more consistent. It is intended to build on what I think the vanilla game tried to do rather than being a full rebalance mod that completely changes how the game works and as such won't adds tons of new features and enemies, weapons etc.

## What it does

### Improves CopActionShoot

- Gives cops linear damage falloff between their entries in the ``FALLOFF`` table instead of sudden drops after a distance threshold is reached
- Removes weapon spread from NPC accuracy calculation as it didn't really affect players anyways and just made NPC vs NPC situations very inconsistent
- Fixes accuracy values being ignored for single fire weapons in NPC vs NPC situations
- Simplifies the clunky fire mode system which defines how cops shoot their guns and interpolates ``autofire_rounds`` based on distance instead (enemies will utilize full auto more)
- Properly implements and makes use of ``aim_delay``, enemies will now take time to aim at their target before shooting (depends on distance and difficulty)
- Fixes barely working ``focus_delay`` code, enemies will take some time to reach their maximum accuracy when shooting (depends on difficulty)

### Standardizes difficulty weapon presets

- Creates weapon presets based on the current difficulty instead of reusing presets (i.e. ``expert`` preset being used on both Overkill and Mayhem)
- Uses only one base preset which scales damage multipliers, accuracy, melee damage, focus delay and aim delay based on difficulty
- Make use of aim and focus delays (which was set to 0 for all presets in vanilla) which affects how long cops take to shoot at you and reach their full accuracy when you enter their line of sight
- Changes shotgun preset significantly, giving them very good accuracy to simulate multiple pellets but very harsh damage falloff
- Changes cop weapon stats to be consistent across their class (on the same difficulty a JP36 will perform the same as an Car-4, the damage increase comes from higher difficulty, not the weapon)

### Overhauls spawn groups

- Makes spawn group code less convoluted, the base spawn groups are the same for every difficulty, only the chances of some of them appearing are changing
- Restores original spawn groups that were disabled by Overkill, adding back shotgunners, flanking squads, Taser rush spawn groups and hostage rescue units
- Tweaks spawn groups and makes them more interesting adding the occasional medic to bulldozer spawns (chance dependent on difficulty) and more

### Standardizes cop factions

- Adds different weapons for different factions, similar how GenSec uses different weapons
- Adds armor plates to the heavy SWAT on Normal and Hard, to be in line with the heavy SWATs on other difficulties
- Gives heavy shotgunners the helmet treatment of the light shotgunners to make them more distinct from their rifle counterparts
- Replaces the lazy recolors for Mexican police with slightly less lazy recolors and less seen cop models

### Improves the difficulty curve

- Adds proper difficulty scaling such that every difficulty feels different from the previous one instead of either barely a change or an extreme change
- Gives custom grace period times (I-frames) to players scaling with difficulty (every difficulty has its own grace period time, down to 0.2s on DS)
- Reduces the amount of cops on DS to normal levels, the added missing shotgunners and SMG units as well as lower grace period time will keep DS difficult

## Other things it does

- Removes all but light, fire and poison hurt animations from heavy SWAT but scales their damage lower than their light counterparts
- Improves the surrender presets, different enemies have different chances to surrender
