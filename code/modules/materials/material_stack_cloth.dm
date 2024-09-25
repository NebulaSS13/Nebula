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
#define SET_COLOR(COLOR) paint_color = COLOR; color = COLOR
/obj/item/stack/material/bolt/yellow
	SET_COLOR("#ffbf00")
/obj/item/stack/material/bolt/teal
	SET_COLOR("#00e1ff")
/obj/item/stack/material/bolt/black
	SET_COLOR("#505050")
/obj/item/stack/material/bolt/green
	SET_COLOR("#b7f27d")
/obj/item/stack/material/bolt/purple
	SET_COLOR("#9933ff")
/obj/item/stack/material/bolt/blue
	SET_COLOR("#46698c")
/obj/item/stack/material/bolt/beige
	SET_COLOR("#ceb689")
/obj/item/stack/material/bolt/lime
	SET_COLOR("#62e36c")
/obj/item/stack/material/bolt/red
	SET_COLOR("#9d2300")

/obj/item/stack/material/thread
	name = "thread spools"
	singular_name = "thread spool"
	plural_name = "thread spools"
	stack_merge_type = /obj/item/stack/material/thread
	crafting_stack_type = /obj/item/stack/material/thread
	craft_verb = "weave"
	craft_verbing = "weaving"
	w_class = ITEM_SIZE_TINY
	matter_multiplier = 0.125 // 250 matter units = 1 thread, each small offal is 4 thread, so a large offal is 16 thread.
	icon_state = "thread"
	plural_icon_state = "thread-mult"
	max_icon_state = "thread-max"

/obj/item/stack/material/thread/yellow
	SET_COLOR("#ffbf00")
/obj/item/stack/material/thread/teal
	SET_COLOR("#00e1ff")
/obj/item/stack/material/thread/black
	SET_COLOR("#505050")
/obj/item/stack/material/thread/green
	SET_COLOR("#b7f27d")
/obj/item/stack/material/thread/purple
	SET_COLOR("#9933ff")
/obj/item/stack/material/thread/blue
	SET_COLOR("#46698c")
/obj/item/stack/material/thread/beige
	SET_COLOR("#ceb689")
/obj/item/stack/material/thread/lime
	SET_COLOR("#62e36c")
/obj/item/stack/material/thread/red
	SET_COLOR("#9d2300")
#undef SET_COLOR