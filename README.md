# pd2-cass
Full streamlining mod of CopActionShoot, spawngroups, difficulty presets and more

# What does it streamline?

## CopActionShoot
- Gives cops linear damage falloff between their entries in the ``FALLOFF`` table instead of sudden drops after a distance threshold is reached
- Removes spread from NPC accuracy calculation as it didn't really affect players anyways and just made NPC vs NPC situations very inconsistent
- Fixes ``acc`` being ignored for single fire weapons in NPC vs NPC situations
- Removes (ignores, to be more accurate) the clunky ``mode`` entry in ``FALLOFF`` that defines how cops shoot their guns and interpolates ``autofire_rounds`` based on distance instead

## Difficulty weapon presets
- Creates weapon presets for all actual difficulties instead of reusing presets (i.e. ``expert`` preset being used on both Overkill and Mayhem)
- Make use of aim delay (which was set to 0 for all presets in vanilla) which affects how long cops take to shoot at you enter their line of sight
- Difficulty presets are based on a common base preset and just scale their damage multiplicators, accuracy, melee damage, focus delay and aim delay

## Spawngroups
- Makes spawngroup code less convoluted, the base spawngroups are the same for every difficulty, only the chances of some of them appearing are changing
- Restores original spawngroups that were disabled by Overkill, adding back shotgunners, flanking squads, Taser rush spawngroups and hostage rescue units
- Tweaks spawngroups and makes them more interesting adding the occasional medic to bulldozer spawns (chance dependent on difficulty) and more

## Cop factions
- Adds missing units to every faction, based on the units present in the GenSec faction (Rifle, Shotgun and SMG unit)
- Adds different weapons for different factions, similar how GenSec uses different weapons
- Maps factions to difficulty properly, Normal and Hard have blue SWAT, Very Hard and Overkill have green SWAT, Mayhem and Deathwish have GenSec SWAT and Death Sentence has Zeals
- Gives heavy shotgunners a unique look to make them more distinct from their rifle counterparts (tbd)

# What else does it do?
- Brings back old cop models from before the enemy visual update (they are just better)