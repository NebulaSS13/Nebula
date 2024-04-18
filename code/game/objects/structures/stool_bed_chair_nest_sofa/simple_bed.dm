/obj/structure/bed/simple
	desc = "A slatted wooden bed with a thin straw matress."
	icon = 'icons/obj/structures/simple_bed.dmi'
	parts_type = /obj/item/stack/material/plank
	material = /decl/material/solid/organic/wood
	reinf_material = /decl/material/solid/organic/plantmatter/grass/dry
	anchored = TRUE
	user_comfort = 0.8

/obj/structure/bed/simple/crafted
	reinf_material = null

/obj/item/bedsheet/furs
	name = "sleeping furs"
	desc = "Some cured hides and furs, soft enough to be a good blanket."
	icon = 'icons/obj/items/sleeping_furs.dmi'
	item_state = null
	material_alteration = MAT_FLAG_ALTERATION_DESC | MAT_FLAG_ALTERATION_COLOR
	material = /decl/material/solid/organic/skin/fur
