GLOBAL_LIST_INIT(default_blend_objects,   list(/obj/machinery/door, /turf/simulated/wall))
GLOBAL_LIST_INIT(default_noblend_objects, list(/obj/machinery/door/window))

/obj/structure
	icon = 'icons/obj/structures.dmi'
	w_class = ITEM_SIZE_NO_CONTAINER
	layer = STRUCTURE_LAYER

	var/handle_generic_blending
	var/dismantled = FALSE
	var/breakable
	var/parts_type
	var/footstep_type
	var/mob_offset

	var/material/material
	var/material/reinf_material
	var/material_alteration

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

/obj/structure/get_material()
	. = material

/obj/structure/on_update_icon()
	if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
		update_material_colour()
	overlays.Cut()

/obj/structure/proc/update_materials(var/keep_health)
	if(material_alteration & MAT_FLAG_ALTERATION_NAME)
		update_material_name()
	if(material_alteration & MAT_FLAG_ALTERATION_DESC)
		update_material_desc()
	queue_icon_update()

/obj/structure/proc/update_material_name(var/override_name)
	var/base_name = override_name || initial(name)
	if(istype(material))
		SetName("[material.display_name] [base_name]")
	else
		SetName(base_name)

/obj/structure/proc/update_material_desc(var/override_desc)
	var/base_desc = override_desc || initial(desc)
	if(istype(material))
		desc = "[base_desc] This one is made of [material.display_name]."
	else
		desc = base_desc

/obj/structure/proc/update_material_colour(var/override_colour)
	var/base_colour = override_colour || initial(color)
	if(istype(material))
		color = material.icon_colour
	else
		color = base_colour

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
	dismantle(do_not_destroy = TRUE)
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

/obj/structure/proc/can_visually_connect()
	return anchored && handle_generic_blending

/obj/structure/proc/can_visually_connect_to(var/obj/structure/S)
	return istype(S, src)

/obj/structure/proc/clear_connections()
	return

/obj/structure/proc/set_connections(dirs, other_dirs)
	return

/obj/structure/proc/refresh_neighbors()
	for(var/thing in RANGE_TURFS(src, 1))
		var/turf/T = thing
		T.update_icon()

/obj/structure/proc/find_blendable_obj_in_turf(var/turf/T, var/propagate)
	if(is_type_in_list(T, GLOB.default_blend_objects))
		if(propagate && istype(T, /turf/simulated/wall))
			var/turf/simulated/wall/W = T
			W.update_connections(1)
		return TRUE
	for(var/obj/O in T)
		if(!is_type_in_list(O, GLOB.default_blend_objects))
			continue
		if(is_type_in_list(O, GLOB.default_noblend_objects))
			continue
		return TRUE
	return FALSE

/obj/structure/proc/update_connections(propagate = 0)

	if(!can_visually_connect())
		clear_connections()
		return FALSE

	var/list/dirs
	var/list/other_dirs
	for(var/direction in GLOB.alldirs)
		var/turf/T = get_step(src, direction)
		if(T)
			for(var/obj/structure/S in T)
				if(can_visually_connect_to(S) && S.can_visually_connect())
					if(propagate)
						S.update_connections()
						S.update_icon()
					LAZYADD(dirs, direction)
			if((direction in GLOB.cardinal) && find_blendable_obj_in_turf(T, propagate))
				LAZYDISTINCTADD(dirs, direction)
				LAZYADD(other_dirs, direction)

	refresh_neighbors()
	set_connections(dirs, other_dirs)
	return TRUE

/obj/structure/proc/dismantle(var/do_not_destroy)
	if(!dismantled)
		dismantled = TRUE
		reset_mobs_offset()
		var/turf/T = get_turf(src)
		if(T)
			if(parts_type)
				new parts_type(T, (material && material.type), (reinf_material && reinf_material.type))
			else 
				if(material)
					material.place_dismantled_product(T)
				if(reinf_material)
					reinf_material.place_dismantled_product(T)
			T.fluid_update()
		if(!do_not_destroy && !QDELETED(src))
			qdel(src)
	. = TRUE
