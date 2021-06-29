# Font API

A library for rendernig text on textures (to be used with display_api for sign creation).

**Dependancies**: default

**License**: LGPL

(Default font taken from VanessaE's homedecor/signs_lib, originally under WTFPL)

**API**: See [API.md](https://github.com/pyrollo/display_modpack/blob/master/font_api/API.md) document please.

For more information, see the [forum topic](https://forum.minetest.net/viewtopic.php?t=13563) at the Minetest forums.

## Extra fonts

You can add fonts by installing fonts mod. Be aware that each font comes with numerous textures. This can result in slowing media downloading and/or client display.

Font mods can be found here:

 * [Metro](https://github.com/pyrollo/display_modpack/tree/master/font_metro): A multipurpose font with many chars (uppercase, lowercase and accentuated latin letters, usual signs, cyrillic and greek letters).
 * [OldWizard](https://github.com/pyrollo/font_oldwizard): An old style gothic font.
 * [Botic](https://github.com/pyrollo/font_botic): A scifi style font.

 ## Deprecation notice (for modders)

 ### December 2018
 Following object is deprecate, shows a warning in log when used:
 * `font_lib` global table (use `font_api` global table instead);

 This object will be removed in the future.
