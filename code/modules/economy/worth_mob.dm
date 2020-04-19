#define MOB_BASE_VALUE 20
/mob/get_base_monetary_worth()
	. = MOB_BASE_VALUE * mob_size
	if(stat != DEAD)
		. *= 1.5
	. = max(round(.), mob_size)

/mob/living/carbon/human/get_base_monetary_worth()
	. = round(..() * species.rarity_value)
#undef MOB_BASE_VALUE

/mob/living/get_base_monetary_worth()
	. = ..()
	if(meat_type)
		. += atom_info_repository.get_worth_for(meat_type) * meat_amount
	if(skin_material)
		var/material/M = SSmaterials.get_material_datum(skin_material)
		. += skin_amount * SHEET_MATERIAL_AMOUNT * M.value
	if(bone_material)
		var/material/M = SSmaterials.get_material_datum(bone_material)
		. += bone_amount * SHEET_MATERIAL_AMOUNT * M.value
	if(skull_type)
		.+= atom_info_repository.get_worth_for(skull_type)

/mob/living/carbon/human/get_base_monetary_worth()
	. = ..()
	for(var/datum/reagent/R in vessel?.reagent_list)
		. += R.volume * R.get_value()
