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
			to_chat(user, "<span class='danger'>\The [material.solid_name] [material.rotting_touch_message]!</span>")
			dismantle_wall()
			return

	if(!can_open)
		to_chat(user, "<span class='notice'>You push \the [src], but nothing happens.</span>")
		playsound(src, hitsound, 25, 1)
	else if (isnull(construction_stage) || !reinf_material)
		toggle_open(user)

/turf/simulated/wall/attack_hand(var/mob/user)
	radiate()
	add_fingerprint(user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/hand = GET_EXTERNAL_ORGAN(H, H.get_active_held_item_slot())
		if(hand && try_graffiti(H, hand))
			return TRUE
	. = ..()
	if(!.)
		return try_touch(user, (locate(/obj/effect/overlay/wallrot) in src))

/turf/simulated/wall/attackby(var/obj/item/W, var/mob/user, click_params)

	if(istype(W, /obj/item/stack/tile/roof))
		return ..()

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(!construction_stage && try_graffiti(user, W))
		return TRUE

	if (!user.check_dexterity(DEXTERITY_SIMPLE_MACHINES))
		return

	//get the user's location
	if(!isturf(user.loc))	return	//can't do this stuff whilst inside objects and such

	if(W)
		radiate()
		if(W.get_heat() >= T100C)
			burn(W.get_heat())

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
			src.dismantle_wall(1)
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

		var/cut_delay = 60 - material.cut_delay
		var/dismantle_verb
		var/dismantle_sound

		if(IS_WELDER(W))

			if(material && !material.removed_by_welder)
				to_chat(user, SPAN_WARNING("\The [src] is too delicate to be dismantled with \the [W]; try a crowbar."))
				return TRUE

			var/obj/item/weldingtool/WT = W
			if(!WT.weld(0,user))
				return
			dismantle_verb = "cutting"
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
			dismantle_verb = "slicing"
			cut_delay *= 0.5
		else if(istype(W,/obj/item/pickaxe))
			var/obj/item/pickaxe/P = W
			dismantle_verb = P.drill_verb
			dismantle_sound = P.drill_sound
			cut_delay -= P.digspeed

		if(dismantle_verb)
			. = TRUE
			to_chat(user, "<span class='notice'>You begin [dismantle_verb] through the outer plating.</span>")
			if(dismantle_sound)
				playsound(src, dismantle_sound, 100, 1)

			if(cut_delay<0)
				cut_delay = 0

			if(!do_after(user,cut_delay,src))
				return

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
					if(!do_after(user,40,src) || !istype(src, /turf/simulated/wall) || construction_stage != 5)
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
					if(!do_after(user, 60, src) || !istype(src, /turf/simulated/wall) || construction_stage != 4)
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
					if(!do_after(user,100,src) || !istype(src, /turf/simulated/wall) || construction_stage != 3)
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
					if(!do_after(user,40,src) || !istype(src, /turf/simulated/wall) || construction_stage != 2)
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
					if(!do_after(user,70,src) || !istype(src, /turf/simulated/wall) || construction_stage != 1)
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
					if(!do_after(user,100,src) || !istype(src, /turf/simulated/wall) || !user || !W || !T )	return
					if(user.loc == T && user.get_active_hand() == W )
						to_chat(user, "<span class='notice'>You pry off the outer sheath.</span>")
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