                 _, __,    _, __, _, _  _, __,                    
                ~_) | \   / \ |_) |\/| / \ |_)                    
                 _) |_/   |~| | \ |  | \ / | \                    
                 ~  ~     ~ ~ ~ ~ ~  ~  ~  ~ ~                    
    __, _,  , _ _ _, _  _,    _, _  _ _ _, _ _, _ _ _, _  _,
    |_  |   \ | | |\ | / _   (_  |  | | |\/| |\/| | |\ | / _
    |   |_,  \| | | \| \ /   , ) |/\| | |  | |  | | | \| \ /
    ~   ~ ~   ) ~ ~  ~  ~     ~  ~  ~ ~ ~  ~ ~  ~ ~ ~  ~  ~ 
             ~'           
                                            
---------------------------
## Information
---------------------------
This is a small utility mod which adds some new animations to the default animations found in player_api animations, the new animations are:

	|Animation| Start | End | FPS |
	|---------|-------|-----|-----|
	|Swim     |  246  | 279 |  30 |
	|Swim Atk |  285  | 318 |  30 |
	|Fly      |  325  | 334 |  30 |
	|Fly Atk  |  340  | 349 |  30 |
	|Fall     |  355  | 364 |  30 |
	|Fall Atk |  365  | 374 |  30 |
	|Duck Std |  380  | 380 |  30 |
	|Duck     |  381  | 399 |  30 |
	|Climb    |  410  | 429 |  30 |
	
 	
		
I have done my best to trigger the animations in the correct circumstances when viewing the player model in 3rd person. 

I have only tested this against minetest versions 5.0 to 5.6

Mod now works with just player_api, 3d_armor is an optional depends.

Works with simple_skins - https://forum.minetest.net/viewtopic.php?f=11&t=9100

Works with skinsdb - https://forum.minetest.net/viewtopic.php?t=17899

Works with clothing 2 - https://forum.minetest.net/viewtopic.php?p=395157

When using skinsdb capes must be supplied by clothing 2. 

![swim animation](https://github.com/sirrobzeroone/3d_armor_flyswim/blob/main/swimming_animated.gif)

---------------------------
## Mod explanations and interactions   
---------------------------
**player_api**
fly,swim,crouch,climb animations work, enabling capes will do nothing as you cant wear them

Below here assumed you stil have player_api enabled/installed:

**simple skins**
fly,swim,crouch,climb animations work, enabling capes will do nothing as you cant wear them

**3d_armor**
You have the option to have capes on or off upto you, capes are considered armor

**3d_armor and simple_skins**
You have the option to have capes on or off upto you, capes are considered armor

**skinsdb**
Fly,swim,crouch,climb animations work, enabling capes will do nothing as you cant wear them

**3d_armor and skinsdb**
Fly,swim,crouch,climb animations work you can enable capes but they wont be visible on your character but will still provide any bonuses

**3d_armor, skinsdb and clothing 2**
Fly,swim,crouch,climb animations work, visual cape provided by clothing_2 however can also enable capes but they wont be visible and it's a bit strange wearing two capes. So recommened left disabled.


---------------------------
## Animation rules/triggers    
---------------------------
Swimming - You must be in at least 2 nodes depth of liquid/flowing liquid and moving otherwise your character will simply wade through the liquid or float (stand). If you sink close to the bottom while submerged in the liquid your character will automatically stand on the bottom. 

Swim through - Hold shift down while swimming, you will sink but will also now be able to swim through 1x1 tunnels.

Flying - Character/player must have fly_privs you must have at least 2 nodes of airlike nodes between you and the ground otherwise your character will simply/stand or walk ready to land. You also need some type of movement horizontally to trigger the animation otherwise your character will simply stand in the air to emulate hovering.

Falling - Character/player must have 4 nodes of airlike nodes between them and the ground. Easiest to trigger if fly_privs have been removed but you can fall with fly_privs. Max falling speed is set by terminal velocity, however holding shift down will let you exceed terminal velocity.

Crouching - Press shift while standing in the open and then walk forward.

Crouching under - Simply walk through a gap 1.5 nodes tall. Player/character must be facing the space and walking forwards.


---------------------------
## Turn off Animation or Crouch Rule    
---------------------------
From MT Main Menu go to "Settings" then "All Settings" then "Mods" then "3d_armor_flyswim"

**capes_add_to_3darmor** - Default is enabled - Makes capes an armor item avaliable via 3d_armor (1 test cape included)

**example_cape** - Default is enabled - The example cape "Someones Cape" is avaliable which grants fly_privs when worn and a 100% speed increase

**fly_anim** - Default is enabled - Will show the flying animation

**fall_anim** - Default is enabled - Will show the falling animation

**fall_tv** - Default is 100 - This is terminal velocity, 100 represents approximatly 100kp/h however player/character speed will oscilate around this speed. Without this limit when falling characters simply accelerate endlessly (until they hit chunk load edge). 

**swim_anim** - Default is enabled - Will show swim animation

**swim_sneak** - Default is enabled - Will allow character/player to swim through a hole 1x1 in size when underwater. 

**climb_anim** - Default is enabled - Will show climb animation

**crouch_anim** - Default is enabled - Will show crouch/duck animation

**crouch_sneak** - Default is enabled - Will allow character/player to walk through a gap 1.5 nodes high when on land.

---------------------------
## Why are Capes Included?     
---------------------------
I found it best to keep capes included in this mod with the option to enable or disable. This is because capes needs the new b3d player model so they
are displayed as part of armor instead of part of the player. However as I didn't want to force anyone into using capes as armor items I created a second
optional player model which keeps capes with the player textures.

The above would create a circular dependancy if capes was it's own mod. Capes would  have a dependency on Fly/Swim but Fly/Swim needs to know if Capes mod 
is present so as to load the correct b3d player model.

Given the above I have kept capes inside this mod with an option to enable/disable it under Settings>>All Settings>>Mods>>3d_armor_flyswim by default capes are set to Enabled/true

Capes provide minimal additional armor, about half as much as wooden boots by default. 

--------------------------------------------
## What nodes are set as Flyable/Swimmable?       
--------------------------------------------
Any node which has the drawtype set as "airlike", "liquid" and "flowingliquid" will automatically be flyable or swimmable.

Big thanks to Gundul for pointing out a better way to do this.

--------------------------------------------
## Headanimation is incorporated      
--------------------------------------------
I have incorporated "headanim" mod content by LoneWolfHT as it was easier to include and then customise for this mod than try to interface
with "headanim". Full credit to LoneWolfHT for the functionality. I did modify the functionality a little so visually when in 3rd person view 
Sams head will:

~ Regular animations when looking down Sams chin now rests on his chest (about a 60 degree angle).  
~ Regular animations when looking up Sam only bends head back to the same 60 degrees.   
~ Swimming and flying you can look down full 90 degrees, straight ahead 0 degrees, however head motion is restricted to 30 degrees back.  

Make sure you disable "headanim" if you have it installed, although I found no serious issues with both enabled the mods
could fight one another for control of head position.