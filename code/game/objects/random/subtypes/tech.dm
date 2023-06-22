/obj/random/technology_scanner
	name = "random scanner"
	desc = "This is a random technology scanner."
	icon = 'icons/obj/items/device/scanner/atmos_scanner.dmi'
	icon_state = "atmos"

/obj/random/technology_scanner/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/t_scanner =            5,
		/obj/item/radio/off =            2,
		/obj/item/scanner/reagent =      2,
		/obj/item/scanner/spectrometer = 2,
		/obj/item/scanner/gas =          5
	)
	return spawnable_choices

/obj/random/powercell
	name = "random powercell"
	desc = "This is a random powercell."
	icon = 'icons/obj/power.dmi'
	icon_state = "hcell"

/obj/random/powercell/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/cell/crap =            1,
		/obj/item/cell =                 8,
		/obj/item/cell/high =            5,
		/obj/item/cell/gun=              5,
		/obj/item/cell/super =           2,
		/obj/item/cell/hyper =           1,
		/obj/item/cell/device/standard = 7,
		/obj/item/cell/device/high =     5
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
		/obj/random/powercell =                     3,
		/obj/random/technology_scanner =            2,
		/obj/item/stack/package_wrap/twenty_five =  1,
		/obj/item/hand_labeler =                    1,
		/obj/random/bomb_supply =                   2,
		/obj/item/chems/spray/extinguisher =                    1,
		/obj/item/clothing/gloves/insulated/cheap = 1,
		/obj/item/stack/cable_coil/random =         2,
		/obj/random/toolbox =                       2,
		/obj/item/storage/belt/utility =            2,
		/obj/item/storage/belt/utility/atmostech =  1,
		/obj/random/tool =                          5,
		/obj/item/stack/tape_roll/duct_tape =       2
	)
	return spawnable_choices

/obj/random/tank
	name = "random tank"
	desc = "This is a tank."
	icon = 'icons/obj/items/tanks/tank_blue.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/tank/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/tank/oxygen =                      5,
		/obj/item/tank/oxygen/yellow =               4,
		/obj/item/tank/emergency/oxygen/double/red = 4,
		/obj/item/tank/air =                         3,
		/obj/item/tank/emergency/oxygen =            4,
		/obj/item/tank/emergency/oxygen/engi =       3,
		/obj/item/tank/emergency/oxygen/double =     2,
		/obj/item/tank/nitrogen =                    1,
		/obj/item/suit_cooling_unit =                1
	)
	return spawnable_choices

/obj/random/assembly
	name = "random assembly"
	desc = "This is a random circuit assembly."
	icon = 'icons/obj/items/gift_wrapped.dmi'
	icon_state = "gift1"

/obj/random/assembly/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/electronic_assembly,
		/obj/item/electronic_assembly/medium,
		/obj/item/electronic_assembly/large,
		/obj/item/electronic_assembly/drone
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
