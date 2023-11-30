# Streamlined Heisting

Streamlined Heisting makes a lot of the gameplay mechanics more consistent. It is intended to build on what I think Overkill tried to accomplish rather than being a complete rebalance mod. As such, the mod doesn't add tons of new features or enemies and doesn't touch player balance or skills. The changes this mod makes are intended to make the game more consistent by replacing some of the very outdated code and fixing broken and disabled features.  
  
For a player side balance, check out [Streamlined Heisting Complements](https://github.com/segabl/pd2-sh-complements), a small tweaks mod specifically made with Streamlined Heisting in mind.  
Also check out [Alarmingly Streamlined Spawngroups](https://github.com/erushinj/moon-alarmingly-streamlined-spawngroups) for some cool extra features and further customization options.  
  
As with all mods that extensively change mechanics or add new units, this mod locks your matchmaking and you will only be able to play with other people that are also using it. When enabling or disabling the mod from the BLT mods menu make sure to restart the game to avoid issues.

## Compatibility

Mods that drastically change enemy AI, enemy weapons or spawngroups could cause conflicts or crashes, you will be asked to disable mods that are confirmed to be incompatible automatically. Mods that change enemy visuals are generally supported, most mods will be detected automatically and changes done by this mod will be disabled if they are incompatible, for some more complex mods you might have to turn off the faction improvements for the faction in question in the mod options manually.

## Features

### Improves enemy presets and weapon handling

Vanilla uses multiple presets that are assigned based on difficulty, but not every difficulty has its own preset. Presets are then further changed in different functions which leads to a lot of oversights and inconsistencies. The entire NPC shooting behaviour is needlessly complex and features like aim delay and focus delay don't work as intended. The preset system has been simplified and bugs in NPC weapon handling have been fixed.

- Creates and uses a single base weapon preset which scales damage, focus delay and aim delay based on difficulty
- Changes shotgun preset significantly, giving them very good accuracy to simulate multiple pellets but very harsh damage falloff
- Changes enemy weapon stats to be consistent across their class (on the same difficulty a JP36 will perform the same as a Car-4)
- Makes snipers more accurate but take longer to aim before shooting, avoiding cheap instant snipes due to bad RNG
- Improves the surrender presets, different enemies have different chances to surrender
- Gives enemies linear damage falloff instead of sudden drops after a distance threshold is reached
- Fixes accuracy values being ignored for single fire weapons in NPC vs NPC situations
- Simplifies the clunky fire mode system and interpolates the number of rounds fired based on distance instead (enemies will utilize full auto more)
- Properly implements and makes use of aim delay, enemies will now take time to aim at their target before shooting (depends on distance and difficulty)
- Fixes barely working focus delay code, enemies will take some time to reach their maximum accuracy when shooting (depends on difficulty)
- Allows NPCs to use melee attacks against other NPCs
- Improves suppression presets to be more distinct between different enemy types

### Overhauls spawn groups and enemy behaviour

At one point the game had unique spawn groups with different behaviours and tactics which have been disabled or broken over time, like shotgunners or hostage rescue units. Missing tactics have been implemented and spawn groups have been restored and improved to have a bigger variety of enemies and make combat more interesting.

- Makes spawn group code less convoluted, the base spawn groups are the same for every difficulty, only the chances of some of them appearing are changing
- Restores original spawn groups that were disabled, adding back shotgunners, reinforce groups and hostage rescue units
- Fixes scripted spawns to use the correct enemy faction when spawning enemies
- Fixes units with defend type objectives rushing the player instead of actually defending their designated areas
- Fixes units with hunt objective only moving to player locations once
- Adds reinforce points to loot secure points and the escape zone
- Fixes enemies crouch-walking when they are supposed to run
- Implements missing `murder` tactic, enemies with this tactic will focus on finishing off downed and tased players regardless of any aggressive behavior
- Implements missing `shield` and `shield_cover` tactics, enemies with `shield_cover` tactic will stick closely to group members with `shield` tactic
- Fixes `ranged_fire` tactic, enemies with this tactic will properly stop and open fire from a distance for a bit when they encounter players
- Fixes `flank` tactic, enemies will now try to flank properly and more consistently
- Fixes enemies not pulling back when encountering players during anticipation
- Reverts changes made to the Taser's line of sight check to allow them to tase more consistently again
- Makes Cloaker attacks more consistent by removing some of their restrictions and fixes them crouch-charging on clients
- Makes Shields reduce explosion damage from the front instead of a generic explosion damage resistance
- Makes Medics require line of sight to heal
- Fixes Bulldozers sprinting when they shouldn't and not switching to walking when they are close enough
- Adds increasing chance for enemies to use teargas grenades when players camp in an area for too long
- Makes enemies less hesitant to shoot while moving and react to threats with adequate reactions

### Improves the difficulty curve

The vanilla difficulty curve is all over the place with some difficulties feeling exactly the same and others introducing major jumps. Enemy spawns are highly exaggerated because issues in presets, behaviour and pathing prevent them from actually being a threat. Heist difficulty progression is unused and enemies will swarm you in full force as soon as a heist goes loud instead of the intended increasing force as time progresses. Difficulty dependent values have all been rebalanced to create a smoother curve and gradually increasing difficulties. Less but more responsive enemies will keep you on your toes instead of just staring you down waiting to be shot.

- Properly scales enemy health, damage, aim and focus delay values according to difficulty
- Makes each difficulty have custom player revive health percentages (from 65% on normal to 5% on DS)
- Gives each difficulty custom suspicion settings (smoother increase in stealth difficulty)
- Reduces the potential maximum amount of active enemies on the map
- Makes Bulldozer armor block damage and scales its HP with difficulty
- Scales assault duration with difficulty and reduces spawn pool to make it possible to end the assault earlier when spawns are exhausted
- Makes use of and smoothes out heist difficulty progression such that enemy force and special frequency increases as the heist progresses
- Reduces player grace period time but makes it always use the full duration (0.25s)
- Makes the assault delay caused by having hostages scale with the amount of hostages (minimum of 5s per hostage, up to 4 hostages)

### Standardizes enemy visuals

There are some inconsistencies with various enemy factions in the game that lead to issues like enemy recognition or missing enemy types. The changes to the enemy factions aim to fix all these problems.

- Adds unique weapons for different factions, similar to how GenSec uses their own rifles and shotguns
- Adds chest armor to the heavy SWAT on Normal and Hard, to be in line with the heavy SWATs on other difficulties
- Makes heavy shotgunners more distinct from their rifle counterparts by adding gadgets to their helmets
- Replaces the lazy recolors for Mexican police with better recolors of the less seen cop models (blue SWAT)
- Adds missing enemy types (ZEAL Shotgunners, ZEAL Medic, GenSec and ZEAL Sniper)
- Adds slight visual variations to murkywater shotgunners (both heavies and lights) to make them more distinct
- Fixes heavy Murkywater units body armor protecting their back
- Fixes some broken LOD models and removes some normal seams

### Other changes

These are miscellaneous changes, fixes and optimizations that don't fit any of the above categories.

- Reduces the effect of health granularity drastically (damage dealt to enemies is closer to the actual weapon damage listed in the inventory)
- Restores spawning voicelines for Bulldozers and Tasers and spawn noise for scripted Cloaker spawns
- Improves variety of enemy combat chatter and enables idle chatter for stealth
- Fixes various animation issues, like enemies playing full body crouching animations when suppressed when they are already crouching
- Makes special enemies and bosses more responsive by detaching their attack logic updates from the enemy task scheduler
- Adds a short delay before SWAT turrets retract to repair, giving a longer time window to deal damage after their shield breaks
- Makes sentry guns not count as criminals which stops enemies from pathing to them and ultimately get stuck
- Fixes enemies walking/running backwards towards their target/objective when they are not aware of threats
- Fixes enemy turn behaviour/speed differing between host and client and makes it more lenient
- Fixes the assault fade phase almost always ending after the minimum amount of time
- Increases the time it takes for Winters to reach the maximum damage reduction (from 10-50% in 40s to 5-50% in 90s)
- Makes hurt and knockdown animations not stackable, no new animation triggers while there's already one playing
- Fixes some spawn points being unavailable on certain maps due to incorrect pathing checks
- Makes flashbangs more consistent and less penalizing when looking away in time
- Fixes and optimizes fire spawned from molotovs and tripmines
- Fixes instances of Winters not leaving the map when the formation was told to break up before he was registered
- Fixes various synchronization issues where incorrect or incomplete data was sent to clients
- Updates old boss enemies with the new boss logic to make those boss fights more interesting
- Tweaks some heist mission scripts to play better or fix issues
- Makes enemies use more varied dodge directions
- Makes secured additional bags in Crime Spree reward one level per bag (up to a maximum of 10 additional levels)
- Adds hints when an enemy can't be intimidated due to temporary cooldown, no surrender preset or maximum amount of hostages reached
- Fixes Jokers sometimes following the wrong player
- Makes civilians' reactions to intimidation more consistent and fixes them jumping into a standing position randomly
- Fixes enemies sometimes just disappearing when they are told to retreat
- Maxes the maximum amount of random drill jams depend on the drill timer and prevents jams shortly after fixing a drill

## Credits

- [AverageChan](https://modworkshop.net/user/97086) for testing, feedback and fixing some assets
- [fuglore](https://modworkshop.net/user/32041) for inspiring some gameplay features and fixes
- [Jarey_](https://modworkshop.net/user/1664) for providing the base texture for the ZEAL medic
- [Masavik](https://modworkshop.net/user/52365) for creating the GenSec shield model
- [miss miki](https://modworkshop.net/user/55749) for testing, feedback and some mission script improvements
- [RedFlame](https://github.com/RedFlamer) for notifying me of problematic vanilla code and some animation fixes
- [hitscanner](https://modworkshop.net/user/hitscanner), [Nardo](https://modworkshop.net/user/19738), [nikita](https://modworkshop.net/user/54264) and others for testing and feedback
