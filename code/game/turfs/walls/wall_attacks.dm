//Interactions
/turf/wall/proc/toggle_open(var/mob/user)

	if(can_open == WALL_OPENING)
		return

	SSradiation.resistance_cache.Remove(src)
	can_open = WALL_OPENING
	sleep(15)
	if(density)
		set_density(FALSE)
		blocks_air = ZONE_BLOCKED
	else
		set_density(TRUE)
		blocks_air = AIR_BLOCKED

	for(var/turf/turf in loc)
		if(turf.simulated)
			SSair.mark_for_update(turf)
	update_icon()
	update_air()
	refresh_opacity()
	can_open = WALL_CAN_OPEN
	update_icon()

/turf/wall/proc/update_air()
	if(!SSair)
		return

	for(var/turf/turf in loc)
		if(turf.simulated)
			update_thermal(turf)
			SSair.mark_for_update(turf)

/turf/wall/proc/update_thermal(var/turf/source)
	if(istype(source) && source.simulated)
		if(density && opacity)
			source.thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
		else
			source.thermal_conductivity = initial(source.thermal_conductivity)

/turf/wall/proc/toggle_shutters(mob/user)
	if(!isnull(shutter_state))
		shutter_state = !shutter_state
		refresh_opacity()
		blocks_air = shutter_state ? ZONE_BLOCKED : AIR_BLOCKED
		if(simulated)
			SSair.mark_for_update(src)
		visible_message(SPAN_NOTICE("\The [user] [shutter_state ? "opens" : "closes"] the shutter."))
		update_icon()
		if(shutter_sound)
			playsound(src, shutter_sound, 25, 1)
		return TRUE
	return FALSE

// You can open shutters from two tiles away, as long as nothing is in the way.
/turf/wall/attack_hand_ranged(mob/user)
	if((. = ..()))
		return
	// have to be 2.5 or fewer tiles away
	if(get_dist_euclidian(user, src) > 2.5)
		return FALSE
	// We need to find the closest dir with a shutter. That means a cardinal dir without a connection.
	var/list/connected = corner_states_to_dirs(wall_connections) | corner_states_to_dirs(other_connections) // merge the lists
	for(var/stepdir in global.cardinal)
		if(stepdir in connected)
			continue
		var/turf/between = get_step(src, stepdir)
		// we have a shutter, but can we interact with it?
		if(between.density) // the intermediate tile is solid
			continue
		// Something is blocking either the user or us.
		if(!user.Adjacent(between) || !between.Adjacent(src))
			continue
		return toggle_shutters(user)
	return FALSE

/turf/wall/proc/try_touch(var/mob/user, var/rotting)
	. = TRUE
	if(rotting)
		if(reinf_material)
			to_chat(user, "<span class='danger'>\The [reinf_material.solid_name] feels porous and crumbly.</span>")
		else
			to_chat(user, "<span class='danger'>\The [material.solid_name] [material.rotting_touch_message]!</span>")
			dismantle_turf()
			return TRUE

	if(can_open)
		toggle_open(user)
		return TRUE

	if(toggle_shutters(user))
		return TRUE

	if (isnull(construction_stage) || !reinf_material)
		to_chat(user, "<span class='notice'>You push \the [src], but nothing happens.</span>")
		playsound(src, get_hit_sound(), 25, 1)
		return TRUE

/turf/wall/attack_hand(var/mob/user)
	radiate()
	add_fingerprint(user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(isliving(user))
		var/mob/living/user_living = user
		var/obj/item/hand = GET_EXTERNAL_ORGAN(user_living, user_living.get_active_held_item_slot())
		if(hand && try_graffiti(user_living, hand))
			return TRUE
	. = ..()
	if(!.)
		return try_touch(user, (locate(/obj/effect/overlay/wallrot) in src))

/turf/wall/proc/handle_wall_tool_interactions(obj/item/used_item, mob/user)
	//get the user's location
	if(!isturf(user.loc))
		return FALSE //can't do this stuff whilst inside objects and such
	if(!construction_stage && try_graffiti(user, used_item))
		return TRUE
	if(used_item)
		radiate()
		if(used_item.get_heat() >= T100C)
			burn(used_item.get_heat())
			. = TRUE
	if(locate(/obj/effect/overlay/wallrot) in src)
		if(IS_WELDER(used_item))
			var/decl/tool_archetype/welder_archetype = GET_DECL(TOOL_WELDER)
			if(welder_archetype.can_use_tool(used_item) == TOOL_USE_SUCCESS && welder_archetype.handle_pre_interaction(user, used_item, 0) == TOOL_USE_SUCCESS)
				to_chat(user, "<span class='notice'>You burn away the fungi with \the [used_item].</span>")
				playsound(src, 'sound/items/Welder.ogg', 10, 1)
				for(var/obj/effect/overlay/wallrot/WR in src)
					qdel(WR)
				return TRUE
		else
			var/force = used_item.expend_attack_force(user)
			if((!used_item.is_sharp() && !used_item.has_edge() && force >= 10) || force >= 20)
				to_chat(user, "<span class='notice'>\The [src] crumbles away under the force of your [used_item.name].</span>")
				physically_destroyed()
				return TRUE
	if(damage && IS_WELDER(used_item))
		if(used_item.do_tool_interaction(TOOL_WELDER, user, src, max(0.5, damage / 50) SECONDS, "repairing the damage to", "repairing the damage to"))
			take_damage(-damage)
		return TRUE

	// Basic dismantling.
	if(isnull(construction_stage) || !reinf_material)
		var/datum/extension/demolisher/demolition = get_extension(used_item, /datum/extension/demolisher)
		if(istype(demolition) && demolition.try_demolish(user, src))
			return TRUE

	//Reinforced dismantling.
	else
		switch(construction_stage)
			if(6)

				if(used_item.is_special_cutting_tool(TRUE))

					to_chat(user, "<span class='notice'>You drive \the [used_item] into the wall and begin trying to rip out the support frame...</span>")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					. = TRUE

					if(!do_after(user, 6 SECONDS, src))
						return

					to_chat(user, "<span class='notice'>You tear through the wall's support system and plating!</span>")
					dismantle_turf()
					user.visible_message("<span class='warning'>The wall was torn open by [user]!</span>")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)

				else if(IS_WIRECUTTER(used_item))
					playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
					construction_stage = 5
					to_chat(user, "<span class='notice'>You cut the outer grille.</span>")
					update_icon()
					return TRUE
			if(5)
				if(IS_SCREWDRIVER(used_item))
					if(!used_item.do_tool_interaction(TOOL_SCREWDRIVER, user, src, 4 SECONDS, "removing the support lines from", "removing the support lines from"))
						return TRUE // block further interactions
					if(!istype(src, /turf/wall) || construction_stage != 5)
						return TRUE // ditto
					construction_stage = 4
					update_icon()
					return TRUE
				else if(IS_WELDER(used_item)) // why is this instant when every other repair action is timed
					var/decl/tool_archetype/welder_archetype = GET_DECL(TOOL_WELDER)
					if(welder_archetype.can_use_tool(used_item) == TOOL_USE_SUCCESS && welder_archetype.handle_pre_interaction(user, used_item, 0) == TOOL_USE_SUCCESS)
						construction_stage = 6
						update_icon()
						to_chat(user, SPAN_NOTICE("You repair the outer grille."))
						return TRUE
			if(4)
				var/cut_cover
				if(istype(used_item,/obj/item/weldingtool))
					var/decl/tool_archetype/welder_archetype = GET_DECL(TOOL_WELDER)
					if(welder_archetype.can_use_tool(used_item) != TOOL_USE_SUCCESS)
						return TRUE
					if(welder_archetype.handle_pre_interaction(user, used_item, 0) != TOOL_USE_SUCCESS)
						return TRUE
					cut_cover = TRUE
				else if (used_item.is_special_cutting_tool())
					if(istype(used_item, /obj/item/gun/energy/plasmacutter))
						var/obj/item/gun/energy/plasmacutter/cutter = used_item
						if(!cutter.slice(user))
							return TRUE
					cut_cover = TRUE
				if(cut_cover)
					to_chat(user, "<span class='notice'>You begin slicing through the metal cover.</span>")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					if(!do_after(user, 6 SECONDS, src) || !istype(src, /turf/wall) || construction_stage != 4)
						return TRUE
					construction_stage = 3
					update_icon()
					to_chat(user, "<span class='notice'>You press firmly on the cover, dislodging it.</span>")
					return TRUE
			if(3)
				if(IS_CROWBAR(used_item))
					if(!used_item.do_tool_interaction(TOOL_CROWBAR, user, src, 10 SECONDS, "struggling to pry the cover off of", "prying the cover off of"))
						return TRUE
					if(!istype(src, /turf/wall) || construction_stage != 3)
						return TRUE
					construction_stage = 2
					update_icon()
					return TRUE
			if(2)
				if(IS_WRENCH(used_item))
					// what a mouthful
					if(!used_item.do_tool_interaction(TOOL_WRENCH, user, src, 4 SECONDS, "loosening the anchoring bolts securing the support rods of", "removing the anchoring bolts of"))
						return TRUE
					if(!istype(src, /turf/wall) || construction_stage != 2)
						return TRUE
					construction_stage = 1
					update_icon()
					return TRUE
			if(1)
				var/cut_cover
				if(istype(used_item, /obj/item/weldingtool))
					var/decl/tool_archetype/welder_archetype = GET_DECL(TOOL_WELDER)
					if(welder_archetype.can_use_tool(used_item) != TOOL_USE_SUCCESS)
						return TRUE
					if(welder_archetype.handle_pre_interaction(user, used_item, 0) != TOOL_USE_SUCCESS)
						return TRUE
					cut_cover = TRUE
				else if(used_item.is_special_cutting_tool())
					if(istype(used_item, /obj/item/gun/energy/plasmacutter))
						var/obj/item/gun/energy/plasmacutter/cutter = used_item
						if(!cutter.slice(user))
							return TRUE
					cut_cover = TRUE
				if(cut_cover)
					to_chat(user, "<span class='notice'>You begin slicing through the support rods.</span>")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					. = TRUE
					if(!do_after(user,7 SECONDS,src) || !istype(src, /turf/wall) || construction_stage != 1)
						return
					construction_stage = 0
					update_icon()
					to_chat(user, "<span class='notice'>You cut the support rods loose from the frame.</span>")
					return
			if(0)
				if(IS_CROWBAR(used_item))
					if(!used_item.do_tool_interaction(TOOL_CROWBAR, user, src, 10 SECONDS, "struggling to pry the outer sheath off of", "prying the outer sheath off of"))
						return TRUE
					if(!istype(src, /turf/wall) || construction_stage != 0)
						return TRUE
					dismantle_turf()
					return TRUE

	return FALSE

/turf/wall/attackby(var/obj/item/used_item, var/mob/user, click_params)

	if(istype(used_item, /obj/item/stack/tile/roof) || !user.check_dexterity(DEXTERITY_SIMPLE_MACHINES) || !used_item.user_can_attack_with(user))
		return ..()

	if(handle_wall_tool_interactions(used_item, user))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		return TRUE

	if(istype(used_item,/obj/item/frame))
		var/obj/item/frame/F = used_item
		F.try_build(src, click_params)
		return TRUE

	// Attack the wall with items
	var/force = used_item.expend_attack_force(user)
	if(istype(used_item,/obj/item/rcd) || istype(used_item, /obj/item/chems) || !force || user.check_intent(I_FLAG_HELP))
		return ..()

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)

	var/damage_threshold = max(2, max(material.wall_damage_threshold, reinf_material?.wall_damage_threshold))
	var/material_divisor = max(material.brute_armor, reinf_material?.brute_armor)
	if(used_item.atom_damage_type == BURN)
		material_divisor = max(material.burn_armor, reinf_material?.burn_armor)
	var/effective_force = round(force / material_divisor)
	if(effective_force < damage_threshold)
		visible_message(SPAN_DANGER("\The [user] has [used_item.pick_attack_verb()] \the [src] with \the [used_item], but it has no effect!"))
		playsound(src, get_hit_sound(), 25, 1)
		return TRUE
	// Check for a glancing blow.
	var/dam_prob = max(0, 100 - material.hardness + effective_force + used_item.armor_penetration)
	if(!prob(dam_prob))
		visible_message(SPAN_DANGER("\The [user] has [used_item.pick_attack_verb()] \the [src] with \the [used_item], but it bounced off!"))
		playsound(src, get_hit_sound(), 25, 1)
		if(user.skill_fail_prob(SKILL_HAULING, 40, SKILL_ADEPT))
			SET_STATUS_MAX(user, STAT_WEAK, 2)
			visible_message(SPAN_DANGER("\The [user] is knocked back by the force of the blow!"))
		return TRUE

	visible_message(SPAN_DANGER("\The [user] has [used_item.pick_attack_verb()] \the [src] with \the [used_item]!"))
	playsound(src, get_hit_sound(), 50, 1)
	take_damage(effective_force)
	return TRUE