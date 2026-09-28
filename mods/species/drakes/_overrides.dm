/obj/item
	var/_drake_onmob_icon
	var/_drake_hatchling_onmob_icon

/obj/item/setup_sprite_sheets()
	. = ..()
	if(_drake_onmob_icon)
		LAZYSET(sprite_sheets, BODYTYPE_GRAFADREKA, _drake_onmob_icon)
	if(_drake_hatchling_onmob_icon)
		LAZYSET(sprite_sheets, BODYTYPE_GRAFADREKA_HATCHLING, _drake_hatchling_onmob_icon)

// Drakenip...
/decl/material/solid/spices/affect_blood(mob/living/M, removed, datum/reagents/holder)
	. = ..()
	if(M.get_species_name() == /decl/species/grafadreka::name)
		SET_STATUS_MAX(M, STAT_DRUGGY, 15)
