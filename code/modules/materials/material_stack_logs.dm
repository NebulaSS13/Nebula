/obj/item/stack/material/plank
	name = "planks"
	singular_name = "plank"
	plural_name = "planks"
	icon_state = "sheet-wood"
	plural_icon_state = "sheet-wood-mult"
	max_icon_state = "sheet-wood-max"
	pickup_sound = 'sound/foley/wooden_drop.ogg'
	drop_sound = 'sound/foley/wooden_drop.ogg'
	stack_merge_type = /obj/item/stack/material/plank
	crafting_stack_type = /obj/item/stack/material/plank

/obj/item/stack/material/log
	name = "logs"
	singular_name = "log"
	plural_name = "logs"
	icon_state = "log"
	plural_icon_state = "log-mult"
	max_icon_state = "log-max"
	stack_merge_type = /obj/item/stack/material/log
	crafting_stack_type = /obj/item/stack/material/log
	craft_verb = "whittle"
	craft_verbing = "whittling"
	matter_multiplier = 3

/obj/item/stack/material/log/get_stack_conversion_dictionary()
	var/static/list/converts_into = list(
		TOOL_HATCHET = /obj/item/stack/material/plank,
		TOOL_SAW = /obj/item/stack/material/plank
	)
	return converts_into
