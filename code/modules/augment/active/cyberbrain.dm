/obj/item/organ/internal/augment/active/cyberbrain
	name = "cyberbrain module"
	action_button_name = "Access cyberbrain"
	icon_state = "cyberbrain"
	allowed_organs = list(BP_AUGMENT_HEAD)
	augment_flags = AUGMENTATION_MECHANIC
	var/list/stock_parts = list()
	var/list/starting_stock_parts = list(
		/obj/item/stock_parts/computer/processor_unit/small,
		/obj/item/stock_parts/computer/hard_drive/small,
		/obj/item/stock_parts/computer/network_card
	)
	var/max_hardware_size = 1

/*
 *
 * Section for actual mechanics of cyberbrain.
 *
 */
/obj/item/organ/internal/augment/active/cyberbrain/Initialize()
	. = ..()
	set_extension(src, /datum/extension/interactive/ntos/implant)
	for(var/T in starting_stock_parts)
		stock_parts += new T(src)

/obj/item/organ/internal/augment/active/cyberbrain/Destroy()
	. = ..()
	QDEL_NULL_LIST(stock_parts)

/obj/item/organ/internal/augment/active/cyberbrain/activate()
	if(!can_activate())
		return

	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	if(!istype(os))
		to_chat(owner, SPAN_WARNING("You seem to be lacking an NTOS capable device!"))
		return

	if(!os.on)
		os.system_boot()
	if(!os.on)
		to_chat(owner, SPAN_WARNING("ERROR: NTOS failed to boot."))
		return

	os.ui_interact(owner)

/obj/item/organ/internal/augment/active/cyberbrain/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/stock_parts/computer))
		var/obj/item/stock_parts/computer/C = W
		if(C.hardware_size <= max_hardware_size)
			try_install_component(user, C)
		else
			to_chat(user, "This component is too large for \the [src].")
	if(isScrewdriver(W))
		if(!stock_parts.len)
			to_chat(user, "\the [src] doesn't have any components installed.")
			return
		var/list/component_names = list()
		for(var/obj/item/stock_parts/computer/H in stock_parts)
			component_names.Add(H.name)
		var/choice = input(usr, "Which component do you want to uninstall?", "[src] maintenance", null) as null|anything in component_names

		if(!choice)
			return

		if(!Adjacent(usr))
			return

		var/obj/item/stock_parts/computer/H = find_hardware_by_name(choice)
		if(!H)
			return

		stock_parts -= H
		to_chat(user, "You uninstall \the [H] from \the [src].")
		user.put_in_hands(H)
		return
	. = ..()

/obj/item/organ/internal/augment/active/cyberbrain/proc/try_install_component(var/user, var/obj/item/stock_parts/computer/C)
	var/can_install = FALSE
	if(istype(C, /obj/item/stock_parts/computer/hard_drive))
		if(has_component_type(/obj/item/stock_parts/computer/hard_drive))
			to_chat(user, SPAN_WARNING("\the [src] already has a hard drive."))
			return
		can_install = TRUE
	if(istype(C, /obj/item/stock_parts/computer/processor_unit))
		if(has_component_type(/obj/item/stock_parts/computer/processor_unit))
			to_chat(user, SPAN_WARNING("\the [src] already has a processor."))
			return
		can_install = TRUE
	if(istype(C, /obj/item/stock_parts/computer/network_card))
		if(has_component_type(/obj/item/stock_parts/computer/network_card))
			to_chat(user, SPAN_WARNING("\the [src] already has a network card."))
			return
		can_install = TRUE
	if(istype(C, /obj/item/stock_parts/computer/ai_slot))
		if(has_component_type(/obj/item/stock_parts/computer/ai_slot))
			to_chat(user, SPAN_WARNING("\the [src] already has an ai slot."))
			return
		can_install = TRUE

	if(can_install)
		to_chat(user, "You install \the [C] into \the [src].")
		stock_parts |= C
		C.dropInto(src)
	else
		to_chat(user, SPAN_WARNING("\the [C] is not installable in \the [src]."))

/obj/item/organ/internal/augment/active/cyberbrain/proc/has_component_type(var/path)
	for(var/C in stock_parts)
		if(istype(C, path))
			return TRUE

/obj/item/organ/internal/augment/active/cyberbrain/proc/find_hardware_by_name(var/name)
	for(var/obj/item/stock_parts/computer/H in stock_parts)
		if(H.name == name)
			return H