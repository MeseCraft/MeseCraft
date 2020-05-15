# rocket

Minetest has many great space mods that add in outer space thousands of blocks above the player. However, none of them have a good way to reach outer space-- until now. With this mod, you can craft rockets / space shuttles and fly them into and in outer space.

The forum topic for this mod is [here](https://forum.minetest.net/viewtopic.php?f=9&t=23120). There, you can find a list of crafting recipes.

## Controls overview

### Vertical mode
* A -- yaw left
* D -- yaw right
* W -- go forwards
* S -- go backwards
* Space -- move/accelerate upwards
* Space+Shift -- enable cruise mode
* Shift -- disable cruise mode
* A+D -- switch to horizontal mode

### Horizontal mode
* A -- yaw left
* D -- yaw right
* W -- move/accelerate forwards
* S -- brake
* Space -- go upwards
* Shift -- go downwards
* W+S -- enable cruise mode
* S -- disable cruise mode
* A+D -- switch to vertical mode

## Controls explained

The space shuttle has two modes: vertical mode and horizontal mode. In vertical mode, the rocket is upright, and in horizontal mode it is sideways. Vertical mode is used for lift off and for landing, whereas horizontal mode is used for moving and docking in outer space.

Place a Space Shuttle item down to place a space shuttle vehicle. A space shuttle will be placed in vertical mode. Right click on the space shuttle to enter/exit.

The space shuttle has a life support system (provides you with oxygen), so you will be able to breath in the rocket in space or an unbreathable atmosphere.

I strongly recommend that you always use 3rd person mode when riding a rocket. Also, if you crash into something at a high velocity, then your rocket explodes.

### Vertical mode
You can move horizontally in vertical mode. Use A to yaw (turn) left, D to yaw right, W to go forwards in the direction you have yawed, and S to go backwards in that direction. These horizontal controls are not fast and exist mainly to make small adjustments in position; the main focus of vertical mode is moving or falling vertically.

Hold space to move/accelerate upwards. At first, you will only move slightly up, but if you hold long enough then you will travel at exhilerating speeds. If you need to go down or slow down, let go of space. In vertical mode, rockets are affected by gravity, so whenever they stop going up, they go down. If you let go of space after holding it for a while, it will seem like you are still flying upwards. However, you are actually just coasting and your velocity is decelerating. The rocket will decelerate until it stops going and starts going down. You go down slow at first but you go faster and faster until you reach terminal velocity. To stop falling, hold space for a while. Although it may seem like you are still falling, you are actually slowing your descent. You will be able to slow your descent to the point that you are no longer falling and you are ascending again. If you use the space button wisely, you can rise or fall at whatever speed you choose. For example, you can use your rocket like a lunar lander if you thrust a little bit while you fall.

Press space and shift at the same time to enable vertical cruise mode, and press shift by itself to disable it. Cruise mode automatically maintains your vertical velocity, rising or falling.

Press A and D at the same time to switch to horizontal mode. You have to slow down the rocket to switch modes. After pressing A and D, right click once. If your head sticks out of the horizontal rocket, right click again twice very quickly to fix the glitch.

### Horizontal mode
Unlike vertical mode, where the focus is on vertical movement, horizontal mode is focused on movement in all directions, but mainly forwards. Also unlike vertical mode, which is affected by gravity, horizontal mode is gravity free, since it is designed to work in space.

Use A to yaw (turn) left, D to yaw right, W to move/accelerate forwards in the direction you have yawed, and S to brake. Hold W for a while to accelerate your forwards velocity, and S to slow down. S cannot be used to go backwards; instead, turn the rocket around and go forwards in the new direction.

Press W and S at the same time to enable horizontal cruise mode, and press S by itself to disable it. Horizontal cruise mode works just like the cruise mode in the airboat mod.

Press space to go up and shift to go down. You cannot travel vertically nearly as fast as vertical mode, but horizontal mode is still useful for vertical movement.

Press A and D at the same time to switch to vertical mode. You have to slow down the rocket to switch modes. After pressing A and D, right click once. To avoid any potential glitches, right click again twice very quickly. Be prepared to be affected by gravity again after you right click the first time.

## Inspirations
* Kerbal Space Program (video game)
* Galacticraft (Minecraft mod)

## Dependencies
* default
* bucket
* stairs
* tnt
* fire

## Optional Dependencies
* vacuum

## Licensing and Credit
The code is licensed as MIT and the media as CC-BY-SA-3.0, except for "rocket.png", which is licensed as CC-BY-SA-4.0.
This mod and all the models were made by Red_King_Cyclops, but several textures and much of code was made by other users. Almost all of the code is modified code from Paramat's [airboat](https://forum.minetest.net/viewtopic.php?t=20485) mod. The texture "rocket.png" is actually "submarine.png" renamed, taken from the [submarine](https://forum.minetest.net/viewtopic.php?f=9&t=16282) modpack by krokoschlange. Additionally, the textures "rocket_boom.png" and "rocket_smoke.png" are renamed textures taken from tnt and "rocket_hull.png" is a renamed texture taken from default. The oil textures and oil liquid registration code are taken from lib_materials by ShadMOrdre, except for the oil bucket texture, which is a modified water bucket texture from bucket. The rocket fuel textures (including the rocket fuel bucket texture) are modified water textures from default and bucket. The rest of the textures were made by me. The thrust sound is actually a renamed "fire_fire.3.ogg" taken from fire.