// Many values copied from brains. Not inheriting to avoid redundant brainmob creation.
/obj/item/organ/internal/brain_interface
	name = "neural interface"
	desc = "A complex life support shell that interfaces between a brain and an electronic device."
	organ_tag = BP_BRAIN
	parent_organ = BP_HEAD
	origin_tech = @'{"biotech":3}'
	icon = 'icons/obj/items/brain_interface_organic.dmi'
	icon_state = ICON_STATE_WORLD
	req_access = list(access_robotics)
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	w_class = ITEM_SIZE_SMALL
	throw_speed = 3
	throw_range = 5
	attack_verb = list("attacked", "slapped", "whacked")
	relative_size = 85
	damage_reduction = 0
	scale_max_damage_to_species_health = FALSE
	transfer_brainmob_with_organ = TRUE
	var/locked = FALSE
	var/obj/item/organ/internal/brain/holding_brain = /obj/item/organ/internal/brain

/obj/item/organ/internal/brain_interface/is_preserved()
	return TRUE

/obj/item/organ/internal/brain_interface/empty
	holding_brain = null

/obj/item/organ/internal/brain_interface/Initialize()
	set_bodytype(/decl/bodytype/prosthetic/basic_human)
	if(ispath(holding_brain))
		holding_brain = new holding_brain(src)
	if(get_radio())
		verbs |= /obj/item/organ/internal/brain_interface/proc/toggle_radio_listening
		verbs |= /obj/item/organ/internal/brain_interface/proc/toggle_radio_broadcasting
	. = ..()
	update_icon()

/obj/item/organ/internal/brain_interface/get_brainmob(var/create_if_missing = FALSE)
	return holding_brain?.get_brainmob(create_if_missing)

/obj/item/organ/internal/brain_interface/on_update_icon()
	icon_state = get_world_inventory_state()
	if(holding_brain)
		var/mob/living/brainmob = get_brainmob()
		if(!brainmob || brainmob.stat == DEAD)
			icon_state = "[icon_state]-dead"
		else
			icon_state = "[icon_state]-full"

/obj/item/organ/internal/brain_interface/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		var/mob/living/brain/brainmob = get_brainmob()
		if(istype(brainmob))
			if(brainmob.emp_damage)
				to_chat(user, SPAN_WARNING("The neural interface socket is damaged."))
			else
				to_chat(user, SPAN_NOTICE("It is undamaged."))

/obj/item/organ/internal/brain_interface/attackby(var/obj/item/O, var/mob/user)

	if(istype(O, /obj/item/stack/nanopaste))
		var/mob/living/brain/brainmob = get_brainmob()
		if(!istype(brainmob) || !brainmob.emp_damage)
			to_chat(user, SPAN_WARNING("\The [src] has no damage to repair."))
			return TRUE
		var/obj/item/stack/nanopaste/pasta = O
		pasta.use(1)
		to_chat(user, SPAN_NOTICE("You repair some of the damage to \the [src]'s electronics with the nanopaste."))
		brainmob.emp_damage = max(brainmob.emp_damage - rand(5,10), 0)
		return TRUE

	if(istype(O, /obj/item/organ/internal/brain))

		if(holding_brain)
			to_chat(user, SPAN_WARNING("\The [src] already has a brain in it."))
			return TRUE

		var/obj/item/organ/internal/brain/inserting_brain = O
		if(BP_IS_PROSTHETIC(inserting_brain))
			to_chat(user, SPAN_WARNING("You don't need to put a robotic brain into an interface."))
			return TRUE

		if(inserting_brain.damage >= inserting_brain.max_damage)
			to_chat(user, SPAN_WARNING("That brain is well and truly dead."))
			return TRUE

		if(!inserting_brain.get_brainmob() || !inserting_brain.can_use_brain_interface)
			to_chat(user, SPAN_WARNING("\The [inserting_brain] is completely useless."))
			return TRUE

		if(user.try_unequip(O, src))
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

	if(holding_brain)
		return holding_brain.attackby(O, user)

	. = ..()

/obj/item/organ/internal/brain_interface/relaymove(var/mob/user, var/direction)
	if(user.incapacitated())
		return
	var/obj/item/rig/rig = src.get_rig()
	if(rig)
		rig.forced_move(direction, user)

/obj/item/organ/internal/brain_interface/Destroy()
	if(isrobot(loc))
		var/mob/living/silicon/robot/borg = loc
		if(borg.central_processor == src)
			borg.central_processor = null
	if(holding_brain)
		if(!QDELETED(holding_brain))
			qdel(holding_brain)
		holding_brain = null
	for(var/obj/item/thing in contents)
		qdel(thing)
	. = ..()

/obj/item/organ/internal/brain_interface/attack_self(mob/user)

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
