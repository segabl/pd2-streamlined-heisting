# Streamlined Heisting

Streamlined Heisting makes a lot of the game's enemy mechanics more consistent. It is intended to build on what I think Overkill tried to accomplish rather than being a complete rebalance mod. As such, the mod won't adds tons of new features and enemies and won't touch player balance or skills. The changes this mod makes are not intended to make the game feel drastically different but to make it more consistent and replace some of the very outdated code with something that actually works and makes more sense. A lot of features that the vanilla game had at some point were broken or disabled with game updates and have been fixed or re-enabled.

## What it does

### Improves how NPCs shoot their guns

The way the game determines how NPCs shoot their guns is ancient code that is not only needlessly complex but also suffers from oversights and broken features. Features like aim delay and focus delay did not work at all or not as intended. Bugs in these implementations have been fixed, code has been simplified and damage and falloff calculation has been updated to properly interpolate values.

- Gives enemies linear damage falloff instead of sudden drops after a distance threshold is reached
- Removes weapon spread from NPC accuracy calculation as it doesn't affect players and just makes NPC vs NPC situations very inconsistent
- Fixes accuracy values being ignored for single fire weapons in NPC vs NPC situations
- Simplifies the clunky fire mode system and interpolates the number of rounds fired based on distance instead (enemies will utilize full auto more)
- Properly implements and makes use of aim delay, enemies will now take time to aim at their target before shooting (depends on distance and difficulty)
- Fixes barely working focus delay code, enemies will take some time to reach their maximum accuracy when shooting (depends on difficulty)
- Replaces pseudo-random hit chance calculation with regular random function to avoid lucky/unlucky rolls leading to a lot of hits/misses in a row
- Makes enemies less hesitant to shoot while moving and react to threats with adequate reactions
- Fixes instances of enemies shooting when they shouldn't on clients
- Allows NPCs to use melee attacks against other NPCs

### Standardizes weapon and character presets

The vanilla game uses multiple base presets that are assigned based on difficulty, but not every difficulty has its own preset and instead reuses other presets. Presets are further manipulated in different functions which leads to a lot of oversights and inconsistencies, like some enemy types being left out when difficulty presets are applied. The preset system has been simplified to avoid changing preset values at times other than when they are created.

- Creates and uses a single base weapon preset which scales damage, focus delay and aim delay based on difficulty
- Makes use of aim and focus delays (which were mostly set to 0 in vanilla) which affects how long cops take to shoot and reach their full accuracy
- Changes shotgun preset significantly, giving them very good accuracy to simulate multiple pellets but very harsh damage falloff
- Changes cop weapon stats to be consistent across their class (on the same difficulty a JP36 will perform the same as an Car-4)
- Makes snipers more accurate but take longer to aim before shooting, avoiding cheap instant snipes due to bad RNG
- Improves the surrender presets, different enemies have different chances to surrender
- Removes heavy hurt animations from heavy SWAT but scales their damage slightly lower than their light counterparts

### Overhauls spawn groups and enemy behaviour

At one point the game had unique spawn groups with different behaviours and tactics which have been disabled or broken over time, like shotgunners or hostage rescue units. Missing tactics have been implemented and spawn groups have been restored and improved to have a bigger variety of enemies and make combat more interesting.

- Makes spawn group code less convoluted, the base spawn groups are the same for every difficulty, only the chances of some of them appearing are changing
- Restores original spawn groups that were disabled by Overkill, adding back shotgunners, reinforce groups and hostage rescue units
- Adds Skulldozers to the Mayhem Bulldozer spawn pool
- Fixes scripted spawns to use the correct enemy faction when spawning enemies
- Fixes units with defend type objectives rushing the player instead of actually defending their designated areas
- Adds reinforce points to loot secure points and the escape zone
- Fixes enemies crouch-walking when they are supposed to run
- Implements missing ``murder`` tactic, enemies with this tactic will continue shooting at downed players regardless of any aggressive behavior
- Implements missing ``shield`` and ``shield_cover`` tactics, enemies with ``shield_cover`` tactic will stick closely to group members with ``shield`` tactic
- Fixes ``ranged_fire`` tactic, enemies with this tactic will properly stop and open fire from a distance for a bit when they encounter players
- Fixes enemies not pulling back when encountering players during anticipation
- Reverts chages made to the Taser's line of sight check to allow them to tase more consistently again
- Makes Cloaker attacks more consistent by removing some of their restrictions and fixes them crouch-charging on clients
- Makes Shields reduce explosion damage from the front instead of a generic explosion damage resistance
- Makes Medics require line of sight to heal
- Fixes Bulldozers sprinting when they shouldn't and not switching to walking when they are close enough
- Adds increasing chance for enemies to use teargas grenades when players camp in an area for too long

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

- Properly scales enemy health, damage, aim and focus delay values according to difficulty
- Makes each difficulty have custom player revive health percentages (from 65% on normal to 5% on DS)
- Gives each difficulty custom suspicion settings (smoother increase in stealth difficulty)
- Reduces the amount of active cops (especially on DS) and scales it with difficulty, DS keeps being difficult through other changes
- Makes Bulldozer armor scale with difficulty (scales with the regular HP multiplier, from 1 on normal up to 8 on DS)
- Scales assault duration with difficulty and reduces spawn pool so it's actually possible to end the assault earlier when spawns are exhausted
- Makes use of and smoothes out heist difficulty progression such that enemy force and special frequency increases as the heist progresses

### Miscellaneous other changes

These are minor changes and fixes that don't fit any of the above categories.

- Reduces player grace period time but makes it always use the full duration (0.2s)
- Reduces the effect of health granularity drastically (damage dealt to enemies is more true to the actual weapon damage)
- Restores spawning voicelines for Bulldozers and Tasers and fixes Cloaker spawn noise for hosts
- Makes the assault delay caused by having hostages scale with the amount of hostages (minimum of 5s per hostage, up to 4 hostages)
- Fixes enemy suppression, the closer your shots are to an enemy, the more they will suppress instead of the other way around
- Fixes Medic- and Minigundozers ignoring the Bulldozer spawn cap
- Fixes enemies playing full body crouching animations when suppressed when they are already crouching
- Makes important enemies more responsive and always treats specials as important
- Adds a short delay before SWAT turrets retract to repair, giving a longer time window to deal damage after their shield breaks
- Makes sentry guns not count as criminals which stops cops from pathing to them and ultimately get stuck
- Fixes enemies walking/running backwards towards their target/objective when they are not aware of threats
- Fixes enemy turn behaviour/speed differing between host and client and makes it more lenient
- Fixes Cloakers being stuck in the beatdown animation and ignoring threats after a charge attack
- Fixes the Crime Spree "Heavies" modifier to replace the correct units
- Fixes the assault fade phase almost always ending after the minimum amount of time
- Increases the time it takes for Cpt. Winters to reach the maximum damage reduction (10-50% in 40s to 5-50% in 90s)
- Makes Shield knockdown animations not stackable, no new animation triggers while there's already one playing
- Fixes some spawn points being unavailable on certain maps due to incorrect pathing checks
- Makes flashbangs more consistent and less penalizing when looking away in time
- Fixes fire damage over time not triggering when a new damage over time instance is applied within a second
- Fixes and optimizes fire spawned from molotovs and tripmines
- Fixes instances of Winters not leaving the map when the formation was told to break up before Winters was registered

## Credits

- [Jarey_](https://modworkshop.net/user/1664) for providing the base texture for the ZEAL medic
- [RedFlame](https://modworkshop.net/user/78332) for notifying me of problematic vanilla code and providing code snippets
- [AverageChan](https://modworkshop.net/user/97086) for helping with testing and fixing some assets
- [creepyyy](https://modworkshop.net/user/54264) for testing and providing feedback
- Inspired by the early days of [fuglore's Hyper Heisting](https://modworkshop.net/mod/24337)
