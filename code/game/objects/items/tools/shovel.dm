/obj/item/shovel
	name        = "shovel"
	desc        = "A large tool for digging and moving dirt."
	icon        = 'icons/obj/items/tool/shovels/shovel.dmi'
	icon_state  = ICON_STATE_WORLD
	slot_flags  = SLOT_LOWER_BODY
	force       = 8.0
	throwforce  = 4
	w_class     = ITEM_SIZE_HUGE
	origin_tech = @'{"materials":1,"engineering":1}'
	material    = /decl/material/solid/metal/steel
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	edge        = 1
	var/tmp/shovel_quality = TOOL_QUALITY_DEFAULT

/obj/item/shovel/Initialize(ml, material_key)
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_SHOVEL = shovel_quality))

/obj/item/shovel/can_puncture() //includes spades
	return TRUE

/obj/item/shovel/spade
	name           = "spade"
	desc           = "A small tool for digging and moving dirt."
	icon           = 'icons/obj/items/tool/shovels/spade.dmi'
	icon_state     = ICON_STATE_WORLD
	force          = 5.0
	throwforce     = 7
	w_class        = ITEM_SIZE_SMALL
	shovel_quality = TOOL_QUALITY_BAD //You're not gonna dig a trench with a garden spade..
