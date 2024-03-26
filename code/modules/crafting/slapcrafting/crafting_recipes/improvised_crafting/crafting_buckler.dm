/decl/crafting_stage/buckler_frame
	descriptor = "improvised buckler"
	begins_with_object_type = /obj/item/stool
	completion_trigger_type = /obj/item/circular_saw
	item_desc = "It's the seat of a stool with the legs cut off."
	item_icon_state = "buckler1"
	progress_message = "You crudely sever the legs off the stool and remove the seat."
	consume_completion_trigger = FALSE
	next_stages = list(/decl/crafting_stage/buckler_panels)

/decl/crafting_stage/buckler_panels
	item_desc = "It's the seat of a stool with the legs sawn off and wooden planks layered over the top, ready to secure in place."
	completion_trigger_type = /obj/item/stack/material/plank
	consume_completion_trigger = FALSE
	stack_consume_amount = 3
	item_icon_state = "buckler2"
	progress_message = "You layer planks over the frame to serve as armour panels."
	next_stages = list(/decl/crafting_stage/screwdriver/buckler_finish)

/decl/crafting_stage/screwdriver/buckler_finish
	progress_message = "You secure the buckler's panels in place and finish it off."
	product = /obj/item/shield/buckler
