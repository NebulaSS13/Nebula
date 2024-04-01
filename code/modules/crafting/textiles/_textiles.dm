/obj/structure/textiles

	abstract_type = /obj/structure/textiles
	icon_state = ICON_STATE_WORLD
	anchored = TRUE
	density = TRUE
	material = /decl/material/solid/organic/wood
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC

	var/tmp/working  = FALSE
	var/work_skill   = SKILL_CONSTRUCTION
	var/product_type
