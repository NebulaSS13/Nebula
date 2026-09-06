/mob/living/simple_animal/alien/kharmaan/proc/contains_crystals(var/obj/item/prop)
	. += prop.matter[/decl/material/solid/sand]
	. += prop.matter[/decl/material/solid/gemstone/crystal]
	. += prop.matter[/decl/material/solid/quartz]
	. += prop.matter[/decl/material/solid/glass]

/datum/inventory_slot/gripper/mouth/nymph/ascent/equipped(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE, var/delete_old_item = TRUE)
	var/mob/living/simple_animal/alien/kharmaan/nimp = user
	var/crystals = istype(nimp) ? nimp.contains_crystals(prop) : 0
	. = ..()
	if(. && crystals)
		nimp.crystal_reserve = min(ANYMPH_MAX_CRYSTALS, nimp.crystal_reserve + crystals)
		if(nimp.crystal_reserve >= ANYMPH_MAX_CRYSTALS)
			to_chat(src, SPAN_WARNING("You've filled yourself with as much crystalline matter as you can!"))
		if(!QDELETED(prop))
			qdel(prop)
