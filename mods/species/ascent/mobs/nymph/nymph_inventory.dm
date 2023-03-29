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

/datum/inventory_slot/gripper/mouth/ascent_nymph
	slot_name = "Mouth"
	ui_loc = "CENTER-1:16,BOTTOM:5"
	ui_label = null

/datum/inventory_slot/gripper/mouth/ascent_nymph/equipped(mob/living/user, obj/item/prop, var/silent = FALSE)
	var/mob/living/carbon/alien/ascent_nymph/baby = user
	if(!istype(baby))
		return FALSE
	var/crystals = 0
	for(var/mat in prop?.matter)
		var/decl/material/M = GET_DECL(mat)
		crystals += M.crystalline_matter * prop.matter[mat]
	crystals = round(crystals)
	. = ..()
	if(. && !QDELETED(baby) && crystals > 0)
		if(baby.crystal_reserve < ANYMPH_MAX_CRYSTALS)
			baby.crystal_reserve = min(ANYMPH_MAX_CRYSTALS, baby.crystal_reserve + crystals)
			if(!QDELETED(prop))
				qdel(prop)

/mob/living/carbon/alien/ascent_nymph/verb/drop_item_verb()
	set name = "Drop Held Item"
	set desc = "Drop the item you are currently holding inside."
	set category = "IC"
	set src = usr
	drop_item()
