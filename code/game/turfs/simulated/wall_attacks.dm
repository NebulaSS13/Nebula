//Interactions
/turf/simulated/wall/proc/toggle_open(var/mob/user)

	if(can_open == WALL_OPENING)
		return

	SSradiation.resistance_cache.Remove(src)

	if(density)
		can_open = WALL_OPENING
		sleep(15)
		set_density(0)
		set_opacity(0)
		blocks_air = ZONE_BLOCKED
		update_icon()
		update_air()
		set_light(0)
		src.blocks_air = 0
		set_opacity(0)
		for(var/turf/simulated/turf in loc)
			SSair.mark_for_update(turf)
	else
		can_open = WALL_OPENING
		set_density(1)
		set_opacity(1)
		blocks_air = AIR_BLOCKED
		update_icon()
		update_air()
		sleep(15)
		set_light(1)
		src.blocks_air = 1
		set_opacity(1)
		for(var/turf/simulated/turf in loc)
			SSair.mark_for_update(turf)

	can_open = WALL_CAN_OPEN
	update_icon()

/turf/simulated/wall/proc/update_air()
	if(!SSair)
		return

	for(var/turf/simulated/turf in loc)
		update_thermal(turf)
		SSair.mark_for_update(turf)


/turf/simulated/wall/proc/update_thermal(var/turf/simulated/source)
	if(istype(source))
		if(density && opacity)
			source.thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
		else
			source.thermal_conductivity = initial(source.thermal_conductivity)



/turf/simulated/wall/proc/fail_smash(var/mob/user)
	to_chat(user, "<span class='danger'>You smash against \the [src]!</span>")
	take_damage(rand(25,75))

/turf/simulated/wall/proc/success_smash(var/mob/user)
	to_chat(user, "<span class='danger'>You smash through \the [src]!</span>")
	user.do_attack_animation(src)
	spawn(1)
		dismantle_wall(1)

/turf/simulated/wall/proc/try_touch(var/mob/user, var/rotting)
	. = TRUE
	if(rotting)
		if(reinf_material)
			to_chat(user, "<span class='danger'>\The [reinf_material.solid_name] feels porous and crumbly.</span>")
		else
			to_chat(user, "<span class='danger'>\The [material.solid_name] crumbles under your touch!</span>")
			dismantle_wall()
			return

	if(!can_open)
		to_chat(user, "<span class='notice'>You push \the [src], but nothing happens.</span>")
		playsound(src, hitsound, 25, 1)
	else
		toggle_open(user)

/turf/simulated/wall/attack_hand(var/mob/user)
	radiate()
	add_fingerprint(user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/rotting = (locate(/obj/effect/overlay/wallrot) in src)
	if (MUTATION_HULK in user.mutations)
		if (rotting || !prob(material.hardness))
			success_smash(user)
		else
			fail_smash(user)
		return TRUE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/hand = H.organs_by_name[H.get_active_held_item_slot()]
		if(hand && try_graffiti(H, hand))
			return TRUE
	. = ..()
	if(!.)
		return try_touch(user, rotting)

/turf/simulated/wall/attackby(var/obj/item/W, var/mob/user, click_params)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(!construction_stage && try_graffiti(user, W))
		return TRUE

	if (!user.check_dexterity(DEXTERITY_SIMPLE_MACHINES))
		return

	//get the user's location
	if(!istype(user.loc, /turf))	return	//can't do this stuff whilst inside objects and such

	if(W)
		radiate()
		if(W.get_heat() >= T100C)
			burn(W.get_heat())

	if(locate(/obj/effect/overlay/wallrot) in src)
		if(isWelder(W))
			if(W.do_tool_interaction(TOOL_WELDER, user, src, 0, "burning fungus off of", "burning fungus off of", fuel_expenditure = 1))
				for(var/obj/effect/overlay/wallrot/WR in src)
					qdel(WR)
				return TRUE
		else if(!is_sharp(W) && W.force >= 10 || W.force >= 20)
			to_chat(user, "<span class='notice'>\The [src] crumbles away under the force of your [W.name].</span>")
			src.dismantle_wall(1)
			return TRUE


	if(damage)

		if(W.do_tool_interaction(TOOL_WELDER, user, src, max(5, damage / 5) SECONDS, "repairing", "repairing", fuel_expenditure = max(5, damage / 5)))
			take_damage(-damage)
		return TRUE

	// Basic dismantling.
	if(isnull(construction_stage) || !reinf_material)

		var/cut_delay = 60 - material.cut_delay
		var/dismantled = FALSE
		
		if(isWelder(W))
			if(material && !material.removed_by_welder)
				to_chat(user, SPAN_WARNING("\The [src] is too delicate to be dismantled with \the [W]; try a crowbar."))
				return TRUE
		else if(isCrowbar(W))
			if(material && material.removed_by_welder)
				to_chat(user, SPAN_WARNING("\The [src] is too robust to be dismantled with \the [W]; try a welding tool."))
				return TRUE
		else if(W.is_special_cutting_tool(TRUE))
			dismantled = TRUE

		if(isWelder(W) || isCrowbar(W))
			if(isCrowbar(W))
				if(W.do_tool_interaction(TOOL_CROWBAR, user, src, cut_delay, "removing the outer plating of", "removing the outer plating of"))
					dismantled = TRUE
			if(isWelder(W))
				if(W.do_tool_interaction(TOOL_WELDER, user, src, cut_delay, "removing the outer plating of", "removing the outer plating of", fuel_expenditure = 1))
					dismantled = TRUE

		if(istype(W,/obj/item/pickaxe))
			if(do_after(user, cut_delay, src))
				dismantled = TRUE
				
		if(dismantled)
			. = TRUE
			to_chat(user, "<span class='notice'>You remove the outer plating.</span>")
			dismantle_wall()
			user.visible_message("<span class='warning'>\The [src] was torn open by [user]!</span>")
			return

	//Reinforced dismantling.
	else
		switch(construction_stage)
			if(6)

				if(W.is_special_cutting_tool(TRUE))
					to_chat(user, "<span class='notice'>You drive \the [W] into the wall and begin trying to rip out the support frame...</span>")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					. = TRUE

					if(!do_after(user, 60, src))
						return

					to_chat(user, "<span class='notice'>You tear through the wall's support system and plating!</span>")
					dismantle_wall()
					user.visible_message("<span class='warning'>The wall was torn open by [user]!</span>")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)

				else if(isWirecutter(W))
					if(W.do_tool_interaction(TOOL_WIRECUTTERS, user, src, 0, "cutting the outer grille of", "cutting the outer grille of"))
						construction_stage = 5
						SSmaterials.create_object(/decl/material/solid/metal/steel, src, 1, /obj/item/stack/material/rods)
						to_chat(user, "<span class='notice'>You cut the outer grille.</span>")
						update_icon()
						return TRUE
			if(5)
				if(isScrewdriver(W))
					. = TRUE
					if(W.do_tool_interaction(TOOL_SCREWDRIVER, user, src, 4 SECONDS, "removing the support lines of", "removing the support lines of"))
						construction_stage = 4
						update_icon()
						return
				else if( istype(W, /obj/item/stack/material/rods) )
					var/obj/item/stack/O = W
					if(O.use(1))
						construction_stage = 6
						update_icon()
						to_chat(user, "<span class='notice'>You replace the outer grille.</span>")
						return TRUE
			if(4)
				if(isWelder(W))
					. = TRUE
					if(W.do_tool_interaction(TOOL_WELDER, user, src, 6 SECONDS, "slicing through the metal cover of", "dislodging the metal cover of", fuel_expenditure = 5))
						construction_stage = 3
						update_icon()
						return
			if(3)
				if(isCrowbar(W))
					. = TRUE
					if(W.do_tool_interaction(TOOL_CROWBAR, user, src, 10 SECONDS, "struggling to pry the cover off of", "prying the cover off of"))
						construction_stage = 2
						update_icon()
						return
			if(2)
				if(isWrench(W))
					. = TRUE
					if(W.do_tool_interaction(TOOL_WRENCH, user, src, 4 SECONDS, "loosening the anchoring bolts of", "loosening the anchoring bolts of"))
						construction_stage = 1
						update_icon()
						return
			if(1)
				if(isWelder(W))
					. = TRUE
					if(W.do_tool_interaction(TOOL_WELDER, user, src, 7 SECONDS, "slicing through the support rods of", "slicing through the support rods of"))
						construction_stage = 0
						update_icon()
						SSmaterials.create_object(/decl/material/solid/metal/steel, src, 1, /obj/item/stack/material/rods)
						return
			if(0)
				if(isCrowbar(W))
					. = TRUE
					if(W.do_tool_interaction(TOOL_CROWBAR, user, src, 10 SECONDS, "struggling to pry the outer sheath off", "prying the outer sheath off"))
						dismantle_wall()
					return

	if(istype(W,/obj/item/frame))
		var/obj/item/frame/F = W
		F.try_build(src, click_params)
		return TRUE

	// Attack the wall with items
	if(istype(W,/obj/item/rcd) || istype(W, /obj/item/chems))
		return
	if(!W.force)
		return
	if(isliving(user))
		var/mob/living/L = user
		if(L.a_intent == I_HELP)
			return

	user.do_attack_animation(src)
	var/material_divisor = max(material.brute_armor, reinf_material?.brute_armor)
	if(W.damtype == BURN)
		material_divisor = max(material.burn_armor, reinf_material?.burn_armor)
	var/effective_force = round(W.force / material_divisor)
	if(effective_force < 2)
		visible_message(SPAN_DANGER("\The [user] [pick(W.attack_verb)] \the [src] with \the [W], but it had no effect!"))
		playsound(src, hitsound, 25, 1)
		return
	// Check for a glancing blow.
	var/dam_prob = max(0, 100 - material.hardness + effective_force + W.armor_penetration)
	if(!prob(dam_prob))
		visible_message(SPAN_DANGER("\The [user] [pick(W.attack_verb)] \the [src] with \the [W], but it bounced off!"))
		playsound(src, hitsound, 25, 1)
		if(user.skill_fail_prob(SKILL_HAULING, 40, SKILL_ADEPT))
			SET_STATUS_MAX(user, STAT_WEAK, 2)
			visible_message(SPAN_DANGER("\The [user] is knocked back by the force of the blow!"))
		return

	playsound(src, 'sound/effects/metalhit.ogg', 50, 1)
	visible_message(SPAN_DANGER("\The [user] [pick(W.attack_verb)] \the [src] with \the [W]!"))
	take_damage(effective_force)
	return TRUE
