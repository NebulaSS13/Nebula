// SEE code/modules/materials/materials.dm FOR DETAILS ON INHERITED DATUM.
// This class of weapons takes force and appearance data from a material datum.
// They are also fragile based on material data and many can break/smash apart.
/obj/item/material
	hitsound = 'sound/weapons/bladeslice.ogg'
	throw_speed = 3
	throw_range = 7
	w_class = ITEM_SIZE_NORMAL
	sharp = 0
	edge = 0
	material = MAT_STEEL
	applies_material_colour = TRUE
	applies_material_name = TRUE
