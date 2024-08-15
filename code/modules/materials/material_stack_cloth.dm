/obj/item/stack/material/bolt
	name = "bolts"
	icon_state = "sheet-cloth"
	singular_name = "bolt"
	plural_name = "bolts"
	w_class = ITEM_SIZE_NORMAL
	stack_merge_type = /obj/item/stack/material/bolt
	crafting_stack_type = /obj/item/stack/material/bolt
	craft_verb = "tailor"
	craft_verbing = "tailoring"

// Subtypes for dyed cloth.
/obj/item/stack/material/bolt/yellow
	paint_color = "#ffbf00"
/obj/item/stack/material/bolt/teal
	paint_color = "#00e1ff"
/obj/item/stack/material/bolt/black
	paint_color = "#505050"
/obj/item/stack/material/bolt/green
	paint_color = "#b7f27d"
/obj/item/stack/material/bolt/purple
	paint_color = "#9933ff"
/obj/item/stack/material/bolt/blue
	paint_color = "#46698c"
/obj/item/stack/material/bolt/beige
	paint_color = "#ceb689"
/obj/item/stack/material/bolt/lime
	paint_color = "#62e36c"
/obj/item/stack/material/bolt/red
	paint_color = "#9d2300"

/obj/item/stack/material/thread
	name = "thread spools"
	singular_name = "thread spool"
	plural_name = "thread spools"
	stack_merge_type = /obj/item/stack/material/thread
	crafting_stack_type = /obj/item/stack/material/thread
	craft_verb = "weave"
	craft_verbing = "weaving"
	w_class = ITEM_SIZE_TINY
	matter_multiplier = 0.4
	icon_state = "thread"
	plural_icon_state = "thread-mult"
	max_icon_state = "thread-max"

/obj/item/stack/material/thread/cotton
	material = /decl/material/solid/organic/cloth
	is_spawnable_type = TRUE

/obj/item/stack/material/thread/yellow
	paint_color = "#ffbf00"
/obj/item/stack/material/thread/teal
	paint_color = "#00e1ff"
/obj/item/stack/material/thread/black
	paint_color = "#505050"
/obj/item/stack/material/thread/green
	paint_color = "#b7f27d"
/obj/item/stack/material/thread/purple
	paint_color = "#9933ff"
/obj/item/stack/material/thread/blue
	paint_color = "#46698c"
/obj/item/stack/material/thread/beige
	paint_color = "#ceb689"
/obj/item/stack/material/thread/lime
	paint_color = "#62e36c"
/obj/item/stack/material/thread/red
	paint_color = "#9d2300"
