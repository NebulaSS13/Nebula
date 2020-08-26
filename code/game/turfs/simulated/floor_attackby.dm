/turf/simulated/floor/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/hand = H.organs_by_name[H.get_active_held_item_slot()]
		if(hand && try_graffiti(H, hand))
			return TRUE
	. = ..()

/turf/simulated/floor/attackby(var/obj/item/C, var/mob/user)

	if(!C || !user)
		return 0

	if(isCoil(C) || (flooring && istype(C, /obj/item/stack/material/rods)))
		return ..(C, user)

	if(!(isScrewdriver(C) && flooring && (flooring.flags & TURF_REMOVE_SCREWDRIVER)) && try_graffiti(user, C))
		return TRUE

	if(flooring)
		if(isCrowbar(C) && user.a_intent != I_HURT)
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
		else if(isScrewdriver(C) && (flooring.flags & TURF_REMOVE_SCREWDRIVER))
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
		else if(isWrench(C) && (flooring.flags & TURF_REMOVE_WRENCH))
			if(!user.do_skilled(flooring.remove_timer, SKILL_CONSTRUCTION, src))
				return TRUE
			if(!flooring)
				return
			to_chat(user, "<span class='notice'>You unwrench and remove the [flooring.descriptor].</span>")
			make_plating(1)
			playsound(src, 'sound/items/Ratchet.ogg', 80, 1)
			return TRUE
		else if(istype(C, /obj/item/shovel) && (flooring.flags & TURF_REMOVE_SHOVEL))
			to_chat(user, "<span class='notice'>You shovel off the [flooring.descriptor].</span>")
			make_plating(1)
			playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
			return TRUE
		else if(isCoil(C))
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
				if(ispath(S.type, F.build_type) || ispath(S.build_type, F.build_type))
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
		else if(isCrowbar(C))
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
		else if(isWelder(C))
			var/obj/item/weldingtool/welder = C
			if(welder.isOn() && (is_plating()))
				if(broken || burnt)
					if(welder.remove_fuel(0, user))
						to_chat(user, "<span class='notice'>You fix some dents on the broken plating.</span>")
						playsound(src, 'sound/items/Welder.ogg', 80, 1)
						icon_state = "plating"
						burnt = null
						broken = null
						return TRUE
				else
					if(welder.remove_fuel(0, user))
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
		return 0
	burnt = 1
	remove_decals()
	update_icon()
	return 1

/turf/simulated/floor/can_build_cable(var/mob/user)
	if(!is_plating() || flooring)
		to_chat(user, "<span class='warning'>Removing the tiling first.</span>")
		return 0
	if(broken || burnt)
		to_chat(user, "<span class='warning'>This section is too damaged to support anything. Use a welder to fix the damage.</span>")
		return 0
	return 1
