/obj/item/stock_parts/item_holder/cupholder
	name       = "cupholder"
	desc       = "A holder for cups."
	icon       = 'icons/obj/items/stock_parts/modular_components.dmi'
	icon_state = "cupholder"
	material   = /decl/material/solid/organic/plastic
	part_flags = PART_FLAG_HAND_REMOVE
	place_verb = "place"
	eject_handler = /decl/interaction_handler/remove_held_item/cup
	var/obj/item/cup

/obj/item/stock_parts/item_holder/cupholder/Destroy()
	QDEL_NULL(cup)
	. = ..()

/obj/item/stock_parts/item_holder/cupholder/is_item_inserted()
	return !isnull(cup)

/obj/item/stock_parts/item_holder/cupholder/is_accepted_type(obj/O)
	var/static/allowed_cup_types
	if(!allowed_cup_types)
		allowed_cup_types = typecacheof(list(
			/obj/item/chems/drinks/cans,
			/obj/item/chems/drinks/bottle,
			/obj/item/chems/glass/bottle,
			/obj/item/chems/drinks/juicebox,
			/obj/item/chems/drinks/glass2,
			/obj/item/chems/drinks/h_chocolate,
			/obj/item/chems/drinks/dry_ramen,
			/obj/item/chems/drinks/tea,
			/obj/item/chems/glass/handmade/cup,
			/obj/item/chems/glass/handmade/mug,
			/obj/item/chems/drinks/shaker,
			/obj/item/chems/drinks/flask
		))
	return is_type_in_typecache(O, allowed_cup_types)

/obj/item/stock_parts/item_holder/cupholder/get_inserted()
	return cup

/obj/item/stock_parts/item_holder/cupholder/set_inserted(obj/O)
	cup = O

/obj/item/stock_parts/item_holder/cupholder/get_description_insertable()
	return "cup"

/decl/interaction_handler/remove_held_item/cup
	name = "Remove Cup"
	expected_component_type = /obj/item/stock_parts/item_holder/cupholder
	examine_desc = "remove a cup"
