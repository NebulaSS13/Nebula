/obj/structure
	icon = 'icons/obj/structures.dmi'
	w_class = ITEM_SIZE_NO_CONTAINER
	layer = STRUCTURE_LAYER

	var/breakable
	var/parts_type
	var/footstep_type
	var/mob_offset

/obj/structure/Initialize(var/ml, var/_mat, var/_reinf_mat)
	if(ispath(_mat, /material))
		material = _mat
	if(ispath(material, /material))
		material = SSmaterials.get_material_datum(material)
	if(ispath(_reinf_mat, /material))
		reinf_material = _reinf_mat
	if(ispath(reinf_material, /material))
		reinf_material = SSmaterials.get_material_datum(reinf_material)
	. = ..()
	if(material || reinf_material)
		update_materials()
	if(!CanFluidPass())
		fluid_update()

/obj/structure/Destroy()
	reset_mobs_offset()
	var/turf/T = get_turf(src)
	. = ..()
	if(T)
		T.fluid_update()

/obj/structure/examine(mob/user, var/distance)
	. = ..()
	if(distance <= 3)

		if(tool_interaction_flags & TOOL_INTERACTION_ANCHOR)
			if(anchored)
				to_chat(user, SPAN_SUBTLE("Can be unanchored with a wrench, and moved around."))
			else
				to_chat(user, SPAN_SUBTLE("Can be anchored in place with a wrench."))

		if(tool_interaction_flags & TOOL_INTERACTION_DECONSTRUCT)
			var/removed_with = "a crowbar"
			if(material && material.removed_by_welder)
				removed_with = "a welding torch"
			if(tool_interaction_flags & TOOL_INTERACTION_ANCHOR)
				if(anchored)
					to_chat(user, SPAN_SUBTLE("Can be deconstructed with [removed_with]."))
				else
					to_chat(user, SPAN_SUBTLE("Can be deconstructed with [removed_with], if anchored down with a wrench first."))
			else
				to_chat(user, SPAN_SUBTLE("Can be deconstructed with [removed_with]."))

		if(tool_interaction_flags & TOOL_INTERACTION_WIRING)
			if(tool_interaction_flags & TOOL_INTERACTION_ANCHOR)
				if(wired)
					if(anchored)
						to_chat(user, SPAN_SUBTLE("Can have its wiring removed with wirecutters"))
					else
						to_chat(user, SPAN_SUBTLE("Can have its wiring removed with wirecutters, if anchored down with a wrench first."))
				else
					if(anchored)
						to_chat(user, SPAN_SUBTLE("Can have wiring installed with a cable coil."))
					else
						to_chat(user, SPAN_SUBTLE("Can have wiring installed with a cable coil, if anchored down with a wrench first."))
			else
				if(wired)
					to_chat(user, SPAN_SUBTLE("Can have its wiring removed with wirecutters"))
				else
					to_chat(user, SPAN_SUBTLE("Can have wiring installed with a cable coil."))

/obj/structure/attack_generic(var/mob/user, var/damage, var/attack_verb, var/wallbreaker)
	if(wallbreaker && damage && breakable)
		visible_message(SPAN_DANGER("\The [user] smashes \the [src] to pieces!"))
		attack_animation(user)
		qdel(src)
		return 1
	visible_message(SPAN_DANGER("\The [user] [attack_verb] \the [src]!"))
	attack_animation(user)
	take_damage(damage)
	return 1

/obj/structure/proc/mob_breakout(var/mob/living/escapee)
	set waitfor = FALSE
	return FALSE

/obj/structure/proc/take_damage(var/damage)
	return

/obj/structure/Destroy()
	reset_mobs_offset()
	var/turf/T = get_turf(src)
	if(T)
		T.fluid_update()
	. = ..()

/obj/structure/Crossed(mob/living/M)
	if(istype(M))
		M.on_structure_offset(mob_offset)
	..()

/obj/structure/proc/reset_mobs_offset()
	for(var/mob/living/M in loc)
		M.on_structure_offset(0)

/obj/structure/Move()
	. = ..()
	if(. && !CanFluidPass())
		fluid_update()

/obj/structure/attack_hand(mob/user)
	..()
	if(breakable)
		if(MUTATION_HULK in user.mutations)
			user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
			attack_generic(user,1,"smashes")
		else if(istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(user))
				attack_generic(user,1,"slices")
	return ..()

/obj/structure/grab_attack(var/obj/item/grab/G)
	if (!G.force_danger())
		to_chat(G.assailant, SPAN_WARNING("You need a better grip to do that!"))
		return TRUE
	if (G.assailant.a_intent == I_HURT)
		// Slam their face against the table.
		var/blocked = G.affecting.get_blocked_ratio(BP_HEAD, BRUTE, damage = 8)
		if (prob(30 * (1 - blocked)))
			G.affecting.Weaken(5)
		G.affecting.apply_damage(8, BRUTE, BP_HEAD)
		visible_message(SPAN_DANGER("[G.assailant] slams [G.affecting]'s face against \the [src]!"))
		if (material)
			playsound(loc, material.tableslam_noise, 50, 1)
		else
			playsound(loc, 'sound/weapons/tablehit1.ogg', 50, 1)
		var/list/L = take_damage(rand(1,5))
		for(var/obj/item/material/shard/S in L)
			if(S.sharp && prob(50))
				G.affecting.visible_message(SPAN_DANGER("\The [S] slices into [G.affecting]'s face!"), SPAN_DANGER("\The [S] slices into your face!"))
				G.affecting.standard_weapon_hit_effects(S, G.assailant, S.force*2, BP_HEAD)
		qdel(G)
	else if(atom_flags & ATOM_FLAG_CLIMBABLE)
		var/obj/occupied = turf_is_crowded()
		if (occupied)
			to_chat(G.assailant, SPAN_WARNING("There's \a [occupied] in the way."))
			return TRUE
		G.affecting.forceMove(src.loc)
		G.affecting.Weaken(rand(2,5))
		visible_message(SPAN_DANGER("[G.assailant] puts [G.affecting] on \the [src]."))
		qdel(G)
		return TRUE

/obj/structure/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			return
