/obj/item/archaeological_find/robes
	item_type = "garments"
	find_type = ARCHAEO_CULTROBES

/obj/item/archaeological_find/robes/spawn_item()
	var/list/possible_spawns = list(/obj/item/clothing/head/culthood,
	/obj/item/clothing/head/culthood/magus,
	/obj/item/clothing/head/culthood/alt,
	/obj/item/clothing/head/helmet/space/cult)
	var/new_type = pick(possible_spawns)
	return new new_type(loc)

/obj/item/archaeological_find/blade
	item_type = "blade"
	find_type = ARCHAEO_CULTBLADE
	apply_prefix = 0
	apply_material_decorations = 0
	apply_image_decorations = 0

/obj/item/archaeological_find/blade/spawn_item()
	return new /obj/item/melee/cultblade(loc)

/obj/machinery/artifact_analyser/get_scan_info(var/obj/scanned_obj)
	if(scanned_obj)
		if(scanned_obj.type == /obj/structure/constructshell)
			return "Tribal idol - subject resembles statues/emblems built by superstitious pre-warp civilisations to honour their gods. Material appears to be a rock/plastcrete composite."
		if(scanned_obj.type == /obj/structure/cult/pylon)
			return "Tribal pylon - subject resembles statues/emblems built by cargo cult civilisations to honour energy systems from post-warp civilisations."
	. = ..()
