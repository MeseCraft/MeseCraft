# signs_lib

This is kaeza's and my signs library mod, originally forked from PilzAdam's version and rewritten mostly by kaeza to include a number of new features, then rewritten again a couple more times (finding its way into my  [street_signs](https://forum.minetest.net/viewtopic.php?t=20866) mod for a while, where it developed nicely 🙂).

The purpose of PilzAdam's original mod was to just provide a no-frills way make default signs show their text, via an entity placed right in front.  It was hacky, but it worked!

While still hacky, this library is a modernized, feature-enhanced version of his code, which not only has visible text, but which allows that text to be colored, and displayed at any reasonable size, with any reasonable amount of text (as configured in a given node definition), with two font resolutions available. Plus, almost any sign can be attached to almost any kind of suitable pole or fencepost.  Most signs that use the standard wall sign model can also be hung from a ceiling, or placed upright as a yard sign, in addition to being flat on a wall or floor.  Unlike previous incarnations of this code, signs' text is visible when the sign is flat on the floor or ceiling, as well as all other supported orientations/mounting styles.

Without any other add-ons, this mod upgrades only the default wooden and steel signs.

## Text formatting

In general, text is rendered exactly as-written, left-to-right, top to bottom, without any translations or modifications.  The standard fonts support 7-bit ASCII as well as Cyrllic.

That said, there are some basic text formatting options:

* Paragraph breaks (blank lines) may be inserted by simply hitting `Enter` twice.

* Eight arrow symbols are available, occupying positions 0x81 through 0x88 in the character set.  These are produced by writing a "^" followed by a number 1 to 8:

  "^1" = `⬆`, "^2" = `⬈`, "^3" = `➡`, "^4" = `⬊`, "^5" = `⬇`, "^6" = `⬋`, "^7" = `⬅`, "^8" = `⬉`

  Writing "^" followed by a letter "a" through "h" will produce double-wide versions of these arrows, in the same order.  These wide arrows occupy 0x89 to 0x91 in the character set.

* A color may be specified in the sign text by using "#" followed by a single hexadcimal digit (0-9 or a-f).  These colors come from the standard Linux/IRC/CGA color set, and are shown in the sign's formspec.  Any color change will remain in effect until changed again, or until the next line break.  Any number of color changes in any arbitrary arrangement is allowed.

* Most writable signs can display double-wide text by flipping a switch in the sign's formspec.

## Sign placement and rotation notes

* Pointing at a wall while placing will, of course, place the sign on the wall.

* For most signs that use the standard sign model, pointing at the ground while placing creates an upright standalone yard sign.  Others not using the standard model will most often end up flat on the ground.

* For most standard signs, pointing at the ceiling while placing will hang the sign from the ceiling by a pair of chains.  Others not using the standard model will usually end up flat on the ceiling.

* Pointing at an X or Z side of something that's detected as a pole/post will mount the sign onto that pole, if possible.  Note that the sign actually occupies the node space in front of the pole, since they're still separate nodes.  But, I figure, no one's going to want to use the space in front of the sign anyway, because doing so would of course obscure the sign, so it doesn't matter if the sign logically occupies that node space.

* If you're holding the "Sneak" key (usually `Shift`) while placing, the on-pole/hanging/yard checks are skipped, allowing you to just place a sign flat onto the ground, ceiling, or top/bottom of a pole/post, like they used to work before `signs_lib` was a thing.

* If a sign is on the wall or flat on the ground, the screwdriver will spin it from one wall to the next, in clockwise order, whether there's a wall to attach to or not, followed by putting it flat on the ground, then flat against the ceiling, then back to wall orientation.

* If a sign is hanging from the ceiling (not flat against it), the screwdriver will just rotate it around its Y axis.

* If a sign is on a vertical pole/post, the screwdriver will rotate it around the pole, but only if there's nothing in the way.

* If a sign is on a horizontal pole/post, the screwdriver will flip it from one side to the other as long as there's nothing in the way.

## Chat commands

At present, only one command is defined:

* `/regen_signs`

This will read through the list of currently-loaded blocks known to contain one or more signs, delete all entities found in each sign's node space, and respawn and re-render each from scratch.

The list of loaded, sign-bearing blocks is created/populated by an LBM (and trimmed by this command if any listed blocks are found to have been unloaded).
