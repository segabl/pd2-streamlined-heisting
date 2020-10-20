# Streamlined Heisting

Streamlined Heisting is a full streamlining mod that makes a lot of the game's enemy mechanics more consistent. It is intended to build on what I think the vanilla game tried to do rather than being a full rebalance mod that completely changes how the game works and as such won't adds tons of new features and enemies, weapons etc.
The changes this mod makes are not intended to make the game feel drastically different but to make it more consistent and replace some of the very outdated code with something that actually works and makes more sense. A lot of features that the vanilla game had at some point were broken or disabled with game updates and have been fixed or re-enabled.

## What it does

### Improves CopActionShoot

``CopActionShoot`` is the main class that handles how cops fire their guns. This class is an ancient construct and was in dire need of an upgrade to how it works. Features like aim delay and focus delay did not work at all or not as intended. Bugs in these implementations have been fixed and damage and falloff calculation has been changed to a more modern system.

- Gives cops linear damage falloff instead of sudden drops after a distance threshold is reached
- Removes weapon spread from NPC accuracy calculation as it didn't really affect players and just made NPC vs NPC situations very inconsistent
- Fixes accuracy values being ignored for single fire weapons in NPC vs NPC situations
- Simplifies the clunky fire mode system and interpolates ``autofire_rounds`` based on distance instead (enemies will utilize full auto more)
- Properly implements and makes use of ``aim_delay``, enemies will now take time to aim at their target before shooting (depends on distance and difficulty)
- Fixes barely working ``focus_delay`` code, enemies will take some time to reach their maximum accuracy when shooting (depends on difficulty)

### Standardizes weapon presets

In vanilla there are multiple weapon base presets that are used by most enemies. These presets are assigned based on difficulty, but there is not one preset for every difficulty. Some difficulties are sharing presets which are then further manipulated in different functions which leads to a lot of oversights and inconsistencies.
The preset system has been improved by creating a single difficulty based preset and setting all the relevant values directly, this preset is then used as the base for a few others. Changing preset values at times other than when they are created is avoided.

- Creates and uses a base weapon preset which scales damage multipliers, accuracy, melee damage, focus delay and aim delay based on difficulty
- Make use of aim and focus delays (which was set to 0 for all presets in vanilla) which affects how long cops take to shoot at you and reach their full accuracy when you enter their line of sight
- Changes shotgun preset significantly, giving them very good accuracy to simulate multiple pellets but very harsh damage falloff
- Changes cop weapon stats to be consistent across their class (on the same difficulty a JP36 will perform the same as an Car-4, the damage increase comes from higher difficulty, not the weapon)

### Overhauls spawn groups

At one point, the game had unique spawn groups with different behaviours and tactics. Looking through the spawn group code reveals that these have been completely nuked and the enemy spawns are now completely map dependent with some spawns begin removed entirely, like the hostage rescue team. These spawn groups have been restored and improved to have a bigger variety of enemies and make combat more interesting.

- Makes spawn group code less convoluted, the base spawn groups are the same for every difficulty, only the chances of some of them appearing are changing
- Restores original spawn groups that were disabled by Overkill, adding back shotgunners, flanking squads, Taser rush spawn groups and hostage rescue units

### Standardizes cop factions

There are certain inconsistencies with the various enemy factions in the game that lead to different issues like enemy recognition or missing enemy types for certain factions. The changes to the cop factions aim to fix all these issues.

- Adds unique weapons for different factions, similar to how GenSec uses their own rifles and shotguns
- Adds chest armor to the heavy SWAT on Normal and Hard, to be in line with the heavy SWATs on other difficulties
- Makes heavy shotgunners more distinct from their rifle counterparts by adding gadgets to their helmets
- Replaces the lazy recolors for Mexican police with better recolors of the less seen cop models (blue SWAT)
- Adds missing enemy types for ZEAL units (Shotgunners, Medic)

### Improves the difficulty curve

The vanilla difficulty curve is all over the place with some difficulties feeling exactly the same while others introduce a major jump in difficulty. Enemy spawns are highly exaggerated, especially on Death Sentence, because issues in the weapon presets and shooting behaviour prevent them from actually being a threat (unless you count the broken rifle falloff on DS). Damage, accuracy, aim and focus delay values have all been rebalanced to create a smoother curve and gradually increasing difficulties.

- Adds proper difficulty scaling such that every difficulty feels different from the previous one instead of either barely a change or an extreme change
- Gives custom grace period times (I-frames) to players scaling with difficulty (from 0.5s on normal down to 0.2s on DS)
- Makes each difficulty have custom player revive health percentages (from 70% on normal to 10% on DS)
- Reduces the amount of cops on DS to normal levels, DS keeps being difficult through better means

### Miscellaneous other changes

These are minor changes that don't fit any of the above categories.

- Removes heavy and medium hurt animations from heavy SWAT but scales their damage lower than their light counterparts
- Reduces the damage of shield enemies
- Improves the surrender presets, different enemies have different chances to surrender
- Restores spawning voicelines for Bulldozers and Tasers

## Credits

- ZEAL medic textures based on work by [Jarey_](https://modworkshop.net/user/1664)
