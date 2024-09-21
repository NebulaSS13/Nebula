#define CARCASS_EMPTY    "empty"
#define CARCASS_FRESH    "fresh"
#define CARCASS_SKINNED  "skinned"
#define CARCASS_GUTTED   "gutted"
#define CARCASS_JOINTED  "jointed"

// Structure for conducting butchery on.
/obj/structure/meat_hook
	name = "meat hook"
	desc = "It looks pretty sharp."
	anchored = TRUE
	density =  TRUE
	icon = 'icons/obj/structures/butchery.dmi'
	icon_state = "spike"
	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	matter = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY
	)
	tool_interaction_flags = (TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT)
	parts_amount = 2
	parts_type = /obj/item/stack/material/strut

	var/mob/living/occupant
	var/occupant_state =   CARCASS_EMPTY
	var/secures_occupant = TRUE
	var/busy =             FALSE

/obj/structure/meat_hook/return_air()
	var/turf/T = get_turf(src)
	if(istype(T))
		return T.return_air()

/obj/structure/meat_hook/improvised
	name = "truss"
	icon_state = "improvised"
	secures_occupant = FALSE
	material = /decl/material/solid/organic/wood
	parts_type = /obj/item/stack/material/plank

/obj/structure/meat_hook/attack_hand(var/mob/user)

	if(!occupant || !user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()

	if(occupant_state == CARCASS_FRESH)
		visible_message(SPAN_NOTICE("\The [user] removes \the [occupant] from \the [initial(name)]."))
		occupant.forceMove(get_turf(src))
		clear_occupant()
		busy = FALSE
		update_icon()
	else
		to_chat(user, SPAN_WARNING("\The [occupant] is so badly mangled that removing them from \the [initial(name)] would be pointless."))
	return TRUE

/obj/structure/meat_hook/grab_attack(obj/item/grab/grab, mob/user)
	var/mob/victim = grab.get_affecting_mob()
	if(istype(victim) && isturf(victim.loc))
		try_spike(victim, user)
		return TRUE
	return ..()

/obj/structure/meat_hook/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/holder))
		var/mob/victim = (locate() in W)
		if(istype(victim) && user.try_unequip(W))
			try_spike(victim, user, 1) // Delay to allow the holder to despawn and drop the mob in the loc.
			return TRUE
	return ..()

/obj/structure/meat_hook/receive_mouse_drop(atom/dropping, mob/user, params)
	. = ..()
	if(!. && ismob(dropping))
		try_spike(dropping, user)
		return TRUE

/obj/structure/meat_hook/proc/try_spike(mob/living/target, mob/living/user, delay)

	set waitfor = FALSE
	if(delay)
		sleep(delay)

	if(!istype(target) || QDELETED(target) || !istype(user) || QDELETED(user) || user.incapacitated() || target.anchored)
		return

	if(!Adjacent(user) || !target.Adjacent(user))
		return

	if(!anchored)
		to_chat(user, SPAN_WARNING("Anchor \the [src] in place first!"))
		return

	if(!target.stat)
		to_chat(user, SPAN_WARNING("\The [target] won't stop moving around!"))
		return

	if(occupant)
		to_chat(user, SPAN_WARNING("\The [initial(name)] already has a carcass on it."))
		return

	if(suitable_for_butchery(target))

		user.visible_message(SPAN_WARNING("\The [user] begins wrestling \the [target] onto \the [src]."))
		if(!do_after(user, 3 SECONDS, target) || occupant || !target || QDELETED(target) || target.stat == CONSCIOUS || !target.Adjacent(user))
			return

		if(secures_occupant)
			user.visible_message(SPAN_DANGER("\The [user] impales \the [target] on \the [src]!"))
			target.take_damage(rand(30, 45))
		else
			user.visible_message(SPAN_DANGER("\The [user] hangs \the [target] from \the [src]!"))

		target.forceMove(src)
		occupant = target
		occupant_state = CARCASS_FRESH
		SetName("[target.name]'s carcass")
		update_icon()
	else
		to_chat(user, SPAN_WARNING("You cannot butcher \the [target]."))

/obj/structure/meat_hook/proc/suitable_for_butchery(var/mob/living/victim)
	return istype(victim) && victim.butchery_data && (victim.currently_has_skin() || victim.currently_has_innards() || victim.currently_has_bones() || victim.currently_has_meat())

/obj/structure/meat_hook/on_update_icon()
	..()
	if(!occupant)
		return

	occupant.set_dir(SOUTH)

	var/image/I = image(null)
	I.appearance = occupant
	I.appearance_flags |= RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	I.pixel_x = null
	I.pixel_y = null
	I.pixel_z = null
	I.pixel_w = null
	I.layer   = FLOAT_LAYER
	I.plane   = FLOAT_PLANE

	var/matrix/M = matrix()
	var/decl/butchery_data/butchery_data = GET_DECL(occupant.butchery_data)
	if(butchery_data)
		M.Turn(butchery_data.butchery_rotation)
		M.Translate(arglist(butchery_data.butchery_offset))
	I.transform = M

	add_overlay(I)

/obj/structure/meat_hook/mob_breakout(mob/living/escapee)
	. = ..()
	if(secures_occupant)
		escapee.visible_message(SPAN_WARNING("\The [escapee] begins writhing free of \the [initial(name)]!"))
		if(!do_after(escapee, 5 SECONDS, src))
			return FALSE
	escapee.visible_message(SPAN_DANGER("\The [escapee] escapes from \the [initial(name)]!"))
	escapee.dropInto(loc)
	if(escapee == occupant)
		clear_occupant()
		update_icon()
	return TRUE

/obj/structure/meat_hook/proc/clear_occupant()
	occupant = null
	occupant_state = CARCASS_EMPTY
	SetName(initial(name))
	update_materials(TRUE) // reset name

/obj/structure/meat_hook/proc/set_carcass_state(var/_state, var/apply_damage = TRUE)
	occupant_state = _state
	if(occupant && apply_damage)
		occupant.take_damage(rand(50, 60))
		if(occupant.stat != DEAD)
			occupant.death()
	if(QDELETED(occupant))
		clear_occupant()
	else if(occupant_state == CARCASS_EMPTY)
		for(var/obj/item/embedded in occupant.embedded)
			occupant.remove_implant(occupant.embedded, TRUE) // surgical removal to prevent pointless damage pre-deletion
		for(var/obj/item/W in occupant)
			occupant.drop_from_inventory(W)
		qdel(occupant)
		clear_occupant()
	update_icon()

/obj/structure/meat_hook/proc/do_butchery_step(var/mob/user, obj/item/tool, var/next_state, var/butchery_string)

	if(QDELETED(occupant))
		return FALSE

	var/last_state = occupant_state
	var/mob/living/last_occupant = occupant

	occupant.take_damage(rand(50, 60))
	update_icon()
	if(!tool?.do_tool_interaction(TOOL_KNIFE, user, src, 3 SECONDS, start_message = butchery_string, success_message = butchery_string, check_skill = SKILL_COOKING))
		return FALSE
	if(!QDELETED(user) && !QDELETED(last_occupant) && occupant == last_occupant && occupant_state == last_state)

		var/decl/butchery_data/butchery_data = GET_DECL(occupant.butchery_data)
		if(!butchery_data)
			return FALSE

		switch(next_state)
			if(CARCASS_SKINNED)
				if(occupant.currently_has_skin())
					butchery_data.harvest_skin(occupant)
			if(CARCASS_GUTTED)
				if(occupant.currently_has_innards())
					butchery_data.harvest_innards(occupant)
			if(CARCASS_JOINTED)
				if(occupant.currently_has_bones())
					butchery_data.harvest_bones(occupant)
			if(CARCASS_EMPTY)
				if(occupant.currently_has_meat())
					butchery_data.harvest_meat(occupant)
		set_carcass_state(next_state)
		return TRUE

	return FALSE

/obj/structure/meat_hook/attackby(var/obj/item/thing, var/mob/user)

	if(!IS_KNIFE(thing))
		return ..()

	if(!occupant)
		to_chat(user, SPAN_WARNING("There is nothing on \the [src] to butcher."))
		return TRUE

	if(busy)
		to_chat(user, SPAN_WARNING("\The [src] is already in use!"))
		return TRUE

	busy = TRUE
	if(occupant_state == CARCASS_FRESH)
		if(occupant.currently_has_skin())
			do_butchery_step(user, thing, CARCASS_SKINNED, "skinning")
		else
			set_carcass_state(CARCASS_SKINNED, apply_damage = FALSE)
	if(occupant_state == CARCASS_SKINNED)
		if(occupant.currently_has_innards())
			do_butchery_step(user, thing, CARCASS_GUTTED,  "gutting")
		else
			set_carcass_state(CARCASS_GUTTED, apply_damage = FALSE)
	if(occupant_state == CARCASS_GUTTED)
		if(occupant.currently_has_bones())
			do_butchery_step(user, thing, CARCASS_JOINTED, "deboning")
		else
			set_carcass_state(CARCASS_JOINTED, apply_damage = FALSE)
	if(occupant_state == CARCASS_JOINTED)
		if(occupant.currently_has_meat())
			do_butchery_step(user, thing, CARCASS_EMPTY,   "butchering")
		else
			set_carcass_state(CARCASS_EMPTY, apply_damage = FALSE)
	busy = FALSE
	return TRUE

#undef CARCASS_EMPTY
#undef CARCASS_FRESH
#undef CARCASS_SKINNED
#undef CARCASS_GUTTED
#undef CARCASS_JOINTED
