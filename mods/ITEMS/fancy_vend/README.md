# Fancy Vend
A full-featured, fully-integrated vendor mod for Minetest.

There are many vendor mods for Minetest, but most have too few options, lack support for automation mods, or are too tedious to set up and maintain. Fancy vendors are entirely self-contained nodes which provide light, trade, display and store items. Fancy vendors are pipeworks, digilines and awards compatible, enabling a variety of automation-based features.

<!-- For forums: -->
<!-- [**Download**](https://github.com/ChimneySwift/fancy_vend/archive/master.zip)
[**GitHub**](https://github.com/ChimneySwift/fancy_vend) -->

**Code license:** [MIT](https://opensource.org/licenses/MIT)

**Textures license:** [MIT](https://opensource.org/licenses/MIT)

**Dependencies:** default

**Optional Dependencies:** [pipeworks](https://github.com/minetest-mods/pipeworks), [digilines](https://github.com/minetest-mods/digilines), [awards](https://github.com/minetest-mods/awards), [email](https://github.com/rubenwardy/email), [tell](https://github.com/octacian/tell), [mail](https://cheapiesystems.com/git/mail/)

**Contributors:** Many thanks to LadyK for the textures, patience and ideas.

**Note:** While this mod is still a WIP and you should use it with caution, it has been tested for some time on several worlds with no problems.

## Crafting and basic configuration
A fancy vendor can be crafted as follows:

![Crafting a fancy vendor](https://github.com/ChimneySwift/fancy_vend/blob/master/screenshots/Crafting%20a%20fancy%20vendor.PNG?raw=true "Crafting a fancy vendor")

While the recipe is more expensive than most vendors, it more than makes up for this in the vendor's inventory size and additional features.

Each fancy vendor needs 2 nodes of room. If the area you wish to place the vendor doesn't have enough space, due to either a node or a protected area, the node will not be placed. If the vendor has sufficient room, it will place a vendor node in addition to a display node on top. The display node's only purpose is aesthetics, to "contain" the rotating display object.

Configuring a vendor is as simple as picking up and placing the input and output items into their respective slots as if they were regular inventories (items in these inventories are "ghosts", so don't actually take anything from the player's inventory) and setting the quantities for each item, as shown below:

![Setting up a vendor](https://github.com/ChimneySwift/fancy_vend/blob/master/screenshots/Setting%20up%20a%20vendor.PNG?raw=true "Setting up a vendor")

Stocking a vendor is as simple as placing the output item into the vendor's inventory (perhaps using one of the handy inventory movement buttons) as demonstrated below:

![Stocking a vendor](https://github.com/ChimneySwift/fancy_vend/blob/master/screenshots/Stocking%20a%20vendor.PNG?raw=true "Stocking a vendor")

After stocking a vendor, you may wish to press the "sort" button, which will combine unfilled stacks and sort the stacks in alphabetical order.

If the vendor is intended to be used to purchase items, you may wish to set the vendor to a depositor in the vendor settings, this will display the input item in the display case and change the vendor's appearance to make it clear to potential sellers the vendor's purpose. The previous example vendor set to a depositor can be seen below:

![A player depositor](https://github.com/ChimneySwift/fancy_vend/blob/master/screenshots/A%20player%20depositor.PNG?raw=true "A player depositor")

## Buying items
Regular players who can't access a fancy vendor's inventory or configuration will be displayed a purchase screen when they access a vendor. This screen displays vendor information and status, as well as buying options. Unlike many vendor mods, fancy vendors give buyers to buy multiple "lots" at once. Doing this can save a lot of clicking, as the number of input and output items traded is multiplied by this number.

There is also a button labeled "Fill lots to max" which will pre-load the lots field with the maximum number of lots that the player can purchase from the vendor (which will be either the maximum the player can afford, or the maximum the shop can sell, whichever is smaller).

An example image of the buyer formspec can be seen below:

![Buying from a fancy vendor](https://github.com/ChimneySwift/fancy_vend/blob/master/screenshots/Buying%20from%20a%20fancy%20vendor.PNG?raw=true "Buying from a fancy vendor")

## Advanced settings
Fancy vendors have many additional options which enable sellers to greatly customize vendors.

![Fancy Vendor settings](https://github.com/ChimneySwift/fancy_vend/blob/master/screenshots/Fancy%20Vendor%20settings.PNG?raw=true "Fancy Vendor settings")

**Banned Buyers:**
This field is a list of players (separated by commas) who won't be able to purchase from the vendor. This setting might be useful if you wish to stop players buying out your vendor's stock and reselling it for a higher margin.

**Co-Sellers:**
This field is a list of players (separated by commas) who will be able to access the vendor's inventory. **Please note: Anyone added to the list has full access to the vendor's inventory, however cannot modify the vendor settings nor dig the vendor.**

**Buy/sell worn tools:**
These options allow for the seller to stop the vendor from purchasing or selling worn tools. A message will display on the buyer formspec if one of these options is disabled.

**Inactive force:**
While the seller is reconfiguring a vendor, or in the process of creating a shop, the owner might wish for the vendor to be inactive so players cannot purchase from it, in which case they can enable this option.

**Autosort:**
If this option is enabled, the vendor's inventory will automatically sort when the vendor formspec is closed by someone who can access the inventory.

**Logs:**
The logs formspec displays the 40 most-recent transactions. While only people who can modify the vendor are allowed to access this formspec, these logs are kept in metadata which could be easily read client-side.

**Geminio Wand:**
This tool can be used to easily copy vendor settings from one vendor to another. Simply right click a vendor with it to copy the settings to the tool, and left click any other vendor to set that vendor's settings. **The Geminio Wand will not copy input and output items nor quantities.** You must be able to modify the settings of the vendor to do this. You can craft one with the following recipe:

![Crafting a Geminio Wand](https://github.com/ChimneySwift/fancy_vend/blob/master/screenshots/Crafting%20a%20Geminio%20Wand.PNG?raw=true "Crafting a Geminio Wand")

## Automation
Fancy Vendors are digilines and pipeworks compatible, enabling the creation of highly automated shops.

### Pipeworks
Fancy vendors connect to pipeworks devices from the bottom, rear and sides. When the optional pipeworks dependancy is satisfied, a number of pipeworks-specific options will also appear in the settings menu:

![Pipeworks Settings](https://github.com/ChimneySwift/fancy_vend/blob/master/screenshots/Pipeworks%20Settings.PNG?raw=true "Pipeworks Settings")

**Split incoming stacks:**
This option enabled incoming stacks from pipeworks tubes to be split if only some of the stack can be accepted.

**Eject incoming currency:**
When this option is enabled, the input items will be sent out of the **bottom** of the fancy vendor instead of being added to the vendor's internal inventory.

**Accept output only:**
When this option is enabled, incoming items which aren't the output item will be rejected and not added to the vendor's inventory.

### Hoppers
Fancy vendors are hopper compatible. They have been tested to work with [TenPlus1's hopper mod](https://github.com/tenplus1/hopper) however should work with all hopper mods and forks. Hoppers can filter into vendors from the sides, however cannot be drained from the bottom as hoppers are protected and Fancy Vendors are locked. However, the shop owner is given the `Eject incoming currency` option which operates on hoppers similarly to how it does on pipeworks, by manually adding incoming currency to the inventory of a hopper placed below the vendor (or into the vendor's inventory if the hopper is full). Due to API limitations, `Accept output only` is not hopper-compatible and `Split incoming stacks` is not necessary.

### Digilines
Fancy vendors are digilines compatible. When the digilines dependency is satisfied, an option to set the digiline channel will appear in settings. If this channel is set, every purchase will result in the following table being sent over that channel:

```lua
local msg = {
    buyer = player:get_player_name(), -- Purchaser's playername
    lots = lots, -- Number of lots purchased
    settings = settings, -- The settings table
}
```

The default settings table can be seen below:

```lua
local settings_default = {
    input_item = "",
    output_item = "",
    input_item_qty = 1,
    output_item_qty = 1,
    admin_vendor = false,
    depositor = false,
    currency_eject = false,
    accept_output_only = false,
    split_incoming_stacks = false,
    inactive_force = false,
    accept_worn_input = true,
    accept_worn_output = true,
    digiline_channel = "",
    co_sellers = "",
    banned_buyers = "",
}
```

Fancy Vendors and Fancy Vendor Display Nodes conduct digiline signals also.

This feature could theoretically make rewards-based shops feasable.

## Out Of Stock Mail
This mod integrates with several mail mods in order to alert shop owners when their shops lose stock. If multiple mods are in use, only one will be used to send the message. The order of which is:

- Email By Rubenwardy
- Mail By Cheapie
- Tell By Octacian

### Mail
When a vendor empties, the mod sends mail telling them that their vendor is out of stock. In the event another mod empties, the previous message will be edited so as to avoid flooding their inbox if they have many vendors.

### Tell & Email
As there is no tidy way of sending very long messages with these mods, messages will simply be sent whenever a vendor goes out of stock.

## Upgrading vendors

**NOTE:** If you wish to simply run this mod in parallel with existing vendor mods, simply load this mod (no configuration required)

Many servers already have vendor mods in place. Fancy Vend makes it easier for servers to upgrade with it's unique upgrading system. Fancy Vend will replace vendors from the supported vendor mods (money, vendor, easyvend and currency) with upgrade nodes. Upgrade nodes allow for sellers to empty the old node's inventory (if applicable), dig the upgrade node (which will drop a regular vendor) and set up a new shop. if a user tried to place an upgrade node, the stack is turned into a stack of regular vendors.

Since upgrade functionality can be achieved without the old mod loaded, the server owner must add the old vendor mod's name to `minetest.conf` as follows:

`fancy_vend_old_vendor_mods = money`

If there are multiple vendor mods the the owner wishes to enable this functionality on, they can add several mods to the list, separating each mod name with commas as follows:

`fancy_vend_old_vendor_mods = money,vendor,easyvend`

If the owner wishes to keep the mod loaded, but still replace vendor nodes, the will need to add the mod to both `minetest.conf` and fancy_vend's `depends.txt`.

Vendor upgrade:

![Vendor upgrade](https://github.com/ChimneySwift/fancy_vend/blob/master/screenshots/Vendor%20upgrade.PNG?raw=true "Vendor upgrade")

## Administration
Fancy vendors also include a variety of tools for server administrators.

**Admin vendors:**
Admin vendors perform the same role as their regular counterparts, however they do so with no stock or inventory requirements, simply creating and destroying items as players purchase.

Since incorrectly configured admin vendors could be easily used to duplicate items, the `admin_vendor` privilege is required for the option to switch a vendor to one appears. If the user is ever revoked this privilege, all admin vendors they own will be forced into an inactive state until the privilege is re-granted or the vendor is set to a player vendor.

**Modifying vendors:**
If a user has the `protection_bypass` privilege, they will be able to access the full extent of the vendor as if they were the owner, including inventory and settings.

**Server and client load:**
Fancy vend uses only one infrequent abm to refresh vendor objects in the event of a clearobjects. No other vendor updating is done unless a player purchases from the vendor or adjusts settings.

Note: Some clients using mobile and/or older devices, including PCs, may experience additional lag if many fancy vendors are used in a small space, however not to an extent greater than the majority of shops where players use itemframes or pedestals to achieve the same functionality as the fancy vendor's display.

**Settings:**
The following minetest.conf settings can be configured to further modify the appearence of Fancy Vendors:

`fancy_vend_display_node` - Change the display node to something other than `default:obsidian_glass` (ensure mod this node belongs to is in depends.txt)

`fancy_vend_log_max` - Change the maximum number of logs stored in a vendor's metadata

`fancy_vend_autorotate_speed` - Change the speed at which the display object rotates

**Temporarily disabling vendors:**
Any player with the `disable_vendor` privilege can run `/disable_all_vendors` to force all vendors into an inactive state. Please use this if you find a dangerous bug and are waiting for it to be fixed.
