/obj/item/tool/hoe
	name = "hoe"
	desc = "It's used for removing weeds or scratching your back."
	icon = 'icons/obj/items/tool/hoes/hoe.dmi'
	sharp = TRUE
	edge = TRUE
	attack_verb = list("slashed", "sliced", "cut", "clawed")
	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

/obj/item/tool/hoe/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(TOOL_HOE = TOOL_QUALITY_DEFAULT)
	return tool_qualities

/obj/item/tool/hoe/mini
	name = "mini hoe"
	icon = 'icons/obj/items/tool/hoes/minihoe.dmi'
	material_alteration = 0
	handle_material     = /decl/material/solid/organic/plastic
	w_class             = ITEM_SIZE_SMALL

/obj/item/tool/hoe/mini/get_handle_color()
	return null

/obj/item/tool/hoe/mini/unbreakable
	max_health = ITEM_HEALTH_NO_DAMAGE
