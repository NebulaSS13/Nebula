/obj/item/chems/waterskin
	name = "waterskin"
	desc = "A water-carrying vessel made from the dried stomach of some unfortunate animal."
	icon = 'icons/obj/items/waterskin.dmi'
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/organic/leather/gut
	volume = 120
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

/obj/item/chems/waterskin/crafted
	desc = "A long and rather unwieldly water-carrying vessel."
	material = /decl/material/solid/organic/leather
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC

/obj/item/chems/waterskin/crafted/wine
	name = "wineskin"

/obj/item/chems/waterskin/crafted/wine/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/ethanol/wine, reagents?.total_volume)
