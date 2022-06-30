# Stickpack
Adds a selection of useful or comedic sticks to Minetest.

**License:** [MIT](https://opensource.org/licenses/MIT)

**Licencing note:** Licensing excludes textures and sounds attributed in `ATTRIBUTIONS.md`. The copyright for these resources belongs to their respective owners and are being used in this mod in adherence to the license terms or under fair use.

**Dependencies:** default

**Contributors:** GreenDimond (ideas, textures)

## Stick List

### RIPstick
Instantly kills players and mobs.

### Springy Stick
Doubles the player you hit's jump height and halves their gravity

### Lead Stick
Increases the player you hit's gravity by 50% and halves their speed.

### Litstick
Add's hitmarkers to the center of your player's screen, plays "Smoke Weed Everyday", appends sunglasses to the person you hit's skin and creates a hemp leaf particle spawner at their position. You can adjust the number of hitmarkers to spawn by changing the `stickpack_litstick_hitmarker_count` setting in `minetest.conf` and you can replace weed references with Darude Sandstorm references by setting `stickpack_family_friendly` to `true` in `minetest.conf`.

### Sadstick
Plays "2sad4me" at the player you hit's position and appends tears to their player skin.

### Knockback Stick
Knocks players and mobs back several nodes.

### 1000 Degree Stick
Sets they player you hit on fire, they will lose 1hp (half a heart) every second (they can jump in water to stop it)

### Rickstick
Plays Rick Astley's "Never Gonna Give You Up" at the player you hit's position.

### Trumpstick
Places a 4 node high, 9 node wide stone wall topped with barbed wire. Also takes stone and barbed wire from player's inventory

### Clearstick
Left click removes all objects within a 10 node radius, right click picks up all item entities within a 10 node radius and adds them to the player's inventory (or if they won't fit collects them in a pile). Left click is restricted to those with the `admin_stick` privilege.

### Lavastick
Picks up all snow within a 10 node radius and adds it to the players inventory (or makes a pile of item entities).

### Godstick
Strikes all players within a 40 node radius with lightning and kills them.

### Summoner Stick
Brings any object to your player position. Has a range of 100 nodes.

### Icestick
Freezes the player you hit, they will not be able to move for 30 seconds.

### Firestick
Sets nodes on fire.

### Kickstick
Kicks the player you hit with a silly reason.

## Administration
Server owners may wish to limit particular sticks to admins/moderators only. In order to do this, set `stickpack_restricted_sticks` in `minetest.conf` to a list of sticks to limit (separated with comas), by default it is set to `godstick,ripstick,kickstick`.

Limited sticks will be confiscated from players without the `admin_stick` privilege and limited sticks can be removed from the creative inventory by setting `stickpack_admin_sticks_creative` in `minetest.conf` to `1` (default is `0`).
