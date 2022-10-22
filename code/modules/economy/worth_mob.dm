/mob/get_single_monetary_worth()
	. = 0.5 * mob_size
	if(stat != DEAD)
		. *= 1.5
	. = max(round(.), mob_size)

/mob/living/carbon/get_single_monetary_worth()
	. = ..()
	for(var/atom/movable/organ in get_organs())
		. += organ.get_combined_monetary_worth()

/mob/living/carbon/get_value_multiplier()
	. = species?.rarity_value || 1

/mob/living/get_single_monetary_worth()
	. = ..()
	if(meat_type)
		. += atom_info_repository.get_combined_worth_for(meat_type) * meat_amount
	if(skin_material)
		var/decl/material/M = GET_DECL(skin_material)
		. += skin_amount * M.value * 10
	if(bone_material)
		var/decl/material/M = GET_DECL(bone_material)
		. += bone_amount * M.value * 10
	if(skull_type)
		.+= atom_info_repository.get_combined_worth_for(skull_type)
	. = round(.)
