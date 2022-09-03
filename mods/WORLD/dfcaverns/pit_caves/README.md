A pit cave, shaft cave or vertical cave—or often simply called a pit (in the US) or pot (in the UK); jama in South Slavic languages scientific and colloquial vocabulary (borrowed since early research in the Western Balkan Dinaric Alpine karst)—is a type of cave which contains one or more significant vertical shafts rather than being predominantly a conventional horizontal cave passage. Pit caves typically form in limestone as a result of long-term erosion by water.

In the real world, the deepest known vertical drop in a cave is 603m in Vrtoglavica Cave in Slovenia. This mod adds pits of varying depth, with some under the default settings being up to 2500m deep. They are widely scattered and not all of them breach the surface, so they are a rare find, but with the right tools a pit cave can give access to a huge swath of underground terrain.

## Settings and commands

The following settings are available for configuring pit cave generation:

    pit_caves_min_bottom (Lower limit of bottoms of pits) int -2500
    pit_caves_max_bottom (Upper limit of bottoms of pits) int -500
    pit_caves_min_top (Lower limit of tops of pits) int -100
    pit_caves_max_top (Upper limit of tops of pits) int 100
    pit_caves_mapblock_spacing (Average number of map blocks between pits) int 16
    pit_caves_seal_ocean (Seal off pits that are under ocean water) bool true

The pit_caves_seal_ocean setting isn't perfect, some map generation scenarios can result in a gap through which water can flow. But it's better than having drain holes everywhere.

Users with the "server" privilege can use the ``/find_pit_caves`` command, which will list the locations of nearby pit caves.