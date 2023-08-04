/mob/price() //I don't care at this point, this is wrong on so many levels but I guess its okay
	. = ..() * 0.5 * mob_size
	if(stat != DEAD)
		. *= 1.5
	. = max(round(.), mob_size)

/mob/living/carbon/price()
	. = ..() * (species?.rarity_value || 1)

/mob/living/worth()
	. = ..()
	if(meat_type)
		. += atom_info_repository.get_worth_for(meat_type) * meat_amount
	if(skin_material)
		var/decl/material/M = GET_DECL(skin_material)
		. += skin_amount * M.value * SHEET_MATERIAL_AMOUNT * MATERIAL_WORTH_MULTIPLIER
	if(bone_material)
		var/decl/material/M = GET_DECL(bone_material)
		. += bone_amount * M.value * SHEET_MATERIAL_AMOUNT * MATERIAL_WORTH_MULTIPLIER
	if(skull_type)
		.+= atom_info_repository.get_worth_for(skull_type)
	. = round(.)
