
/obj/item/stack/material/brick
	name = "bricks"
	singular_name = "brick"
	plural_name = "bricks"
	icon_state = "brick"
	plural_icon_state = "brick-mult"
	max_icon_state = "brick-max"
	stack_merge_type = /obj/item/stack/material/brick
	crafting_stack_type = /obj/item/stack/material/brick
	can_be_pulverized = TRUE

// Extra subtype defined for the clay stack recipes to not freak out about null material.
/obj/item/stack/material/brick/clay
	material = /decl/material/solid/clay
	is_spawnable_type = TRUE
