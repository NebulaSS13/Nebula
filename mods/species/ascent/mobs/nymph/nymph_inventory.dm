/mob/living/carbon/alien/ascent_nymph/Initialize(var/mapload)
	. = ..()
	add_held_item_slot(new /datum/inventory_slot/gripper/mouth/ascent_nymph)

/decl/material
	var/crystalline_matter = 0
/decl/material/solid/sand
	crystalline_matter = 0.5
/decl/material/solid/quartz
	crystalline_matter = 1
/decl/material/solid/glass
	crystalline_matter = 0.75
/decl/material/solid/gemstone
	crystalline_matter = 1
/decl/material/solid/gemstone/crystal
	crystalline_matter = 1.25

/datum/inventory_slot/gripper/mouth/ascent_nymph/equipped(mob/living/user, obj/item/prop, var/silent = FALSE)

	var/mob/living/carbon/alien/ascent_nymph/baby = user
	if(!istype(user))
		return FALSE

	var/crystals = 0
	for(var/mat in prop?.matter)
		var/decl/material/crystal = GET_DECL(mat)
		if(crystal.crystalline_matter > 0)
			crystals += prop.matter[mat] * crystal.crystalline_matter
	crystals = round(crystals)

	. = ..()

	if(. && !QDELETED(baby) && crystals > 0)
		if(baby.crystal_reserve < ANYMPH_MAX_CRYSTALS)
			baby.crystal_reserve = min(ANYMPH_MAX_CRYSTALS, baby.crystal_reserve + crystals)
			if(!QDELETED(prop))
				qdel(prop)
		else
			to_chat(user, SPAN_WARNING("You've already filled yourself with as much crystalline matter as you can!"))

/datum/inventory_slot/gripper/mouth/ascent_nymph
	slot_name = "Mouth"
	ui_loc = "CENTER-1:16,BOTTOM:5"
	ui_label = null
