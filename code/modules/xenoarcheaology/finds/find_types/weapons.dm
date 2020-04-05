// Smol blade
/decl/archaeological_find/knife
	item_type = "knife"
	responsive_reagent = /datum/reagent/iron
	possible_types = list(/obj/item/material/knife/combat)

/decl/archaeological_find/knife/generate_name()
	return pick("bladed knife","serrated blade","sharp cutting implement")

/decl/archaeological_find/knife/get_additional_description()
	return pick(
		"It doesn't look safe.",
		"It looks wickedly jagged.",
		"There appear to be [pick("dark red","dark purple","dark green","dark blue")] stains along the edges.")
		
/decl/archaeological_find/knife/new_icon_state()
	return "knife[rand(1,3)]"

// Big blade
/decl/archaeological_find/sword
	item_type = "blade"
	responsive_reagent = /datum/reagent/iron
	possible_types = list(
		/obj/item/material/sword,
		/obj/item/material/sword/katana
		)

/decl/archaeological_find/sword/new_icon_state()
	return "sword[rand(1,3)]"

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