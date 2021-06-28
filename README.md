# Streamlined Heisting

Streamlined Heisting makes a lot of the game's enemy mechanics more consistent. It is intended to build on what I think Overkill tried to accomplish rather than being a complete rebalance mod. As such, the mod won't adds tons of new features and enemies and won't touch player balance or skills. The changes this mod makes are not intended to make the game feel drastically different but to make it more consistent and replace some of the very outdated code with something that actually works and makes more sense. A lot of features that the vanilla game had at some point were broken or disabled with game updates and have been fixed or re-enabled.

## What it does

### Improves how NPCs shoot their guns

The way the game determines how NPCs shoot their guns is ancient code that is not only needlessly complex but also suffers from oversights and broken features. Features like aim delay and focus delay did not work at all or not as intended. Bugs in these implementations have been fixed, code has been simplified and damage and falloff calculation has been updated to properly interpolate values.

- Gives cops linear damage falloff instead of sudden drops after a distance threshold is reached
- Removes weapon spread from NPC accuracy calculation as it doesn't affect players and just makes NPC vs NPC situations very inconsistent
- Fixes accuracy values being ignored for single fire weapons in NPC vs NPC situations
- Simplifies the clunky fire mode system and interpolates the number of rounds fired based on distance instead (enemies will utilize full auto more)
- Properly implements and makes use of aim delay, enemies will now take time to aim at their target before shooting (depends on distance and difficulty)
- Fixes barely working focus delay code, enemies will take some time to reach their maximum accuracy when shooting (depends on difficulty)
- Replaces pseudo-random hit chance calculation with regular random function to avoid lucky/unlucky rolls leading to a lot of hits/misses in a row
- Makes cops less hesitant to shoot while moving and react to threats with adequate reactions

### Standardizes weapon and character presets

In vanilla there are multiple base presets that are assigned based on difficulty, but not every difficulty has its own preset and instead reuses other presets. Presets are further manipulated in different functions which leads to a lot of oversights and inconsistencies, like some enemy types being left out when difficulty presets are applied. The preset system has been simplified to avoid changing preset values at times other than when they are created.

- Creates and uses a single base weapon preset which scales damage multipliers, accuracy, melee damage, focus delay and aim delay based on difficulty
- Makes use of aim and focus delays (which were mostly set to 0 in vanilla) which affects how long cops take to shoot and reach their full accuracy
- Changes shotgun preset significantly, giving them very good accuracy to simulate multiple pellets but very harsh damage falloff
- Changes cop weapon stats to be consistent across their class (on the same difficulty a JP36 will perform the same as an Car-4)
- Makes snipers more accurate but take longer to aim before shooting, avoiding cheap instant snipes due to bad RNG
- Improves the surrender presets, different enemies have different chances to surrender
- Removes heavy and medium hurt animations from heavy SWAT but scales their damage slightly lower than their light counterparts

### Overhauls spawn groups and enemy behaviour

At one point the game had unique spawn groups with different behaviours and tactics which have been disabled or broken over time, like shotgunners or hostage rescue units. These spawn groups have been restored and improved to have a bigger variety of enemies and make combat more interesting.

- Makes spawn group code less convoluted, the base spawn groups are the same for every difficulty, only the chances of some of them appearing are changing
- Restores original spawn groups that were disabled by Overkill, adding back shotgunners, reinforce groups and hostage rescue units
- Adds Skulldozers to the Mayhem Bulldozer spawn pool
- Fixes scripted spawns to use the correct enemy faction when spawning enemies
- Fixes units with defend type objectives rushing the player instead of actually defending their designated areas
- Adds reinforce points to loot secure points and the escape zone

### Standardizes enemy factions

There are some inconsistencies with various enemy factions in the game that lead to issues like enemy recognition or missing enemy types. The changes to the cop factions aim to fix all these problems.

- Adds unique weapons for different factions, similar to how GenSec uses their own rifles and shotguns
- Adds chest armor to the heavy SWAT on Normal and Hard, to be in line with the heavy SWATs on other difficulties
- Makes heavy shotgunners more distinct from their rifle counterparts by adding gadgets to their helmets
- Replaces the lazy recolors for Mexican police with better recolors of the less seen cop models (blue SWAT)
- Adds missing enemy types (ZEAL Shotgunners, ZEAL Medic, GenSec and ZEAL Sniper)
- Fixes heavy Murkywater units body armor protecting their back

### Improves the difficulty curve

The vanilla difficulty curve is all over the place with some difficulties feeling exactly the same while others introduce a major jump. Enemy spawns are highly exaggerated, especially on Death Sentence, because issues in the weapon presets and shooting behaviour prevent them from actually being a threat. Heist difficulty progression is unused and enemies will swarm you in full force as soon as a heist goes loud instead of the intended increasing force as time progresses. Difficulty dependent values have all been rebalanced to create a smoother curve and gradually increasing difficulties.

- Properly scales enemy health, damage, accuracy, aim and focus delay values according to difficulty
- Reduces player grace period times scaling with difficulty (from 0.3s on normal down to 0.15s on DS) but makes it always use the full duration
- Makes each difficulty have custom player revive health percentages (from 65% on normal to 5% on DS)
- Reduces the amount of active cops (especially on DS) and scales it with difficulty, DS keeps being difficult through other changes
- Makes Bulldozer armor scale with difficulty (scales with the regular HP multiplier, from 1 on normal up to 8 on DS)
- Scales assault duration with difficulty and reduces spawn pool so it's actually possible to end the assault earlier when spawns are exhausted
- Makes use of and smoothes out heist difficulty progression such that enemy force and special frequency increases as the heist progresses

### Miscellaneous other changes

These are minor changes and fixes that don't fit any of the above categories.

- Reduces the effect of health granularity by drastically increasing the fractional that damage is rounded to (from 1/512 to 1/8192)
- Restores spawning voicelines for Bulldozers and Tasers and fixes Cloaker spawn noise for hosts
- Makes the assault delay caused by having hostages scale with the amount of hostages (minimum of 5s per hostage, up to 4 hostages)
- Fixes enemy suppression, the closer your shots are to an enemy, the more they will suppress instead of the other way around
- Fixes Medic- and Minigundozers ignoring the Bulldozer spawn cap
- Reverts chages made to the Taser's line of sight check to allow them to tase more consistently again
- Fixes enemies playing full body crouching animations when suppressed when they are already crouching
- Raises the maximum amount of important enemies and always treats specials as important (Important enemies are more responsive)
- Adds a short delay before SWAT turrets retract to repair, giving a longer time window to deal damage after their shield breaks
- Makes Cloaker attacks more consistent by removing some of their restrictions and fixes them crouch-charging on clients
- Makes sentry guns not count as criminals which stops cops from pathing to them and ultimately get stuck
- Fixes enemies walking/running backwards towards their target/objective when they are not aware of threats
- Fixes enemy turn behaviour/speed differing between host and client and makes it more lenient
- Fixes Cloakers being stuck in the beatdown animation and ignoring threats after a charge attack
- Fixes the Crime Spree "Heavies" modifier to replace the correct units

## Credits

- ZEAL medic textures based on work by [Jarey_](https://modworkshop.net/user/1664)
- Inspired by the early days of [fuglore's Hyper Heisting](https://modworkshop.net/mod/24337)
