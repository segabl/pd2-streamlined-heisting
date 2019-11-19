# CASS
CASS (CopActionShoot Streamline) is a full streamlining mod that makes a lot of the game's enemy mechanics more consistent. It is intended to build on what I think the vanilla game tried to do rather than being a full rebalance mod that completely changes how the game works and as such won't adds tons of new features and enemies, weapons etc.

## What does it streamline?

### CopActionShoot
- Gives cops linear damage falloff between their entries in the ``FALLOFF`` table instead of sudden drops after a distance threshold is reached
- Removes weapon spread from NPC accuracy calculation as it didn't really affect players anyways and just made NPC vs NPC situations very inconsistent
- Fixes accuracy values being ignored for single fire weapons in NPC vs NPC situations
- Removes (ignores, to be more accurate) the clunky fire mode system which defines how cops shoot their guns and interpolates ``autofire_rounds`` based on distance instead

### Difficulty weapon presets
- Creates weapon presets for all actual difficulties instead of reusing presets (i.e. ``expert`` preset being used on both Overkill and Mayhem)
- Make use of aim delay (which was set to 0 for all presets in vanilla) which affects how long cops take to shoot at you when you enter their line of sight
- Difficulty presets are based on a common base preset and just scale their damage multipliers, accuracy, melee damage, focus delay and aim delay
- Changes shotgun preset significantly, giving them very good accuracy to simulate multiple pellets but very harsh damage falloff.

### Spawn groups
- Makes spawn group code less convoluted, the base spawn groups are the same for every difficulty, only the chances of some of them appearing are changing
- Restores original spawn groups that were disabled by Overkill, adding back shotgunners, flanking squads, Taser rush spawn groups and hostage rescue units
- Adds a chance for SMG units to spawn with Tasers or to occasionally spawn in rifle flanking groups
- Tweaks spawn groups and makes them more interesting adding the occasional medic to bulldozer spawns (chance dependent on difficulty) and more

### Cop factions
- Adds missing units to every faction, based on the units present in the GenSec faction (consisting of a Rifle, Shotgun and SMG unit)
- Adds different weapons for different factions, similar how GenSec uses different weapons
- Maps factions to difficulty properly, Normal and Hard have blue SWAT, Very Hard and Overkill have green SWAT, Mayhem and Deathwish have GenSec SWAT and Death Sentence has Zeals
- Makes shield units use the SMG unit model
- Gives heavy shotgunners a unique look to make them more distinct from their rifle counterparts (TBD)

## What else does it do?
- Brings back old cop models from before the enemy visual update (they are just better)