/obj/item/toolbox
	name = "toolbox"
	desc = "Bright red toolboxes like these are one of the most common sights in maintenance corridors on virtually every ship in the galaxy."
	icon = 'icons/obj/items/storage/toolboxes/toolbox_red.dmi'
	icon_state = ICON_STATE_WORLD
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	attack_cooldown = 21
	melee_accuracy_bonus = -15
	throw_speed = 1
	throw_range = 7
	w_class = ITEM_SIZE_LARGE
	storage = /datum/storage/toolbox
	origin_tech = @'{"combat":1}'
	attack_verb = list("robusted")
	material = /decl/material/solid/metal/aluminium
	_base_attack_force = 20

/obj/item/toolbox/emergency
	name = "emergency toolbox"

/obj/item/toolbox/emergency/WillContain()
	return list(
		new /datum/atom_creator/weighted(list(/obj/item/flashlight, /obj/item/flashlight/flare,  /obj/item/flashlight/flare/glowstick/red)),
		/obj/item/crowbar/red,
		/obj/item/chems/spray/extinguisher/mini,
		/obj/item/radio/shortwave,
		/obj/item/weldingtool/mini,
		/obj/item/chems/welder_tank/mini
	)

/obj/item/toolbox/mechanical
	name = "mechanical toolbox"
	desc = "Bright blue toolboxes like these are one of the most common sights in maintenance corridors on virtually every ship in the galaxy."
	icon = 'icons/obj/items/storage/toolboxes/toolbox_blue.dmi'

/obj/item/toolbox/mechanical/WillContain()
	return list(
			/obj/item/screwdriver,
			/obj/item/wrench,
			/obj/item/weldingtool,
			/obj/item/crowbar,
			/obj/item/scanner/gas,
			/obj/item/wirecutters
		)

/obj/item/toolbox/electrical
	name = "electrical toolbox"
	desc = "Bright yellow toolboxes like these are one of the most common sights in maintenance corridors on virtually every ship in the galaxy."
	icon = 'icons/obj/items/storage/toolboxes/toolbox_yellow.dmi'


/obj/item/toolbox/electrical/WillContain()
	return list(
			new /datum/atom_creator/weighted(list(/obj/item/clothing/gloves/insulated = 5, /obj/item/stack/cable_coil/random = 95)),
			/obj/item/stack/cable_coil/random = 2,
			/obj/item/screwdriver,
			/obj/item/wirecutters,
			/obj/item/t_scanner,
			/obj/item/crowbar
		)

/obj/item/toolbox/syndicate
	name = "black and red toolbox"
	desc = "A toolbox in black, with stylish red trim. This one feels particularly heavy, yet balanced."
	icon = 'icons/obj/items/storage/toolboxes/toolbox_black_red.dmi'
	origin_tech = @'{"combat":1,"esoteric":1}'
	attack_cooldown = 10

/obj/item/toolbox/syndicate/WillContain()
	return list(
			/obj/item/clothing/gloves/insulated,
			/obj/item/screwdriver,
			/obj/item/wrench,
			/obj/item/weldingtool,
			/obj/item/crowbar,
			/obj/item/wirecutters,
			/obj/item/multitool
		)

/obj/item/toolbox/syndicate/powertools/WillContain()
	return list(
			/obj/item/clothing/gloves/insulated,
			/obj/item/tool/power_drill,
			/obj/item/weldingtool/electric,
			/obj/item/tool/hydraulic_cutter,
			/obj/item/multitool
		)

/obj/item/toolbox/repairs
	name = "electronics toolbox"
	desc = "A box full of boxes, with electrical machinery parts and tools needed to get them where they're needed."
	icon = 'icons/obj/items/storage/toolboxes/toolbox_yellow_striped.dmi'

/obj/item/toolbox/repairs/WillContain()
	return list(
		/obj/item/stack/cable_coil,
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/crowbar,
		/obj/item/wirecutters,
		/obj/item/box/parts_pack/manipulator,
		/obj/item/box/parts_pack/laser,
		/obj/item/box/parts_pack/capacitor,
		/obj/item/box/parts_pack/keyboard,
		/obj/item/box/parts
	)
