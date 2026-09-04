/obj/random/technology_scanner
	name = "random scanner"
	desc = "This is a random technology scanner."
	icon = 'icons/obj/items/device/scanner/atmos_scanner.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/technology_scanner/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/t_scanner            = 5,
		/obj/item/radio/off            = 2,
		/obj/item/scanner/reagent      = 2,
		/obj/item/scanner/spectrometer = 2,
		/obj/item/scanner/gas          = 5
	)
	return spawnable_choices

/obj/random/powercell
	name = "random power cell"
	desc = "This is a random power cell."
	icon = 'icons/obj/power.dmi'
	icon_state = "hcell"

/obj/random/powercell/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/cell/crap            = 1,
		/obj/item/cell                 = 8,
		/obj/item/cell/high            = 5,
		/obj/item/cell/gun             = 5,
		/obj/item/cell/super           = 2,
		/obj/item/cell/hyper           = 1,
		/obj/item/cell/device/standard = 7,
		/obj/item/cell/device/high     = 5
	)
	return spawnable_choices

/obj/random/bomb_supply
	name = "bomb supply"
	desc = "This is a random bomb supply."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "signaller"

/obj/random/bomb_supply/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/assembly/igniter,
		/obj/item/assembly/prox_sensor,
		/obj/item/assembly/signaler,
		/obj/item/assembly/timer,
		/obj/item/multitool
	)
	return spawnable_choices

/obj/random/tech_supply
	name = "random tech supply"
	desc = "This is a random piece of technology supplies."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	spawn_nothing_percentage = 50

/obj/random/tech_supply/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/random/powercell                     = 3,
		/obj/random/technology_scanner            = 2,
		/obj/item/stack/package_wrap/twenty_five  = 1,
		/obj/item/hand_labeler                    = 1,
		/obj/random/bomb_supply                   = 2,
		/obj/item/chems/spray/extinguisher        = 1,
		/obj/item/clothing/gloves/insulated/cheap = 1,
		/obj/item/stack/cable_coil/random         = 2,
		/obj/random/toolbox                       = 2,
		/obj/item/belt/utility                    = 2,
		/obj/item/belt/utility/atmostech          = 1,
		/obj/random/tool                          = 5,
		/obj/item/stack/tape_roll/duct_tape       = 2
	)
	return spawnable_choices

/obj/random/tech_supply/nofail
	name = "guaranteed random tech supply"
	spawn_nothing_percentage = 0

/obj/random/tech_supply/component
	name = "random tech component"
	desc = "This is a random machine component."

/obj/random/tech_supply/component/nofail
	name = "guaranteed random tech component"
	spawn_nothing_percentage = 0

/obj/random/tech_supply/component/spawn_choices()
	var/static/list/spawn_choices = list(
		/obj/item/stock_parts/console_screen = 2,
		/obj/item/stock_parts/capacitor = 3,
		/obj/item/stock_parts/capacitor/adv = 2,
		/obj/item/stock_parts/capacitor/super = 1,
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/stock_parts/manipulator/nano = 2,
		/obj/item/stock_parts/manipulator/pico = 1,
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/matter_bin/adv = 2,
		/obj/item/stock_parts/matter_bin/super = 1,
		/obj/item/stock_parts/scanning_module = 3,
		/obj/item/stock_parts/scanning_module/adv = 2,
		/obj/item/stock_parts/scanning_module/phasic = 1
	)
	return spawn_choices

/obj/random/tank
	name = "random tank"
	desc = "This is a tank."
	icon = 'icons/obj/items/tanks/tank_blue.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/tank/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/tank/oxygen                      = 5,
		/obj/item/tank/oxygen/yellow               = 4,
		/obj/item/tank/emergency/oxygen/double/red = 4,
		/obj/item/tank/air                         = 3,
		/obj/item/tank/emergency/oxygen            = 4,
		/obj/item/tank/emergency/oxygen/engi       = 3,
		/obj/item/tank/emergency/oxygen/double     = 2,
		/obj/item/tank/nitrogen                    = 1,
		/obj/item/suit_cooling_unit                = 1
	)
	return spawnable_choices

/obj/random/advdevice
	name = "random advanced device"
	desc = "This is a random advanced device."
	icon = 'icons/obj/items/gamekit.dmi'
	icon_state = "game_kit"

/obj/random/advdevice/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/flashlight/lantern,
		/obj/item/flashlight/flare,
		/obj/item/flashlight/pen,
		/obj/item/chems/toner_cartridge,
		/obj/item/paicard,
		/obj/item/destTagger,
		/obj/item/beartrap,
		/obj/item/handcuffs,
		/obj/item/camera,
		/obj/item/modular_computer/pda,
		/obj/item/card/emag_broken,
		/obj/item/radio/headset,
		/obj/item/flashlight/flare/glowstick/yellow,
		/obj/item/flashlight/flare/glowstick/orange,
		/obj/item/grenade/light,
		/obj/item/oxycandle
	)
	return spawnable_choices

/obj/random/hardsuit
	name = "random hardsuit"
	desc = "This is a random hardsuit."
	icon = 'icons/clothing/rigs/rig.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/hardsuit/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/rig/light/hacker/unlocked  = 4,
		/obj/item/rig/industrial/unlocked    = 5,
		/obj/item/rig/eva/unlocked           = 5,
		/obj/item/rig/light/stealth/unlocked = 4,
		/obj/item/rig/hazard/unlocked        = 3,
		/obj/item/rig/merc/empty/unlocked    = 1
	)
	return spawnable_choices

/obj/random/powercell
	name = "random powercell"
	desc = "This is a random powercell."
	icon = /obj/item/cell::icon
	icon_state = /obj/item/cell::icon_state

/obj/random/powercell/spawn_choices()
	var/static/list/spawn_choices = list(
		/obj/item/cell = 40,
		/obj/item/cell/gun = 25,
		/obj/item/cell/high = 25,
		/obj/item/cell/super = 9,
		/obj/item/cell/hyper = 1
	)
	return spawn_choices

/obj/random/smes_coil
	name = "random smes coil"
	desc = "This is a random smes coil."
	icon = /obj/item/stock_parts/smes_coil::icon
	icon_state = /obj/item/stock_parts/smes_coil::icon_state

/obj/random/smes_coil/spawn_choices()
	var/static/list/spawn_choices = list(
		/obj/item/stock_parts/smes_coil = 4,
		/obj/item/stock_parts/smes_coil/super_capacity = 1,
		/obj/item/stock_parts/smes_coil/super_io = 1
	)
	return spawn_choices
