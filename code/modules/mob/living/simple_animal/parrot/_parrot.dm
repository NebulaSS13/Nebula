/mob/living/simple_animal/parrot
	name = "parrot"
	desc = "A large, colourful tropical bird native to Earth, known for its strong beak and ability to mimic speech."
	icon = 'icons/mob/simple_animal/parrots/parrot.dmi'
	pass_flags = PASS_FLAG_TABLE
	mob_size = MOB_SIZE_SMALL

	speak =       list("Hi","Hello!","Cracker?")
	speak_emote = list("squawks","says","yells")
	emote_hear =  list("squawks","bawks")
	emote_see =   list("flutters its wings")

	natural_weapon = /obj/item/natural_weapon/beak
	speak_chance = 1//1% (1 in 100) chance every tick; So about once per 150 seconds, assuming an average tick is 1.5s
	turns_per_move = 5
	response_harm = "swats"
	stop_automated_movement = 1
	universal_speak = TRUE
	ai = /datum/ai/parrot

	meat_type = /obj/item/chems/food/meat/chicken/game
	meat_amount = 3
	skin_material = /decl/material/solid/skin/feathers

	/// Headset for Poly to yell at engineers :)
	var/obj/item/radio/headset/ears = null
	/// Maximuim w_class of a held item.
	var/max_held_item_size = ITEM_SIZE_SMALL
	/// Reference to our current perch.
	var/obj/perched_on_atom

/mob/living/simple_animal/parrot/Initialize()
	// If ears is truthy, we want a headset. Either one has
	// been supplied, or we pick one from a random list below.
	if(ears)
		if(!ispath(ears, /obj/item/radio/headset))
			ears = pick(list(
				/obj/item/radio/headset/headset_sec,
				/obj/item/radio/headset/headset_eng,
				/obj/item/radio/headset/headset_med,
				/obj/item/radio/headset/headset_sci,
				/obj/item/radio/headset/headset_cargo
			))
		ears = new ears(src)
	. = ..()
	update_icon()

/mob/living/simple_animal/parrot/Destroy()
	QDEL_NULL(ears)
	perch_on(null)
	return ..()

/mob/living/simple_animal/parrot/death(gibbed, deathmessage, show_dead_message)
	perch_on(null)
	return ..(gibbed, deathmessage, show_dead_message)

/*
 * Perch handling.
 */
/mob/living/simple_animal/parrot/proc/check_perch_state()
	if(QDELETED(perched_on_atom) || get_dist(perched_on_atom, src) > world.view)
		perch_on(null)
		return
	// If it's moving and we're perched on it, stay perched if we can.
	if(perched_on_atom && perched_on_atom.loc != get_turf(src) && Adjacent(perched_on_atom))
		animate_movement = perched_on_atom.animate_movement
		glide_size = perched_on_atom.glide_size
		forceMove(get_turf(perched_on_atom))
	if(istype(ai, /datum/ai/parrot))
		var/datum/ai/parrot/parrot_ai = ai
		if(parrot_ai.check_perch_state())
			update_icon()

// Parrots look very silly crawling around on the ground.
/mob/living/simple_animal/parrot/DoMove(var/direction, var/mob/mover, var/is_external)
	. = ..()
	if(. && !is_external && resting && !incapacitated() && (!perched_on_atom || loc != get_turf(perched_on_atom)))
		resting = FALSE
		update_icon()

/mob/living/simple_animal/parrot/proc/atom_is_perchable(var/obj/target)
	. = !perched_on_atom && istype(target) && (target.obj_flags & OBJ_FLAG_PARROT_PERCHABLE)
	if(.)
		for(var/mob/living/M in get_turf(target))
			if(M != src)
				return FALSE

/mob/living/simple_animal/parrot/proc/perch_on(var/atom/movable/target)

	if(perched_on_atom == target)
		return FALSE

	var/last_perched_on = perched_on_atom
	perched_on_atom = target
	if(last_perched_on)
		events_repository.unregister(/decl/observ/moved,     last_perched_on, src)
		events_repository.unregister(/decl/observ/destroyed, last_perched_on, src)
	if(perched_on_atom)
		events_repository.register(/decl/observ/moved,       perched_on_atom, src, .proc/check_perch_state)
		events_repository.register(/decl/observ/destroyed,   perched_on_atom, src, .proc/check_perch_state)
		dropInto(get_turf(perched_on_atom))
		resting = TRUE
	else
		resting = FALSE

	// Update our brain.
	if(istype(ai, /datum/ai/parrot))
		var/datum/ai/parrot/parrot_ai = ai
		parrot_ai.check_perch_state()

	update_icon()
	return TRUE

/*
 * Inventory handling.
 */
/mob/living/simple_animal/parrot/Stat()
	. = ..()
	stat("Ears",    istype(ears, /obj/item)      ? "\the [ears]"      : "nothing.")

/mob/living/simple_animal/parrot/DefaultTopicState()
	return global.physical_topic_state

/*
// This is pretty foul (fowl?). Leaving it alone pending a full rewrite of how stripping is handled (inventory slot PR)
/mob/living/simple_animal/parrot/show_inv(mob/user)
	if(user.incapacitated())
		return
	user.set_machine(src)
	var/dat = 	"<div align='center'><b>Inventory of [name]</b></div><p>"
	if(ears)
		dat +=	"<br><b>Headset:</b> [ears] (<a href='?src=\ref[src];remove_ears=1'>Remove</a>)"
	else
		dat +=	"<br><b>Headset:</b> <a href='?src=\ref[src];add_ears=1'>Nothing</a>"
	show_browser(user, dat, "window=mob[name];size=325x500")
	onclose(user, "mob[real_name]")
*/

/mob/living/simple_animal/parrot/OnTopic(mob/user, href_list)

	if(!ishuman(user))
		return TOPIC_NOACTION

	//Removing from inventory
	if(href_list["remove_ears"])
		if(!ears)
			to_chat(user, SPAN_WARNING("There is nothing to remove from \the [src]."))
		else
			say(":h BAWWWWWK LEAVE THE HEADSET BAWKKKKK!")
			try_unequip(ears, loc)
		return TOPIC_REFRESH

	// Adding a headset.
	if(href_list["add_ears"])
		var/obj/item/item_to_add = user.get_active_hand()
		if(!istype(item_to_add))
			to_chat(user, SPAN_WARNING("You have nothing in your hand to put on \the [src]."))
		else if(user.try_unequip(item_to_add, get_turf(src)) && equip_to_slot_if_possible(item_to_add, slot_l_ear_str))
			to_chat(user, SPAN_NOTICE("You fit \the [item_to_add] onto [src]."))
		return TOPIC_REFRESH

	return ..()

/mob/living/simple_animal/parrot/get_dexterity(silent)
	return DEXTERITY_HOLD_ITEM

/mob/living/simple_animal/parrot/canUnEquip(obj/item/I)
	return TRUE

/mob/living/simple_animal/parrot/put_in_hands(obj/item/W)
	return equip_to_slot_if_possible(W, BP_MOUTH) || ..()

/mob/living/simple_animal/parrot/get_equipped_item(slot)
	. = ..()
	if(!. && (slot == slot_l_ear_str || slot == slot_r_ear_str))
		return ears

/mob/living/simple_animal/parrot/get_equipped_items(include_carried)
	. = ..()
	if(ears)
		LAZYADD(., ears)

/mob/living/simple_animal/parrot/proc/can_pick_up_item(var/obj/item/thing)
	return istype(thing) && !thing.anchored && thing.simulated && thing.w_class <= max_held_item_size

/mob/living/simple_animal/parrot/equip_to_slot_if_possible(obj/item/W, slot, del_on_fail, disable_warning, redraw_mob, force)
	// We can't rely on mob_can_equip() as it checks ishuman().
	. = Adjacent(W) && can_pick_up_item(W) && slot && !get_equipped_item(slot)
	if(.)
		switch(slot)
			if(slot_l_ear_str, slot_r_ear_str)
				. = istype(W, /obj/item/radio/headset)
			if(BP_MOUTH)
				. = TRUE
			else
				. = FALSE
	if(.)
		equip_to_slot(W, slot, redraw_mob)
	else
		if(del_on_fail)
			qdel(W)
		else if(!disable_warning)
			to_chat(src, SPAN_WARNING("You are unable to equip that."))

/mob/living/simple_animal/parrot/equip_to_slot(obj/item/W, slot, redraw_mob = TRUE, delete_old_item = TRUE)
	if(..())
		if(slot != slot_l_ear_str && slot != slot_r_ear_str)
			return FALSE
		ears = W
		. =  TRUE
		var/datum/ai/parrot/parrot_ai = ai
		if(istype(parrot_ai))
			parrot_ai.inventory_changed()
		return TRUE
	return FALSE

/mob/living/simple_animal/parrot/unequip(obj/W)
	if(!..())
		if(W != ears)
			return FALSE
		ears = null
		var/datum/ai/parrot/parrot_ai = ai
		if(istype(parrot_ai))
			parrot_ai.inventory_changed()
		return TRUE
	return FALSE

/*
 * Interacting with other atoms.
 */
/mob/living/simple_animal/parrot/UnarmedAttack(atom/A)

	if(a_intent == I_HURT)
		return ..()

	// If we have a free held item slot...
	if(!held_item)

		// Grab items from the ground.
		if(istype(A, /obj/item) && can_pick_up_item(A))
			if(put_in_hands(A))
				visible_message("\The [src] swoops down and grabs \the [A]!")
			return TRUE

		// Steal from a target.
		if(ismob(A))
			var/mob/living/M = A
			var/obj/item/theft_target
			for(var/obj/item/thing in M.get_held_items())
				if(can_pick_up_item(thing))
					theft_target = thing
					break
			if(!theft_target)
				to_chat(src, SPAN_WARNING("\The [M] has nothing of interest to take."))
				if(!M.stat)
					to_chat(M, SPAN_WARNING("You see \the [src] eyeing you speculatively..."))
				return TRUE

			if(M.try_unequip(theft_target, get_turf(M)) && equip_to_slot_if_possible(theft_target, BP_MOUTH))
				visible_message(
					SPAN_DANGER("\The [src] grabs \the [theft_target] out of \the [M]'s hand!"),
					SPAN_NOTICE("You snag \the [theft_target] out of \the [M]'s hand!"),
					SPAN_NOTICE("You hear the sounds of wings flapping furiously.")
				)
			else
				visible_message(
					SPAN_WARNING("\The [src] makes a grab for \the [M]'s [theft_target.name], but fails!"),
					SPAN_WARNING("You fail to snag \the [theft_target] out of \the [M]'s hand!"),
					SPAN_NOTICE("You hear the sounds of wings flapping furiously.")
				)
			return TRUE

	// Perch on suitable atoms.
	if(isobj(A) && atom_is_perchable(A))
		perch_on(A)
		visible_message("\The [src] perches on \the [A]!")
		return TRUE

	return ..()

/*
 * Being attacked or otherwise interacted with.
 */
/mob/living/simple_animal/parrot/default_hurt_interaction(mob/user)
	. = ..()
	if(. && !stat && istype(ai, /datum/ai/parrot))
		var/datum/ai/parrot/parrot_ai = ai
		parrot_ai.attacked_by(user)

/mob/living/simple_animal/parrot/attackby(var/obj/item/O, var/mob/user)
	. = ..() // Return value is inconsistent/useless.
	if(!stat && !istype(O, /obj/item/stack/medical) && O.force && istype(ai, /datum/ai/parrot))
		var/datum/ai/parrot/parrot_ai = ai
		parrot_ai.attacked_by(user)

/mob/living/simple_animal/parrot/bullet_act(var/obj/item/projectile/Proj)
	. = ..() // Return value is inconsistent/useless.
	if(!stat && Proj && !Proj.nodamage && istype(ai, /datum/ai/parrot))
		var/datum/ai/parrot/parrot_ai = ai
		parrot_ai.attacked_by(Proj.firer)

/*
 * Mimicry and language handling.
 */
/mob/living/simple_animal/parrot/apply_speech_modifiers(var/message)
	if(!client && ears && istype(ai, /datum/ai/parrot))
		var/datum/ai/parrot/parrot_ai = ai
		return parrot_ai.add_radio_code(message)
	return ..()

/mob/living/simple_animal/parrot/hear_say(var/message, var/verb = "says", var/decl/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null)
	parrot_hear(message)
	return ..()

/mob/living/simple_animal/parrot/hear_radio(var/message, var/verb="says", var/decl/language/language=null, var/part_a, var/part_b, var/part_c, var/mob/speaker = null, var/hard_to_hear = 0)
	parrot_hear(message)
	return ..()

/mob/living/simple_animal/parrot/proc/parrot_hear(var/message, var/learn_chance = 50)
	if(message && !incapacitated() && prob(learn_chance) && istype(ai, /datum/ai/parrot))
		var/datum/ai/parrot/parrot_ai = ai
		LAZYDISTINCTADD(parrot_ai.speech_buffer, message)

/*
 * Sub-types
 */
/mob/living/simple_animal/parrot/Poly
	name = "Poly"
	desc = "Poly the Parrot. An expert on quantum cracker theory."
	speak = list(
		"Poly wanna cracker!",
		"Check the singlo, you chucklefucks!",
		"Wire the solars, you lazy bums!",
		"WHO TOOK THE DAMN HARDSUITS?",
		"OH GOD ITS FREE CALL THE SHUTTLE!"
	)
	ears = /obj/item/radio/headset/headset_eng
