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
	set_light(density)
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

	if (isnull(construction_stage) || !reinf_material)
		to_chat(user, "<span class='notice'>You push \the [src], but nothing happens.</span>")
		playsound(src, hitsound, 25, 1)
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

/turf/wall/proc/handle_wall_tool_interactions(obj/item/W, mob/user)
	//get the user's location
	if(!isturf(user.loc))
		return FALSE //can't do this stuff whilst inside objects and such
	if(!construction_stage && try_graffiti(user, W))
		return TRUE
	if(W)
		radiate()
		if(W.get_heat() >= T100C)
			burn(W.get_heat())
			. = TRUE
	if(locate(/obj/effect/overlay/wallrot) in src)
		if(IS_WELDER(W))
			var/obj/item/weldingtool/WT = W
			if( WT.weld(0,user) )
				to_chat(user, "<span class='notice'>You burn away the fungi with \the [WT].</span>")
				playsound(src, 'sound/items/Welder.ogg', 10, 1)
				for(var/obj/effect/overlay/wallrot/WR in src)
					qdel(WR)
				return TRUE
		else if(!is_sharp(W) && W.force >= 10 || W.force >= 20)
			to_chat(user, "<span class='notice'>\The [src] crumbles away under the force of your [W.name].</span>")
			physically_destroyed()
			return TRUE
	var/turf/T = user.loc	//get user's location for delay checks
	if(damage && istype(W, /obj/item/weldingtool))

		var/obj/item/weldingtool/WT = W

		if(WT.weld(0,user))
			to_chat(user, "<span class='notice'>You start repairing the damage to [src].</span>")
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(do_after(user, max(5, damage / 5), src) && WT && WT.isOn())
				to_chat(user, "<span class='notice'>You finish repairing the damage to [src].</span>")
				take_damage(-damage)
		return TRUE

	// Basic dismantling.
	if(isnull(construction_stage) || !reinf_material)

		var/cut_delay = (6 SECONDS) - material.cut_delay
		var/dismantle_verb
		var/dismantle_sound

		if(IS_WELDER(W))

			if(material && !material.removed_by_welder)
				to_chat(user, SPAN_WARNING("\The [src] is too delicate to be dismantled with \the [W]; try a crowbar."))
				return TRUE

			var/obj/item/weldingtool/WT = W
			if(!WT.weld(0,user))
				return
			dismantle_verb = "cutting through"
			dismantle_sound = 'sound/items/Welder.ogg'
			cut_delay *= 0.7

		else if(IS_CROWBAR(W))

			if(material && material.removed_by_welder)
				to_chat(user, SPAN_WARNING("\The [src] is too robust to be dismantled with \the [W]; try a welding tool."))
				return TRUE

			dismantle_verb = "dismantling"
			dismantle_sound = 'sound/items/Crowbar.ogg'
			cut_delay *= 1.2

		else if(W.is_special_cutting_tool())
			if(istype(W, /obj/item/gun/energy/plasmacutter))
				var/obj/item/gun/energy/plasmacutter/cutter = W
				if(!cutter.slice(user))
					return TRUE
			dismantle_sound = "sparks"
			dismantle_verb = "slicing through"
			cut_delay *= 0.5

		else if(IS_PICK(W))

			if(W.material?.hardness < material.hardness)
				to_chat(user, SPAN_WARNING("\The [W] is not hard enough to cut through [material.solid_name]."))
				return TRUE

			dismantle_verb  = W.get_tool_message(TOOL_PICK)
			dismantle_sound = W.get_tool_sound(TOOL_PICK)
			cut_delay       = W.get_expected_tool_use_delay(TOOL_PICK, cut_delay)

		if(dismantle_verb)

			to_chat(user, "<span class='notice'>You begin [dismantle_verb] \the [src].</span>")
			if(dismantle_sound)
				playsound(src, dismantle_sound, 100, 1)

			if(cut_delay<0)
				cut_delay = 0

			if(do_after(user,cut_delay,src))
				to_chat(user, "<span class='notice'>You remove the outer plating.</span>")
				user.visible_message("<span class='warning'>\The [user] finishes [dismantle_verb] \the [src]!</span>")
				dismantle_turf()
			return TRUE

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
					dismantle_turf()
					user.visible_message("<span class='warning'>The wall was torn open by [user]!</span>")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)

				else if(IS_WIRECUTTER(W))
					playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
					construction_stage = 5
					to_chat(user, "<span class='notice'>You cut the outer grille.</span>")
					update_icon()
					return TRUE
			if(5)
				if(IS_SCREWDRIVER(W))
					to_chat(user, "<span class='notice'>You begin removing the support lines.</span>")
					playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
					. = TRUE
					if(!do_after(user,40,src) || !istype(src, /turf/wall) || construction_stage != 5)
						return
					construction_stage = 4
					update_icon()
					to_chat(user, "<span class='notice'>You remove the support lines.</span>")
					return
				else if(istype(W,/obj/item/weldingtool))
					var/obj/item/weldingtool/WT = W
					if(WT.weld(0,user))
						construction_stage = 6
						update_icon()
						to_chat(user, SPAN_NOTICE("You repair the outer grille."))
						return TRUE
			if(4)
				var/cut_cover
				if(istype(W,/obj/item/weldingtool))
					var/obj/item/weldingtool/WT = W
					if(WT.weld(0,user))
						cut_cover=1
					else
						return
				else if (W.is_special_cutting_tool())
					if(istype(W, /obj/item/gun/energy/plasmacutter))
						var/obj/item/gun/energy/plasmacutter/cutter = W
						if(!cutter.slice(user))
							return
					cut_cover = 1
				if(cut_cover)
					to_chat(user, "<span class='notice'>You begin slicing through the metal cover.</span>")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					. = TRUE
					if(!do_after(user, 60, src) || !istype(src, /turf/wall) || construction_stage != 4)
						return
					construction_stage = 3
					update_icon()
					to_chat(user, "<span class='notice'>You press firmly on the cover, dislodging it.</span>")
					return
			if(3)
				if(IS_CROWBAR(W))
					to_chat(user, "<span class='notice'>You struggle to pry off the cover.</span>")
					playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
					. = TRUE
					if(!do_after(user,100,src) || !istype(src, /turf/wall) || construction_stage != 3)
						return
					construction_stage = 2
					update_icon()
					to_chat(user, "<span class='notice'>You pry off the cover.</span>")
					return
			if(2)
				if(IS_WRENCH(W))
					to_chat(user, "<span class='notice'>You start loosening the anchoring bolts which secure the support rods to their frame.</span>")
					playsound(src, 'sound/items/Ratchet.ogg', 100, 1)
					. = TRUE
					if(!do_after(user,40,src) || !istype(src, /turf/wall) || construction_stage != 2)
						return
					construction_stage = 1
					update_icon()
					to_chat(user, "<span class='notice'>You remove the bolts anchoring the support rods.</span>")
					return
			if(1)
				var/cut_cover
				if(istype(W, /obj/item/weldingtool))
					var/obj/item/weldingtool/WT = W
					if( WT.weld(0,user) )
						cut_cover=1
					else
						return
				else if(W.is_special_cutting_tool())
					if(istype(W, /obj/item/gun/energy/plasmacutter))
						var/obj/item/gun/energy/plasmacutter/cutter = W
						if(!cutter.slice(user))
							return
					cut_cover = 1
				if(cut_cover)
					to_chat(user, "<span class='notice'>You begin slicing through the support rods.</span>")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					. = TRUE
					if(!do_after(user,70,src) || !istype(src, /turf/wall) || construction_stage != 1)
						return
					construction_stage = 0
					update_icon()
					to_chat(user, "<span class='notice'>You cut the support rods loose from the frame.</span>")
					return
			if(0)
				if(IS_CROWBAR(W))
					to_chat(user, "<span class='notice'>You struggle to pry off the outer sheath.</span>")
					playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
					. = TRUE
					if(!do_after(user,100,src) || !istype(src, /turf/wall) || !user || !W || !T )	return
					if(user.loc == T && user.get_active_held_item() == W )
						to_chat(user, "<span class='notice'>You pry off the outer sheath.</span>")
						dismantle_turf()
					return

	return FALSE

/turf/wall/attackby(var/obj/item/W, var/mob/user, click_params)

	if(istype(W, /obj/item/stack/tile/roof) || !user.check_dexterity(DEXTERITY_SIMPLE_MACHINES) || !W.user_can_wield(user))
		return ..()

	if(handle_wall_tool_interactions(W, user))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		return TRUE

	if(istype(W,/obj/item/frame))
		var/obj/item/frame/F = W
		F.try_build(src, click_params)
		return TRUE

	// Attack the wall with items
	if(istype(W,/obj/item/rcd) || istype(W, /obj/item/chems) || !W.force || user.a_intent == I_HELP)
		return ..()

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	var/material_divisor = max(material.brute_armor, reinf_material?.brute_armor)
	if(W.atom_damage_type == BURN)
		material_divisor = max(material.burn_armor, reinf_material?.burn_armor)
	var/effective_force = round(W.force / material_divisor)
	if(effective_force < 2)
		visible_message(SPAN_DANGER("\The [user] [pick(W.attack_verb)] \the [src] with \the [W], but it had no effect!"))
		playsound(src, hitsound, 25, 1)
		return TRUE
	// Check for a glancing blow.
	var/dam_prob = max(0, 100 - material.hardness + effective_force + W.armor_penetration)
	if(!prob(dam_prob))
		visible_message(SPAN_DANGER("\The [user] [pick(W.attack_verb)] \the [src] with \the [W], but it bounced off!"))
		playsound(src, hitsound, 25, 1)
		if(user.skill_fail_prob(SKILL_HAULING, 40, SKILL_ADEPT))
			SET_STATUS_MAX(user, STAT_WEAK, 2)
			visible_message(SPAN_DANGER("\The [user] is knocked back by the force of the blow!"))
		return TRUE

	playsound(src, get_hit_sound(), 50, 1)
	visible_message(SPAN_DANGER("\The [user] [pick(W.attack_verb)] \the [src] with \the [W]!"))
	take_damage(effective_force)
	return TRUE