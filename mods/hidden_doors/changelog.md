# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/).


## [Unreleased]

	- No other feature planned.



## [1.12.0] - 2019-11-13
## Added

	- Permafrost hidden door (if permafrost node available).
	- Support for Minetest engine v5.x translator.


## Changed

	- License changed to EUPL v1.2.
	- Code style and formatting refresh.
	- Textures have been optimized using optipng.



## [1.11] - 2018-09-12
### Added

	Painted doors, thanks to Treer



## [1.10.2] - 2018-07-12
### Added

	screenshot.png

### Changed

	Default options' values are no longer written on minetest.conf.
	Minor code changes.
	changelog.txt -> changelog.md
	README.txt -> README.md



## [1.10.1]
### Changed
	Code fix due to changed or removed Moreblocks nodes.



## [1.10.0]
### Added

	Added self removing option.
	Settings/Advanced Settings/Mods/hidden_doors



## [1.9.0]
### Added

	Added sand, silver sand and desert sand doors.



## [1.8.0]
### Added

	Added support for the Moreblocks module.
	Added bookshelf door from Minetest Game (vessels dependency).

### Changed

	Moved the doors registrations into subfiles named after their
	respective modules (e.g. darkage.lua); for an easier maintenance.



## [1.7.2]
### Changed

	Removed goto statement, changed the code to accomplish the same
	task without it.



## [1.7.1]
### Changed

	Disabled textures' scaling for Darkage: when using texture packs
	having a resolution higher than 16px, Darkage's textures will be
	kept at their native resolution.



## [1.7.0]
### Added

	Added support for the Darkage module (Addi's fork).



## [1.6.0]
### Added

	Texture resolution configurable via GUI under Advanced Settings.
	Stone doors' sound volume as above.
	Hardcoded check for invalid resolutions.
	Hidden doors made of ice.
	Locale template updated.
	Italian locale updated.



## [1.5.2]
### Changed

	Minor fix - Stone doors' sound increased.



## [1.5.1]
### Changed

	Bugfix - Textures applied correctly to doors, inventory images are generated
	as they should. Napiophelios



## [1.5.0]
### Added

	New hidden doors: dirt, brick, metals, gems.



## [1.4.0]
### Changed

	Texture combiner's code changed to be more easier to understand and mantain.
	Optional support for resolutions higher than 16px using
	hidden_doors_res = <number> into minetest.conf; defaults to 16.
	Supported resolutions: 16, 32, 64, 128, 256, 512



## [1.3.0]
### Added

	Added the opening and closing sounds for the stone doors.

### Changed

	Changed the module's description.
	Code re-formatted to fit into 80 columns.
	Recipes changed to prevent any conflict.



## [1.2.0]
### Added

	Added localization support: intllib by Diego Martínez (kaeza)
	Added the Italian locale file.

### Changed

	Updated the function to handle sound's specification to allow different
	sounds for different materials doors.



## [1.1.0]
### Added

	Napiophelios added texture handling and the function to dynamically
	register the doors.
	Hamlet added the new doors.



## [1.0.0]
### Added

	Initial stable release.
	Cobble, stone and stone brick's doors available.
