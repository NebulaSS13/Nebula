/obj/item/chems/condiment
	name = "condiment container"
	desc = "Just your average condiment container."
	icon = 'icons/obj/food/condiments/empty.dmi'
	icon_state = ICON_STATE_WORLD
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	possible_transfer_amounts = @"[1,5,10]"
	center_of_mass = @'{"x":16,"y":6}'
	randpixel = 6
	volume = 50
	var/condiment_key
	var/morphic_container = TRUE
	var/use_condiment_name = TRUE
	var/initial_condiment_type

/obj/item/chems/condiment/populate_reagents()
	. = ..()
	var/decl/condiment_appearance/condiment = GET_DECL(initial_condiment_type)
	if(condiment?.condiment_type)
		add_to_reagents(condiment.condiment_type, reagents.maximum_volume)

/obj/item/chems/condiment/attackby(var/obj/item/W, var/mob/user)
	if(IS_PEN(W))
		var/tmp_label = sanitize_safe(input(user, "Enter a label for [name]", "Label", label_text), MAX_NAME_LEN)
		if(tmp_label == label_text)
			return
		if(length(tmp_label) > 10)
			to_chat(user, SPAN_NOTICE("The label can be at most 10 characters long."))
		else
			if(length(tmp_label))
				to_chat(user, SPAN_NOTICE("You set the label to \"[tmp_label]\"."))
				label_text = tmp_label
			else
				to_chat(user, SPAN_NOTICE("You remove the label."))
				label_text = null
			update_name()
			update_container_desc()
			update_icon()
		return

/obj/item/chems/condiment/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!proximity)
		return ..()
	if(standard_dispenser_refill(user, target))
		return TRUE
	if(standard_pour_into(user, target))
		return TRUE
	return ..()

/obj/item/chems/condiment/proc/get_current_condiment_appearance()
	if(!morphic_container)
		return GET_DECL(initial_condiment_type)
	switch(LAZYLEN(reagents?.reagent_volumes))
		if(0)
			return GET_DECL(/decl/condiment_appearance/empty)
		if(1)
			return get_condiment_appearance(reagents?.get_primary_reagent_type(), condiment_key)
		else
			return GET_DECL(/decl/condiment_appearance/mixed)

/obj/item/chems/condiment/on_reagent_change()
	if((. = ..()))
		update_center_of_mass()

/obj/item/chems/condiment/proc/update_center_of_mass()
	var/decl/condiment_appearance/condiment = get_current_condiment_appearance()
	center_of_mass = condiment?.condiment_center_of_mass || initial(center_of_mass)

/obj/item/chems/condiment/update_name()
	var/decl/condiment_appearance/condiment = get_current_condiment_appearance()
	if(use_condiment_name && condiment?.condiment_name)
		SetName(condiment.condiment_name)
	else
		..()
	if(label_text)
		SetName(addtext(name," ([label_text])"))

/obj/item/chems/condiment/update_container_desc()
	var/decl/condiment_appearance/condiment = get_current_condiment_appearance()
	desc = condiment?.condiment_desc || get_base_desc()

/obj/item/chems/condiment/on_update_icon()
	. = ..()
	var/new_icon
	var/decl/condiment_appearance/condiment = get_current_condiment_appearance()
	if(condiment?.condiment_icon)
		new_icon = condiment.condiment_icon
	else
		new_icon = initial(icon)
	if(new_icon)
		set_icon(new_icon)
