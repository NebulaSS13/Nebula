/mob/living/carbon/alien/ascent_nymph/proc/contains_crystals(var/obj/item/W)
	for(var/mat in W.matter)
		if(mat == /decl/material/solid/sand)
			. += W.matter[mat]
		else if(mat == /decl/material/solid/gemstone/crystal)
			. += W.matter[mat]
		else if(mat == /decl/material/solid/quartz)
			. += W.matter[mat]
		else if(mat == /decl/material/solid/glass)
			. += W.matter[mat]

/datum/inventory_slot/gripper/mouth/nymph/ascent/equipped(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE, var/delete_old_item = TRUE)
	var/mob/living/carbon/alien/ascent_nymph/nimp = user
	var/crystals = istype(nimp) ? nimp.contains_crystals(prop) : 0
	. = ..()
	if(. && crystals)
		nimp.crystal_reserve = min(ANYMPH_MAX_CRYSTALS, nimp.crystal_reserve + crystals)
		if(nimp.crystal_reserve >= ANYMPH_MAX_CRYSTALS)
			to_chat(src, SPAN_WARNING("You've filled yourself with as much crystalline matter as you can!"))
		if(!QDELETED(prop))
			qdel(prop)
