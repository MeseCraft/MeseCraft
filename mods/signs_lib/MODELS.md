# Anatomy of a sign model

In the model files:

* The base sign model should be designed to look like a flat board placed on one side of the node space.  The first material entry in the model file must be assigned to the front and back faces of the sign, the second material must be the sign's edges.  The filename should be something along the lines of "mymod_my_cool_sign_wall.obj".

  In each of the variants below, generally-speaking, the third material in the model must be assigned to whatever it is that that model uses for the sign's mounting method, and the mounting style will be the last word in the model filename.

* For most signs that are allowed to sit on a vertical pole/post such as a fencepost, the pole-mounted model is just a copy of the base model, shifted back a bit, with a pole mount added to the back.  In these models, the third material in the model file must be assigned to the pole mount.  Name the model file the same as the base sign, but end the name with "_onpole" instead of "_wall".  For example, "mymod_my_cool_sign_onpole.obj".

  For signs that allow mounting onto a horizontal pole (such as a Streets mod horizontal "bigpole"), the third material is still the vertical pole mount as above, but there must also be another the pole mount included, designed to wrap around such a pole/post, to which fourth material must be assigned.  In most cases, this alternate mount will just be a copy of the vertical pole mount, but rotated by 90°, and explicitly centered vertically in the node space.

  While vertical and horizontal pole/post mounting options are independent in the code, if horizontal mounting is enabled, the on-pole model must still have *four* materials, even if the third material is unused, with the horizontal pole mount assigned to the fourth material.  In most situations, you'll probably have both vertical and horizontal pole mounts assigned to the third and fourth materials, as above.

* For hanging sign models, the third material must be assigned to whatever it is that makes the sign look like it's hanging from the ceiling (default signs have a simple, flat rectangle, meant to show an image of a simple pair of chains).  The model file for these must be named the same as the base model, but ending with "_hanging".  For example, "mymod_my_cool_sign_hanging.obj".

* For yard sign models, the third material must be assigned to the "stick" on the back of the sign.  The model for this type must be named the same as the base model, but ending with "_yard".  For example, "mymod_my_cool_sign_yard.obj".

* For most signs, the sign entity (if applicable) will be a simple rectangle, sized just slightly smaller than the width and height of the sign, and centered relative to the sign face.  Its UV map should cover the entire image area, so that the image is shrunk down to fit within the sign's intended text area.  The rectangle must be positioned slightly in front of the sign (by 10 millimeters or so, due to engine position precision limitations).

  The entity should be named the same as the corresponding wall, on-pole, hanging, and/or yard models, but with "_entity" added just before the mounting style.  For example:  a sign using "mymod_my_cool_sign_wall.obj" for the base model file should have an entity model file named "mymod_my_cool_sign_entity_wall.obj", if one will be needed.

In your code:

* The first `tiles{}` entry in the sign definition needs to be the front-back texture (how things are arranged within the image file is up to you, provided you match your sign model's UV map to the layout of your image).  The second entry will be the texture for the sign's edges.

* For signs that can be mounted on a pole/post, the third item in your `tiles{}` setting specifies the pole mount image to use.  When `signs_lib` goes to register the on-pole node(s), the image you specified here will be passed to `register_node()` as either the third or *fourth* tile item, setting the other to the standard blank/empty image, thus revealing only the vertical or horizontal pole mount, respectively.  If you don't specify a pole mount image, the standard pole mount texture will be used instead, if needed.

* For signs that can hang from a ceiling, the fourth entry in your `tiles{}` setting specifies the image to apply to the part of the model that makes it look like it's hanging.  If not specified, the standard hanging chains image will be used instead, if needed.

* For signs that can stand up in the yard, the fifth `tiles{}` entry specifies the image to be wrapped around the "stick" that the sign's mounted on.  If not specified, "default_wood.png" will be used instead, if needed.

* Some signs may allow for more complex entity shapes, images, and UV mapping.  For example, [street_signs](https://forum.minetest.net/viewtopic.php?t=20866) has a standard city street intersection sign, the entity mesh for which consists of four simple rectangles.  Two of them are identically UV-mapped to the top portion of the texture image, and placed on either side of the upper half of the sign portion of the model.  The other two rectangles are also identically UV-mapped, but point to a lower section of the texture, and are rotated by 90° and shifted down in the model, to place them on either side of the lower half of the sign.  This causes the first line of text to appear on both sides of the upper half of the sign, with the second line of text appearing on both sides of the lower half.

  Signs which don't use the simple models described above may not be compatible with the wall/pole/ceiling/yard placement code, but these things can be overridden/disabled in the node definition, if needed (as with the above intersection sign).

* `signs_lib` automatically blanks-out all redundant `tiles{}` entries for each node.

## Blender users

Start a new project, open the "Sidebar" (usually by pressing `N`), and scroll down to the Display section.  Set the Grid floor to 5 lines, Scale to 0.5, and Subdivisions to 8.

This will create an environment where the world origin/center will be the center of a node space at (0,0,0), with major divisions at half-node intervals.  With the camera aligned to an axis, zooming in so that one node space fills the window should put the grid at 16 minor divisions per meter, so the grid will correspond to pixels in a typical 16px-apparent texture, if your UV mapping is correct (though a standard sign model uses 32px-apparent textures).

Zoom in a bit more, and you'll see 256 divisions per meter, which can be thought of as 16 divisions per pixel.  This is where you'll want to be when positioning the sign entity.  In my configuration, the grid maxes out at 256 divisions per meter, even when zoomed in extremely close (this may be standard behavior).

For signs that will use "wallmounted" mode, the model must be lying flat, with its front side facing up along Blender's Z axis, and centered on the X and Y axes.  The back of the sign should be exactly flush with the -0.5m mark on the Z axis, putting the whole sign below the world center.  The bottom edge of the sign faces the negative end of the Y axis.

For signs that will use "facedir" mode, the sign must be upright, with its back flush with the +0.5m mark along the Y axis, centered on X/Z, with the bottom edge of the sign facing down along the Z axis.

When adding materials, you MUST add them in the order you want them to appear in the exported model, as Blender provides no easy way to enforce a particular order if they come out wrong.

If you look in the `models/` directory, you'll find the standard sign project file, "standard wooden sign.blend", which contains all four variants of the standard sign model ("wallmounted" and "facedir", on-wall and on-pole), designed per the above requirements.  This file also contains both entity variants (on-wall and on-pole).  You'll notice that there are only two entities. This is because entity rotation has no concept of "wallmounted", "facedir", etc., so all standard signs use the same pair of entities.

To create the text entity model, assuming you're starting with a properly-UV-mapped, "wallmounted" base sign model with a simple one-piece flat design (comparable to, say, a standard wall sign or a [street_signs](https://forum.minetest.net/viewtopic.php?t=20866) warning diamond), do these steps:

1. Snap the cursor to the world center, and set your viewport to Orthographic (usually `5` on the keypad).
2. Switch to Object Mode.
3. Select the sign model.
4. Create a linked duplicate (`Alt-D` in my keymap), as distinct from a simple duplicate (`Shift-D`).  Blender will automatically select the duplicate and immediately go into move/translate mode to let you move it around.
5. Without bothering to move the duplicate, press `R` `X` to go into rotatation mode around the X axis, which will also snap the duplicate back to its precise starting point in the process.
6. Rotate the duplicate by 90°, thus putting it upright, with its back side flush with the +0.5m mark on the Y axis.
7. With the duplicate still selected, switch to Edit Mode.
8. Select only the duplicate sign's front face.
9. Rotate your view to the right or left side (usually `3` or `Ctrl-3` on the keypad).
10. Zoom in close enough to get the grid to show 256 divisions per meter, while keeping the selected face in view.
11. Make a simple duplicate of the selected face (`Shift-D`).  Blender will automatically select just the new, duplicate face and go into move/translate mode.  Yeah, you're making a copy of a copy. 🙂
12. Press `Y` to limit movement to just the Y axis, and move the duplicate face in the negative direction, while snapping to the grid.  Put it at least 2 minor divisions from the front of the sign (that is, 2/256 of a meter).
13. Zoom out far enough to get the grid back to 16 divisions per meter, and align your view forward along the Y axis (usually `1` on the keypad).
14. With the duplicate face still selected, scale it along X and/or Z until its edges are just within the limits of your sign model's intended text area. You could also directly move the face's edges inward, perhaps while snapping to the grid, if the sign shape lends itself to that.  Make sure the face stays properly-positioned (usually centered) relative to the sign's front!
15. UV-map the duplicate face: `Mesh` → `UV Unwrap` → `Reset` followed by `Mesh` → `UV Unwrap` → `Project from view (bounds)`.
16. Separate the duplicate face into a new object (`P` in my keymap, then `Selection` in the menu that pops-up).
17. Switch to Object Mode
18. In the model/data tree at the upper-right (well, on my layout), rename the original sign mesh, its duplicate, and the entity mesh to something meaningful.
19. With only the text entity mesh selected, delete all materials from the list on the right, below the model/data tree (these were inherited from the base sign, and aren't needed with an entity mesh).
20. Save your project file.
21. Export the text entity mesh.  It is highly recommended that you export to "Wavefront (.obj)" format, as with most other Minetest node models.

Note that the duplicate sign model you created can also be used directly as a "facedir" sign model, as well as being a position reference for the text entity mesh, so I suggest leaving it in your project file when you save.

Use the following export settings (I strongly advise saving them as an Operator Preset; applies to all models and modes):

	Forward: [_Z_Forward_]
	Up:      [_Y_Up______]
	🆇 Selection Only
	🞎 Animation
	🆇 Apply Modifiers
	🞎 Use Modifiers Render Settings
	🞎 Include Edges
	🞎 Smooth Groups
	🞎 Bitflag Smooth Groups
	🆇 Write Normals
	🆇 Include UVs
	🞎 Write Materials
	🞎 Triangulate Faces
	🞎 Write Nurbs
	🞎 Polygroups
	🆇 Objects as OBJ Objects
	🞎 Objects as OBJ Groups
	🆇 Material Groups
	🞎 Keep Vertex Order
	(_Scale:________1.00_)
	Path Mode: [_Auto____]

