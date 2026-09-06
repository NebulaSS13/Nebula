/obj/item/shears
	name = "shears"
	desc = "A pair of sturdy shears mainly used to clip wool."
	icon = 'icons/obj/items/shears.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	origin_tech = @'{"materials":1,"engineering":1}'
	material = /decl/material/solid/metal/steel
	color = /decl/material/solid/metal/steel::color
	center_of_mass = @'{"x":18,"y":10}'
	attack_verb = list("sheared", "cut")
	sharp = TRUE
	edge = TRUE
	material_alteration = MAT_FLAG_ALTERATION_COLOR
	drop_sound = 'sound/foley/singletooldrop1.ogg'

/obj/item/shears/Initialize(ml, material_key)
	. = ..()
	set_extension(src, /datum/extension/tool, list(
		TOOL_SHEARS      = TOOL_QUALITY_DEFAULT,
		TOOL_WIRECUTTERS = TOOL_QUALITY_BAD
	))
