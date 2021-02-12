/obj/item/brain_interface/organic
	name = "man-machine interface"
	origin_tech = "{'biotech':3}"
	icon = 'icons/obj/items/brain_interface_organic.dmi'
	req_access = list(access_robotics)
	var/locked = FALSE

/obj/item/brain_interface/organic/attack_self(mob/user)

	if(locked)
		to_chat(user, SPAN_WARNING("You upend \the [src], but the case is locked shut."))
		return TRUE

	if(!holding_brain)
		to_chat(user, SPAN_WARNING("You upend \the [src], but there's nothing in it."))
		return TRUE

	to_chat(user, SPAN_NOTICE("You upend \the [src], spilling \the [holding_brain] onto \the [get_turf(src)]."))

	holding_brain.dropInto(user.loc)
	holding_brain = null
	update_icon()
	SetName(initial(name))

/obj/item/brain_interface/organic/transfer_player(var/mob/living/carbon/human/H)
	locked = TRUE
	. = ..()

/obj/item/brain_interface/organic/empty
	holding_brain = null

/obj/item/brain_interface/organic/attackby(var/obj/item/O, var/mob/user)

	if(istype(O,/obj/item/organ/internal/brain))

		if(holding_brain)
			to_chat(user, SPAN_WARNING("\The [src] already has a brain in it."))
			return TRUE

		var/obj/item/organ/internal/brain/inserting_brain = O
		if(inserting_brain.damage >= inserting_brain.max_damage)
			to_chat(user, SPAN_WARNING("That brain is well and truly dead."))
			return TRUE
	
		if(!inserting_brain.brainmob || !inserting_brain.can_use_brain_interface)
			to_chat(user, SPAN_WARNING("\The [inserting_brain] is completely useless."))
			return TRUE

		if(user.unEquip(O, src))
			user.visible_message(SPAN_NOTICE("\The [user] sticks \the [inserting_brain] into \the [src]."))
			SetName("[initial(name)] (\the [inserting_brain])")
			holding_brain = inserting_brain
			update_icon()
			locked = TRUE
			SSstatistics.add_field("cyborg_mmis_filled",1)
		return TRUE

	if(istype(O,/obj/item/card/id) || istype(O,/obj/item/modular_computer))
		if(allowed(user))
			locked = !locked
			to_chat(user, SPAN_NOTICE("You [locked ? "lock" : "unlock"] \the [src]."))
		else
			to_chat(user, SPAN_WARNING("Access denied."))
		return TRUE
