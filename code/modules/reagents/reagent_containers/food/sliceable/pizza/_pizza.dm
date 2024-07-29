/obj/item/food/sliceable/pizza
	icon_state = ICON_STATE_WORLD
	slice_num = 6
	nutriment_amt = 25
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread
	center_of_mass = @'{"x":16,"y":11}'
	filling_color = "#baa14c"
	abstract_type = /obj/item/food/sliceable/pizza
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "cheese" = 15)
	var/ruined = FALSE // Visual only, doesn't actually impact the edibility or sliceability of the pizza.

/obj/item/food/sliceable/pizza/proc/ruin()
	if(!ruined)
		ruined = TRUE
		name = "ruined [name]"
		update_icon()

/obj/item/food/sliceable/pizza/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(ruined)
		var/ruined_state = "[icon_state]_ruined"
		if(check_state_in_icon(ruined_state, icon))
			icon_state = ruined_state

/obj/item/food/slice/pizza
	icon = 'icons/obj/food/pizzas/pizza_slices.dmi'
	filling_color = "#baa14c"
	bitesize = 2
	center_of_mass = @'{"x":18,"y":13}'
	abstract_type = /obj/item/food/slice/pizza
