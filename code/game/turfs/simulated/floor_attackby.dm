/turf/simulated/floor/attack_hand(mob/user)
	if(!ishuman(user))
		return ..()
	var/mob/living/carbon/human/H = user
	var/obj/item/hand = GET_EXTERNAL_ORGAN(H, H.get_active_held_item_slot())
	if(hand && try_graffiti(H, hand))
		return TRUE
	return ..()

/turf/simulated/floor/attackby(var/obj/item/C, var/mob/user)

	if(!C || !user)
		return 0

	if(istype(C, /obj/item/stack/tile/roof))
		var/obj/item/stack/tile/roof/T = C
		T.try_build_turf(user, src)
		return TRUE

	if(IS_COIL(C) || (flooring && istype(C, /obj/item/stack/material/rods)))
		return ..(C, user)

	if(!(IS_SCREWDRIVER(C) && flooring && (flooring.flags & TURF_REMOVE_SCREWDRIVER)) && try_graffiti(user, C))
		return TRUE

	if(flooring)
		if(IS_CROWBAR(C) && user.a_intent != I_HURT)
			if(broken || burnt)
				if(!user.do_skilled(flooring.remove_timer, SKILL_CONSTRUCTION, src, 0.15))
					return TRUE
				if(!flooring)
					return
				to_chat(user, "<span class='notice'>You remove the broken [flooring.descriptor].</span>")
				make_plating()
			else if(flooring.flags & TURF_IS_FRAGILE)
				if(!user.do_skilled(flooring.remove_timer, SKILL_CONSTRUCTION, src, 0.15))
					return TRUE
				if(!flooring)
					return
				to_chat(user, "<span class='danger'>You forcefully pry off the [flooring.descriptor], destroying them in the process.</span>")
				make_plating()
			else if(flooring.flags & TURF_REMOVE_CROWBAR)
				if(!user.do_skilled(flooring.remove_timer, SKILL_CONSTRUCTION, src))
					return TRUE
				if(!flooring)
					return
				to_chat(user, "<span class='notice'>You lever off the [flooring.descriptor].</span>")
				make_plating(1)
			else
				return
			playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
			return TRUE
		else if(IS_SCREWDRIVER(C) && (flooring.flags & TURF_REMOVE_SCREWDRIVER))
			if(broken || burnt)
				return
			if(!user.do_skilled(flooring.remove_timer, SKILL_CONSTRUCTION, src))
				return TRUE
			if(!flooring)
				return
			to_chat(user, "<span class='notice'>You unscrew and remove the [flooring.descriptor].</span>")
			make_plating(1)
			playsound(src, 'sound/items/Screwdriver.ogg', 80, 1)
			return TRUE
		else if(IS_WRENCH(C) && (flooring.flags & TURF_REMOVE_WRENCH))
			if(!user.do_skilled(flooring.remove_timer, SKILL_CONSTRUCTION, src))
				return TRUE
			if(!flooring)
				return
			to_chat(user, "<span class='notice'>You unwrench and remove the [flooring.descriptor].</span>")
			make_plating(1)
			playsound(src, 'sound/items/Ratchet.ogg', 80, 1)
			return TRUE
		else if(IS_SHOVEL(C) && (flooring.flags & TURF_REMOVE_SHOVEL))
			if(!user.do_skilled(flooring.remove_timer, SKILL_CONSTRUCTION, src))
				return TRUE
			if(!flooring)
				return
			to_chat(user, "<span class='notice'>You shovel off the [flooring.descriptor].</span>")
			make_plating(1)
			playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
			return TRUE
		else if(IS_COIL(C))
			to_chat(user, "<span class='warning'>You must remove the [flooring.descriptor] first.</span>")
			return TRUE
	else

		if(istype(C, /obj/item/stack))
			if(broken || burnt)
				to_chat(user, "<span class='warning'>This section is too damaged to support anything. Use a welder to fix the damage.</span>")
				return TRUE
			//first check, catwalk? Else let flooring do its thing
			if(locate(/obj/structure/catwalk, src))
				return
			if (istype(C, /obj/item/stack/material/rods))
				var/obj/item/stack/material/rods/R = C
				if (R.use(2))
					playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
					new /obj/structure/catwalk(src, R.material.type)
					return TRUE
				return
			var/obj/item/stack/S = C
			var/decl/flooring/use_flooring
			var/list/decls = decls_repository.get_decls_of_subtype(/decl/flooring)
			for(var/flooring_type in decls)
				var/decl/flooring/F = decls[flooring_type]
				if(!F.build_type)
					continue
				if((ispath(S.type, F.build_type) || ispath(S.build_type, F.build_type)) && (isnull(F.build_material) || S.material?.type == F.build_material))
					use_flooring = F
					break
			if(!use_flooring)
				return
			// Do we have enough?
			if(use_flooring.build_cost && S.get_amount() < use_flooring.build_cost)
				to_chat(user, "<span class='warning'>You require at least [use_flooring.build_cost] [S.name] to complete the [use_flooring.descriptor].</span>")
				return TRUE
			// Stay still and focus...
			if(use_flooring.build_time && !do_after(user, use_flooring.build_time, src))
				return TRUE
			if(flooring || !S || !user || !use_flooring)
				return TRUE
			if(S.use(use_flooring.build_cost))
				set_flooring(use_flooring)
				playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
			return TRUE
		// Repairs and Deconstruction.
		else if(IS_CROWBAR(C))
			if(broken || burnt)
				playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
				visible_message("<span class='notice'>[user] has begun prying off the damaged plating.</span>")
				. = TRUE
				var/turf/T = GetBelow(src)
				if(T)
					T.visible_message("<span class='warning'>The ceiling above looks as if it's being pried off.</span>")
				if(do_after(user, 10 SECONDS))
					if(!broken && !burnt || !(is_plating()))return
					visible_message("<span class='warning'>[user] has pried off the damaged plating.</span>")
					new /obj/item/stack/tile/floor(src)
					src.ReplaceWithLattice()
					playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
					if(T)
						T.visible_message("<span class='danger'>The ceiling above has been pried off!</span>")
			return
		else if(IS_WELDER(C))
			var/obj/item/weldingtool/welder = C
			if(welder.isOn() && (is_plating()))
				if(broken || burnt)
					if(welder.weld(0, user))
						to_chat(user, "<span class='notice'>You fix some dents on the broken plating.</span>")
						playsound(src, 'sound/items/Welder.ogg', 80, 1)
						icon_state = "plating"
						burnt = null
						broken = null
						return TRUE
				else
					if(welder.weld(0, user))
						playsound(src, 'sound/items/Welder.ogg', 80, 1)
						visible_message("<span class='notice'>[user] has started melting the plating's reinforcements!</span>")
						. = TRUE
						if(do_after(user, 5 SECONDS) && welder.isOn() && welder_melt())
							visible_message("<span class='warning'>[user] has melted the plating's reinforcements! It should be possible to pry it off.</span>")
							playsound(src, 'sound/items/Welder.ogg', 80, 1)
				return
		else if(istype(C, /obj/item/gun/energy/plasmacutter) && (is_plating()) && !broken && !burnt)
			var/obj/item/gun/energy/plasmacutter/cutter = C
			if(!cutter.slice(user))
				return ..()
			playsound(src, 'sound/items/Welder.ogg', 80, 1)
			visible_message("<span class='notice'>[user] has started slicing through the plating's reinforcements!</span>")
			. = TRUE
			if(do_after(user, 3 SECONDS) && welder_melt())
				visible_message("<span class='warning'>[user] has sliced through the plating's reinforcements! It should be possible to pry it off.</span>")
				playsound(src, 'sound/items/Welder.ogg', 80, 1)
			return

	return ..()

/turf/simulated/floor/proc/welder_melt()
	if(!(is_plating()) || broken || burnt)
		return FALSE
	// if burnt/broken is nonzero plating just chooses a random icon
	// so it doesn't really matter what we set this to as long as it's truthy
	// let's keep it a string for consistency with the other uses of it
	burnt = "1"
	remove_decals()
	update_icon()
	return TRUE

/turf/simulated/floor/why_cannot_build_cable(var/mob/user, var/cable_error)
	switch(cable_error)
		if(0)
			return
		if(1)
			to_chat(user, SPAN_WARNING("Removing the tiling first."))
		if(2)
			to_chat(user, SPAN_WARNING("This section is too damaged to support anything. Use a welder to fix the damage."))
		else //Fallback
			. = ..()

/turf/simulated/floor/cannot_build_cable()
	if(broken || burnt)
		return 2
	if(!is_plating())
		return 1
