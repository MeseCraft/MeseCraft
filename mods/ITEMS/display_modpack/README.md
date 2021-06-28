# Display Modpack
Version 1.3.1

This modpack provides mods with dynamic display. Mods are :

- **[display_api](https://github.com/pyrollo/display_modpack/tree/master/display_api)**: A library for adding display entities to nodes;
- **[font_api](https://github.com/pyrollo/display_modpack/tree/master/font_api)**: A library for displaying fonts on entities;
- **[signs_api](https://github.com/pyrollo/display_modpack/tree/master/signs_api)**: A library for the easy creation of signs;
- **[font_metro](https://github.com/pyrollo/display_modpack/tree/master/font_metro)**: A font mod used as default font (includes uppercase, lowercase and accentuated latin letters, usual signs, cyrillic and greek letters)

- **[boards](https://github.com/pyrollo/display_modpack/tree/master/boards)**: A mod providing school boards (includes *tiny cursive font*, a handwriting style font);
- **[ontime_clocks](https://github.com/pyrollo/display_modpack/tree/master/ontime_clocks)**: A mod providing clocks which display the ingame time;
- **[signs](https://github.com/pyrollo/display_modpack/tree/master/signs)**: A mod providing signs and direction signs displaying text;
- **[signs_road](https://github.com/pyrollo/display_modpack/tree/master/signs_road)**: A mod providing road signs displaying text;
- **[steles](https://github.com/pyrollo/display_modpack/tree/master/steles)**: A mod providing stone steles with text;

For more information, see the [forum topic](https://forum.minetest.net/viewtopic.php?t=19365) at the Minetest forums.

![Presentation image of Display_Modpack](screenshot.png)

## Extra fonts

*Metro* and *Tiny Cursive* fonts are provided in **Display Modpack** (in **font_metro** and **boards** mods) but you can add more fonts by installing font mods. Be aware that each font mod comes with numerous textures. This can result in slowing media downloading and/or client display.

Extra font mods can be found here:
 * [OldWizard](https://github.com/pyrollo/font_oldwizard): An old style gothic font.
 * [Botic](https://github.com/pyrollo/font_botic): A scifi style font.

## Deprecation notice (for modders)

### December 2018
Following objects are deprecated, shows a warning in log when used:
* `display_modpack_node` group (use `display_api` group instead);
* `display_lib_node` group (use `display_api` group instead);
* `display_lib` global table (use `display_api` global table instead);
* `font_lib` global table (use `font_api` global table instead);

These objects will be removed in the future.

## Changelog
### 2019-03-14 (Version 1.3.1)
- __dispay_api__: Display API now detects automatically whenr rotation restrictions have to be applied.
- __sign_api__: Screwdriver behavior changed. Now, left click rotates and changes direction.

### 2019-03-09 (Version 1.3)
- __display_api__: Display nodes can be rotated in every directions (if running Minetest 5 or above).
- __display_api__: New setting to restrict rotations to Minetest 0.4 abilities (restriction enabled by default).
- __sign_api__: Changed behavior of screwdriver if no rotation restriction.

### 2018-12-14 (Version 1.2.3)
- __display_api__: New `yaw` attributes, entities can now have different angles with node.
- __font_api__: New `Font:render` method for texture creation
- __font_api__: Specific management for fixed width font. Allows number of columns based texture width.
- __font_api__: Improve `display_api` integration into `font_api`. Display API fully optional. `font_api.on_display_update` defined only if `display_api` enabled.
- __font_api__: Improve management of invalid UTF strings (should not crash anymore)
- __font_api__: Deprecation of `font_lib`
- __signs__: Fixed craft recipe for labels

### 2018-12-02 (Version 1.2.2)
- Fixed a bug that prevented Display API from working on some systems (Raspberry Pi)

### 2018-11-01 (Version 1.2.1)
- Now font can be chosen per sign / stele

### 2018-11-01 (Version 1.2)
- Labels and woodend signs added.
- Fallback mechanism for missing chars (For example: "é" --> "e" --> "E").
- Several bug fixes by 12Me21 and naturefreshmilk.

### 2018-07-16 (Version 1.1.1)
- Boards mod added.
- Bug fix in default font chosing when multiple font registered.

### 2018-07-13 (Version 1.1.0)
- Font API rework introducing Font class.
- Replaced default Epilepsy Font by Metro Font for licensing purposes,
- Rework of all nodes displaying text accordingly to the Font API rework.

As font_epilepsy mod has been replaced by font_metro mod, **don't forget to activate font_metro mod after updating** or you won't have any text displayed.

### 2018-05-30 (Version 1.0.1)
Mostly bug fixes :
- Fix steles orientation when placing
- Update entity on mapblock load
- Use default formspec style
- Fix ndef nill value in steles mod when technics not installed
- Seperate signs API from signs définitions
- Allow a greater offset between display and block

### 2018-01-13 (Version 1.0)
- Switch to Epilepsy font by KREATIVE SOFTWARE
- Add settings "default_font"
- Add horizontal alignment
- Add tool for creating font textures from .ttf font files
- Fix UTF 8 to Unicode decoding
- Updated forum thread link in README.md

### 2017-12-19
This change is a preparation to merge Andrzej Pieńkowski fork (apienk) : new font and support of UTF chars.
- Font\_lib support for multiple fonts (nothing yet visible in mods) ;
- Font\_lib support for Unicode characters (limited to Unicode Plane 0: 0000-FFFF, see [Wikipedia](https://en.wikipedia.org/wiki/Unicode)) ;
- New "default" font with original textures from Vanessa Ezekowitz (VanessaE) ;

### 2017-12-10
- Compatibility of signs mod with signs_lib (thanks to gpcf) ;
- Added large banner in road signs (thanks to gpcf) ;

### 2017-08-26
- Changed signs from wallmounted to facedir to improve textures and make it possible to use screwdriver.
**IMPORTANT** : Map will be updated to change to new nodes but inventory items will turn into "Unknown items" and have to be re-crafted.
- Intllib support added with french translation (whole modpack, thanks to fat115) ;
- Punch on nodes to update entity (signs, signs_road and steles). Usefull in case of /clearobjects ;
- Changed wooden direction sign textures (signs) ;
- Added back and side textures to all signs (road_signs) ;
- Added more sign types : White/yellow/green signs and direction signs (signs_road) ;
