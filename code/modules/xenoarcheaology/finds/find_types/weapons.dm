// Smol blade
/decl/archaeological_find/knife
	item_type = "knife"
	new_icon_state = ICON_STATE_WORLD
	responsive_reagent = /decl/material/solid/metal/iron
	possible_types = list(/obj/item/knife/combat)
	var/knife_icons = list(
		'icons/obj/items/weapon/knives/xenoarch/knife1.dmi',
		'icons/obj/items/weapon/knives/xenoarch/knife2.dmi',
		'icons/obj/items/weapon/knives/xenoarch/knife3.dmi'
	)

/decl/archaeological_find/knife/generate_name()
	return pick("bladed knife","serrated blade","sharp cutting implement")

/decl/archaeological_find/knife/get_additional_description()
	return pick(
		"It doesn't look safe.",
		"It looks wickedly jagged.",
		"There appear to be [pick("dark red","dark purple","dark green","dark blue")] stains along the edges.")
		
/decl/archaeological_find/knife/new_icon()
	return pick(knife_icons)

// Big blade
/decl/archaeological_find/sword
	item_type = "blade"
	new_icon_state = ICON_STATE_WORLD
	responsive_reagent = /decl/material/solid/metal/iron
	possible_types = list(
		/obj/item/sword,
		/obj/item/sword/katana
		)
	var/sword_icons = list(
		'icons/obj/items/weapon/swords/xenoarch/sword1.dmi',
		'icons/obj/items/weapon/swords/xenoarch/sword2.dmi',
		'icons/obj/items/weapon/swords/xenoarch/sword3.dmi'
	)

/decl/archaeological_find/sword/new_icon()
	return pick(sword_icons)

// Beartrap
/decl/archaeological_find/trap
	item_type = "trap"
	modification_flags = XENOFIND_APPLY_DECOR
	possible_types = list(/obj/item/beartrap)

/decl/archaeological_find/knife/generate_name()
	return "[pick("wicked","evil","byzantine","dangerous")] looking [pick("device","contraption","thing","trap")]"

/decl/archaeological_find/trap/get_additional_description()
	return pick("It looks like it could take a limb off.",
		"Could be some kind of animal trap?",
		"There appear to be [pick("dark red","dark purple","dark green","dark blue")] stains along part of it.")