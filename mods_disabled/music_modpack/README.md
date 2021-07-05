# music_modpack

![Screenshot](screenshot.png)

## Overview
Music modpack with API for easy in-game music playback and custom track registration.

## Requirements

- Minetest 5.0.0+
- Minetest_game 5.0.0+
- [sfinv_buttons](https://repo.or.cz/minetest_sfinv_buttons.git) (Optional, but highly recommended: easy way to open music settings menu)

## Features

- Time-based music
- Elevation-based music
- Formspec for music settings

## Settings
By default, settings menu is only available with `/musicsettings` command. If you have sfinv_buttons installed, music menu is available in inventory->more->music settings

## Adding your own music
Call music.register_track() with following definition:

```Lua
music.register_track({
    name = "my_track",
    length = 200,
    gain = 1,
    day = true,
    night = true,
    ymin = 0,
    ymax = 31000,
})
```

- name - name of the sound file in your mod sounds folder, without extension (.ogg)
- length - length of the track in seconds
- gain - volume, value from 0 to 1
- day - track will be played at day
- night - track will be played at night
- ymin - minimum elevation for track to play
- ymax - maximum elevation for track to play

## Settingtypes
Available settings that you can put in your minetest.conf directly, or access them via "Settings->All Settings->Mods->music_modpack" menu.

```
music_time_interval = integer, Interval between attempts to play music, default is 60
music_cleanup_interval = integer, interval between attempts to clean up player state, default is 5
music_global_gain = float, global music volume, default is 0.3
music_add_random_delay = boolean, if to add a random delay to interval between attempts, default is true
music_maximum_random_delay = - integer, maximum random delay in seconds, default is 30
music_display_playback_messages = boolean, display messages when music starts for a certain player, default is true
```

Music packs also provide settingtypes with corresponding height limits.

## Content
Default pack features 11 tracks from composer Kevin McLeod. Tracks are split into day tracks and night tracks. If music_dfcaverns is not enabled, night tracks also play underground (up to -31000).  
Music_dfcaverns is an additional pack of music for underground layers from [dfcaverns](https://github.com/FaceDeer/dfcaverns/), featuring 13 tracks from composer Kevin McLeod. Tracks split into three categories, each for one cavern layer from dfcaverns, and their heights are set accordingly. Dfcaverns modpack is not required, however, and it is recommended to enable this pack even without dfcaverns, unless client connection speed is an issue.

## License

Code is licensed under GPLv3.  

All music used in this mod was produced by Kevin McLeod and released under CC BY 4.0. [link to the license](https://creativecommons.org/licenses/by/4.0/).  
Original music can be found [here](https://incompetech.com/music/royalty-free/music.html).