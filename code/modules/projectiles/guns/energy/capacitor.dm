var/global/list/laser_wavelengths

/decl/laser_wavelength
	var/name
	var/color
	var/light_color
	var/damage_multiplier
	var/armour_multiplier

/decl/laser_wavelength/red
	name = "638nm"
	color = COLOR_RED
	light_color = COLOR_RED_LIGHT
	damage_multiplier = 1
	armour_multiplier = 0.1

/decl/laser_wavelength/yellow
	name = "589nm"
	color = COLOR_GOLD
	light_color = COLOR_GOLD
	damage_multiplier = 0.9
	armour_multiplier = 0.2

/decl/laser_wavelength/green
	name = "515nm"
	color = COLOR_LIME
	light_color = COLOR_LIME
	damage_multiplier = 0.8
	armour_multiplier = 0.3

/decl/laser_wavelength/blue
	name = "473nm"
	color = COLOR_CYAN
	light_color = COLOR_BLUE_LIGHT
	damage_multiplier = 0.7
	armour_multiplier = 0.4

/decl/laser_wavelength/violet
	name = "405nm"
	color = "#ff00dc"
	light_color = "#ff00dc"
	damage_multiplier = 0.6
	armour_multiplier = 0.5

/obj/item/gun/hand/capacitor_pistol
	name = "capacitor pistol"
	desc = "An excitingly chunky directed energy weapon that uses a modular capacitor array to charge each shot."
	icon = 'icons/obj/guns/capacitor_pistol.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'combat':4,'materials':4,'powerstorage':4}"
	w_class = ITEM_SIZE_NORMAL
	accuracy = 2
	fire_delay = 10
	slot_flags = SLOT_LOWER_BODY
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)
	barrel = /obj/item/firearm_component/barrel/energy/capacitor
	receiver = /obj/item/firearm_component/receiver/energy/capacitor

// Subtypes.
/obj/item/gun/long/capacitor_rifle
	name = "capacitor rifle"
	desc = "A heavy, unwieldly directed energy weapon that uses a linear capacitor array to charge a powerful beam."
	icon = 'icons/obj/guns/capacitor_rifle.dmi'
	slot_flags = SLOT_BACK
	fire_delay = 20
	w_class = ITEM_SIZE_HUGE
	barrel = /obj/item/firearm_component/barrel/energy/capacitor/rifle
	receiver = /obj/item/firearm_component/receiver/energy/capacitor/rifle

/obj/item/gun/long/linear_fusion
	name = "linear fusion rifle"
	desc = "A chunky, angular, carbon-fiber-finish capacitor rifle, shipped complete with a self-charging power cell. The operating instructions seem to be written in backwards Cyrillic."
	color = COLOR_GRAY40
	barrel = /obj/item/firearm_component/barrel/energy/capacitor/rifle/lfr
	receiver = /obj/item/firearm_component/receiver/energy/capacitor/rifle/lfr
