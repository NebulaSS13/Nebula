/mob/get_base_value()
	. = 0.5 * mob_size
	if(stat != DEAD)
		. *= 1.5
	. = max(round(.), mob_size)

/mob/living/carbon/human/get_base_value()
	. = round(..() * species.rarity_value)

/mob/living/get_base_value()
	. = ..()
	if(meat_type)
		. += atom_info_repository.get_combined_worth_for(meat_type) * meat_amount
	if(skin_material)
		var/decl/material/M = decls_repository.get_decl(skin_material)
		. += skin_amount * M.value * 10
	if(bone_material)
		var/decl/material/M = decls_repository.get_decl(bone_material)
		. += bone_amount * M.value * 10
	if(skull_type)
		.+= atom_info_repository.get_combined_worth_for(skull_type)
	. = round(.)
