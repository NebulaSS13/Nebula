/mob/living/carbon/human/proc/detach_limb()
	set category = "IC"
	set name = "Detach Limb"
	set desc = "Detach one of your robotic appendages."

	if(last_special > world.time)
		return

	if(incapacitated() || restrained())
		to_chat(src, SPAN_WARNING("You can't do that in your current state!"))
		return

	var/obj/item/organ/external/E = get_organ(zone_sel.selecting)

	if(!E)
		to_chat(src, SPAN_WARNING("You are missing that limb."))
		return

	if(!BP_IS_PROSTHETIC(E))
		to_chat(src, SPAN_WARNING("You can only detach robotic limbs."))
		return

	if(E.is_stump() || E.is_broken())
		to_chat(src, SPAN_WARNING("The limb is too damaged to be removed manually!"))
		return

	if(E.vital)
		to_chat(src, SPAN_WARNING("Your safety system stops you from removing \the [E]."))
		return

	if(!do_after(src, 2 SECONDS, src))
		return

	if(QDELETED(E) || E.owner != src)
		return

	last_special = world.time + 20

	E.removed(src)
	E.forceMove(get_turf(src))

	update_body()
	updatehealth()
	UpdateDamageIcon()

	visible_message(
		SPAN_NOTICE("\The [src] detaches \his [E]!"),
		SPAN_NOTICE("You detach your [E]!"))

/mob/living/carbon/human/proc/attach_limb()
	set category = "IC"
	set name = "Attach Limb"
	set desc = "Attach a robotic limb to your body."

	if(last_special > world.time)
		return

	if(incapacitated() || restrained())
		to_chat(src, SPAN_WARNING("You can not do that in your current state!"))
		return

	var/obj/item/organ/external/O = src.get_active_hand()

	if(!istype(O))
		return

	if(!BP_IS_PROSTHETIC(O))
		to_chat(src, SPAN_WARNING("You are unable to interface with organic matter."))
		return

	if(get_organ(zone_sel.selecting))
		to_chat(src, SPAN_WARNING("You are not missing that limb."))
		return

	if(!do_after(src, 2 SECONDS, src))
		return

	if(QDELETED(O))
		return

	last_special = world.time + 20

	drop_from_inventory(O)
	O.replaced(src)

	update_body()
	updatehealth()
	UpdateDamageIcon()

	visible_message(
		SPAN_NOTICE("\The [src] attaches \the [O] to \his body!"),
		SPAN_NOTICE("You attach \the [O] to your body!"))

/mob/living/carbon/human/proc/eyeglow()
	set category = "IC"
	set name = "Toggle Eye Glow"
	set desc = "Toggles glowing for eyes."

	var/obj/item/organ/external/head/head = organs_by_name[BP_HEAD]
	if(istype(head) && !stat)
		head.glowing_eyes = !head.glowing_eyes
		regenerate_icons()
