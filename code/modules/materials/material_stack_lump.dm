/obj/item/stack/material/lump
	name = "lumps"
	singular_name = "lump"
	plural_name = "lumps"
	icon_state = "lump"
	plural_icon_state = "lump-mult"
	max_icon_state = "lump-max"
	stack_merge_type = /obj/item/stack/material/lump
	crafting_stack_type = /obj/item/stack/material/lump
	craft_verb = "sculpt"
	craft_verbing = "sculpting"
	can_be_pulverized = TRUE
	matter_multiplier = 1.5

// Override as squashing items produces this item type.
/obj/item/stack/material/lump/squash_item(skip_qdel = FALSE)
	return

/obj/item/stack/material/lump/get_stack_conversion_dictionary()
	var/static/list/converts_into = list(
		TOOL_HAMMER = /obj/item/stack/material/brick
	)
	return converts_into

/obj/item/stack/material/lump/clay
	material = /decl/material/solid/clay
	is_spawnable_type = TRUE

/obj/item/stack/material/lump/large
	base_state        = "lump_large"
	icon_state        = "lump_large"
	plural_icon_state = "lump_large-mult"
	max_icon_state    = "lump_large-max"
	stack_merge_type  = /obj/item/stack/material/lump/large
	crafting_stack_type = /obj/item/stack/material/lump/large
	matter_multiplier = 3

/obj/item/stack/material/lump/large/clay
	material = /decl/material/solid/clay
	is_spawnable_type = TRUE

/obj/item/stack/material/lump/large/soil
	material = /decl/material/solid/soil
	is_spawnable_type = TRUE
