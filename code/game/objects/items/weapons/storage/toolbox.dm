/obj/item/storage/toolbox
	name = "toolbox"
	desc = "Bright red toolboxes like these are one of the most common sights in maintenance corridors on virtually every ship in the galaxy."
	icon = 'icons/obj/items/storage/toolbox.dmi'
	icon_state = "red"
	item_state = "toolbox_red"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 20
	attack_cooldown = 21
	melee_accuracy_bonus = -15
	throwforce = 10
	throw_speed = 1
	throw_range = 7
	w_class = ITEM_SIZE_LARGE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_LARGEBOX_STORAGE //enough to hold all starting contents
	origin_tech = "{'combat':1}"
	attack_verb = list("robusted")
	use_sound = 'sound/effects/storage/toolbox.ogg'

/obj/item/storage/toolbox/emergency
	name = "emergency toolbox"
	startswith = list(
		/obj/item/crowbar/red,
		/obj/item/extinguisher/mini,
		/obj/item/radio,
		/obj/item/weldingtool/mini,
		/obj/item/welder_tank/mini
	)

/obj/item/storage/toolbox/emergency/Initialize()
	. = ..()
	var/item = pick(list(/obj/item/flashlight, /obj/item/flashlight/flare,  /obj/item/flashlight/flare/glowstick/red))
	new item(src)


/obj/item/storage/toolbox/mechanical
	name = "mechanical toolbox"
	desc = "Bright blue toolboxes like these are one of the most common sights in maintenance corridors on virtually every ship in the galaxy."
	icon_state = "blue"
	item_state = "toolbox_blue"
	startswith = list(/obj/item/screwdriver, /obj/item/wrench, /obj/item/weldingtool, /obj/item/crowbar, /obj/item/scanner/gas, /obj/item/wirecutters)

/obj/item/storage/toolbox/electrical
	name = "electrical toolbox"
	desc = "Bright yellow toolboxes like these are one of the most common sights in maintenance corridors on virtually every ship in the galaxy."
	icon_state = "yellow"
	item_state = "toolbox_yellow"
	startswith = list(/obj/item/screwdriver, /obj/item/wirecutters, /obj/item/t_scanner, /obj/item/crowbar)

/obj/item/storage/toolbox/electrical/Initialize()
	. = ..()
	new /obj/item/stack/cable_coil/random(src,30)
	new /obj/item/stack/cable_coil/random(src,30)
	if(prob(5))
		new /obj/item/clothing/gloves/insulated(src)
	else
		new /obj/item/stack/cable_coil/random(src,30)

/obj/item/storage/toolbox/syndicate
	name = "black and red toolbox"
	desc = "A toolbox in black, with stylish red trim. This one feels particularly heavy, yet balanced."
	icon_state = "syndicate"
	item_state = "toolbox_syndi"
	origin_tech = "{'combat':1,'esoteric':1}"
	attack_cooldown = 10
	startswith = list(/obj/item/clothing/gloves/insulated, /obj/item/screwdriver, /obj/item/wrench, /obj/item/weldingtool, /obj/item/crowbar, /obj/item/wirecutters, /obj/item/multitool)

/obj/item/storage/toolbox/repairs
	name = "electrician toolbox"
	desc = "A box full of boxes, with electrical machinery parts and tools needed to get them where they're needed."
	icon_state = "yellow_striped"
	item_state = "yellow"
	startswith = list(
		/obj/item/stack/cable_coil,
		/obj/item/screwdriver, 
		/obj/item/wrench,
		/obj/item/crowbar, 
		/obj/item/wirecutters,
		/obj/item/storage/box/parts_pack/manipulator,
		/obj/item/storage/box/parts_pack/laser,
		/obj/item/storage/box/parts_pack/capacitor,
		/obj/item/storage/box/parts_pack/keyboard,
		/obj/item/storage/box/parts
	)
