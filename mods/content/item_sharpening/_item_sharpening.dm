#define IE_PAR_SHARP_DAM_MULT "sharp_dam_mult"

/decl/modpack/item_sharpening
	name = "Item Sharpening"

/obj/proc/get_sharpening_material()
	RETURN_TYPE(/decl/material)
	return get_material()
