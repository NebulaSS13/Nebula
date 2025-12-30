/obj/structure/heavy_vehicle_frame
	name = "exosuit frame"
	desc = "The frame for an exosuit, apparently."
	icon = 'icons/mecha/mech_parts.dmi'
	icon_state = "backbone"
	density = TRUE
	pixel_x = -8
	material = /decl/material/solid/metal/steel
	atom_flags = ATOM_FLAG_CAN_BE_PAINTED
	dir = SOUTH

	// Holders for the final product.
	var/obj/item/mech_component/manipulators/arms
	var/obj/item/mech_component/propulsion/legs
	var/obj/item/mech_component/sensors/head
	var/obj/item/mech_component/chassis/body
	var/is_wired = 0
	var/is_reinforced = 0
	var/set_name

/obj/structure/heavy_vehicle_frame/set_color(new_colour)
	var/painted_component = FALSE
	for(var/obj/item/mech_component/comp in list(body, arms, legs, head))
		if(comp.set_color(new_colour))
			painted_component = TRUE
	if(painted_component)
		queue_icon_update()

/obj/structure/heavy_vehicle_frame/Destroy()
	QDEL_NULL(arms)
	QDEL_NULL(legs)
	QDEL_NULL(head)
	QDEL_NULL(body)
	. = ..()

/obj/structure/heavy_vehicle_frame/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(!arms)
		. += SPAN_WARNING("It is missing manipulators.")
	if(!legs)
		. += SPAN_WARNING("It is missing propulsion.")
	if(!head)
		. += SPAN_WARNING("It is missing sensors.")
	if(!body)
		. += SPAN_WARNING("It is missing a chassis.")
	if(is_wired == FRAME_WIRED)
		. += SPAN_WARNING("It has not had its wiring adjusted.")
	else if(!is_wired)
		. += SPAN_WARNING("It has not yet been wired.")
	if(is_reinforced == FRAME_REINFORCED)
		. += SPAN_WARNING("It has not had its internal reinforcement secured.")
	else if(is_reinforced == FRAME_REINFORCED_SECURE)
		. += SPAN_WARNING("It has not had its internal reinforcement welded in.")
	else if(!is_reinforced)
		. += SPAN_WARNING("It does not have any internal reinforcement.")

/obj/structure/heavy_vehicle_frame/on_update_icon()
	..()
	for(var/obj/item/mech_component/comp in list(legs, head, body, arms))
		add_overlay(get_mech_image(comp.decal, comp.decal_blend, comp.icon_state, comp.on_mech_icon, comp.color, overlay_layer = FLOAT_LAYER))
	if(body)
		set_density(TRUE)
		add_overlay(get_mech_image(body.decal, body.decal_blend, "[body.icon_state]_cockpit", body.icon, body.color))
		if(body.pilot_coverage < 100 || body.transparent_cabin)
			add_overlay(get_mech_image(body.decal, body.decal_blend, "[body.icon_state]_open_overlay", body.icon, body.color))
	else
		set_density(FALSE)
	if(density != opacity)
		set_opacity(density)

/obj/structure/heavy_vehicle_frame/set_dir()
	return ..(SOUTH)

/obj/structure/heavy_vehicle_frame/attackby(var/obj/item/used_item, var/mob/user)
	// Removing components.
	if(IS_CROWBAR(used_item))
		if(is_reinforced == FRAME_REINFORCED)
			if(!user.do_skilled(0.5 SECONDS, SKILL_DEVICES, src) || !material)
				return TRUE
			user.visible_message(SPAN_NOTICE("\The [user] crowbars the reinforcement off \the [src]."))
			material.create_object(src.loc, 10)
			material = null
			is_reinforced = 0
			return TRUE

		var/to_remove = input("Which component would you like to remove") as null|anything in list(arms, body, legs, head)

		if(!to_remove)
			to_chat(user, SPAN_WARNING("There are no components to remove."))
			return TRUE

		if(uninstall_component(to_remove, user))
			if(to_remove == arms)
				arms = null
			else if(to_remove == body)
				body = null
			else if(to_remove == legs)
				legs = null
			else if(to_remove == head)
				head = null

		update_icon()
		return TRUE

	// Final construction step.
	else if(IS_SCREWDRIVER(used_item))

		// Check for basic components.
		if(!(arms && legs && head && body))
			to_chat(user,  SPAN_WARNING("There are still parts missing from \the [src]."))
			return TRUE

		// Check for wiring.
		if(is_wired < FRAME_WIRED_ADJUSTED)
			if(is_wired == FRAME_WIRED)
				to_chat(user, SPAN_WARNING("\The [src]'s wiring has not been adjusted!"))
			else
				to_chat(user, SPAN_WARNING("\The [src] is not wired!"))
			return TRUE

		// Check for basing metal internal plating.
		if(is_reinforced < FRAME_REINFORCED_WELDED)
			if(is_reinforced == FRAME_REINFORCED)
				to_chat(user, SPAN_WARNING("\The [src]'s internal reinforcement has not been secured!"))
			else if(is_reinforced == FRAME_REINFORCED_SECURE)
				to_chat(user, SPAN_WARNING("\The [src]'s internal reinforcement has not been welded down!"))
			else
				to_chat(user, SPAN_WARNING("\The [src] has no internal reinforcement!"))
			return TRUE

		visible_message(SPAN_NOTICE("\The [user] begins tightening screws, flipping connectors and finishing off \the [src]."))
		if(!user.do_skilled(50, SKILL_DEVICES, src))
			return TRUE

		if(is_reinforced < FRAME_REINFORCED_WELDED || is_wired < FRAME_WIRED_ADJUSTED || !(arms && legs && head && body) || QDELETED(src) || QDELETED(user))
			return TRUE

		// We're all done. Finalize the exosuit and pass the frame to the new system.
		var/mob/living/exosuit/M = new(get_turf(src), src)
		visible_message(SPAN_NOTICE("\The [user] finishes off \the [M]."))
		playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)

		arms = null
		legs = null
		head = null
		body = null
		qdel(src)

		return TRUE

	// Installing wiring.
	else if(IS_COIL(used_item))

		if(is_wired)
			to_chat(user, SPAN_WARNING("\The [src] has already been wired."))
			return TRUE

		var/obj/item/stack/cable_coil/CC = used_item
		if(CC.get_amount() < 10)
			to_chat(user, SPAN_WARNING("You need at least ten units of cable to complete the exosuit."))
			return TRUE

		user.visible_message("\The [user] begins wiring \the [src]...")

		if(!user.do_skilled(3 SECONDS, SKILL_ELECTRICAL, src))
			return TRUE

		if(!CC || !user || !src || CC.get_amount() < 10 || is_wired)
			return TRUE

		CC.use(10)
		user.visible_message("\The [user] installs wiring in \the [src].")
		playsound(user.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		is_wired = FRAME_WIRED
	// Securing wiring.
	else if(IS_WIRECUTTER(used_item))
		if(!is_wired)
			to_chat(user, "There is no wiring in \the [src] to neaten.")
			return TRUE

		user.visible_message("\The [user] begins adjusting the wiring inside \the [src]...")
		var/last_wiring_state = is_wired
		if(!user.do_skilled(3 SECONDS, SKILL_ELECTRICAL, src) || last_wiring_state != is_wired)
			return TRUE

		visible_message("\The [user] [(is_wired == FRAME_WIRED_ADJUSTED) ? "snips some of" : "neatens"] the wiring in \the [src].")
		playsound(user.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		is_wired = (is_wired == FRAME_WIRED_ADJUSTED) ? FRAME_WIRED : FRAME_WIRED_ADJUSTED
	// Installing metal.
	else if(istype(used_item, /obj/item/stack/material))
		var/obj/item/stack/material/M = used_item
		if(M.material)
			if(is_reinforced)
				to_chat(user, SPAN_WARNING("There is already a material reinforcement installed in \the [src]."))
				return TRUE
			if(M.get_amount() < 10)
				to_chat(user, SPAN_WARNING("You need at least ten sheets to reinforce \the [src]."))
				return TRUE

			visible_message("\The [user] begins layering the interior of \the [src] with \the [M].")

			if(!user.do_skilled(3 SECONDS, SKILL_DEVICES, src) || is_reinforced)
				return TRUE

			visible_message("\The [user] reinforces \the [src] with \the [M].")
			playsound(user.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			material = M.material
			is_reinforced = FRAME_REINFORCED
			M.use(10)
		else
			return ..()
	// Securing metal.
	else if(IS_WRENCH(used_item))
		if(!is_reinforced)
			to_chat(user, SPAN_WARNING("There is no metal to secure inside \the [src]."))
			return TRUE
		if(is_reinforced == FRAME_REINFORCED_WELDED)
			to_chat(user, SPAN_WARNING("\The [src]'s internal reinforcment has been welded in."))
			return TRUE

		var/last_reinforced_state = is_reinforced
		visible_message("\The [user] begins adjusting the metal reinforcement inside \the [src].")

		if(!user.do_skilled(4 SECONDS, SKILL_DEVICES,src) || last_reinforced_state != is_reinforced)
			return TRUE

		visible_message("\The [user] [(is_reinforced == 2) ? "unsecures" : "secures"] the metal reinforcement inside \the [src].")
		playsound(user.loc, 'sound/items/Ratchet.ogg', 100, 1)
		is_reinforced = (is_reinforced == FRAME_REINFORCED_SECURE) ? FRAME_REINFORCED : FRAME_REINFORCED_SECURE
	// Welding metal.
	else if(IS_WELDER(used_item))
		var/obj/item/weldingtool/welder = used_item
		if(!is_reinforced)
			to_chat(user, SPAN_WARNING("There is no metal to secure inside \the [src]."))
			return TRUE
		if(is_reinforced == FRAME_REINFORCED)
			to_chat(user, SPAN_WARNING("The reinforcement inside \the [src] has not been secured."))
			return TRUE
		if(!welder.isOn())
			to_chat(user, SPAN_WARNING("Turn \the [welder] on, first."))
			return TRUE
		if(welder.weld(1, user))

			var/last_reinforced_state = is_reinforced
			visible_message("\The [user] begins welding the metal reinforcement inside \the [src].")
			if(!user.do_skilled(2 SECONDS, SKILL_DEVICES, src) || last_reinforced_state != is_reinforced)
				return TRUE

			visible_message("\The [user] [(is_reinforced == FRAME_REINFORCED_WELDED) ? "unwelds the reinforcement from" : "welds the reinforcement into"] \the [src].")
			is_reinforced = (is_reinforced == FRAME_REINFORCED_WELDED) ? FRAME_REINFORCED_SECURE : FRAME_REINFORCED_WELDED
			playsound(user.loc, 'sound/items/Welder.ogg', 50, 1)
		else
			to_chat(user, SPAN_WARNING("Not enough fuel!"))
			return TRUE
	// Installing basic components.
	else if(istype(used_item,/obj/item/mech_component/manipulators))
		if(arms)
			to_chat(user, SPAN_WARNING("\The [src] already has manipulators installed."))
			return TRUE
		if(install_component(used_item, user))
			if(arms)
				used_item.dropInto(loc)
				return TRUE
			arms = used_item
	else if(istype(used_item,/obj/item/mech_component/propulsion))
		if(legs)
			to_chat(user, SPAN_WARNING("\The [src] already has a propulsion system installed."))
			return TRUE
		if(install_component(used_item, user))
			if(legs)
				used_item.dropInto(loc)
				return TRUE
			legs = used_item
	else if(istype(used_item,/obj/item/mech_component/sensors))
		if(head)
			to_chat(user, SPAN_WARNING("\The [src] already has a sensor array installed."))
			return TRUE
		if(install_component(used_item, user))
			if(head)
				used_item.dropInto(loc)
				return TRUE
			head = used_item
	else if(istype(used_item,/obj/item/mech_component/chassis))
		if(body)
			to_chat(user, SPAN_WARNING("\The [src] already has an outer chassis installed."))
			return TRUE
		if(install_component(used_item, user))
			if(body)
				used_item.dropInto(loc)
				return TRUE
			body = used_item
	else
		return ..()
	update_icon()
	return TRUE

/obj/structure/heavy_vehicle_frame/proc/install_component(var/obj/item/thing, var/mob/user)
	var/obj/item/mech_component/component = thing
	if(istype(component) && !component.ready_to_install())
		var/decl/pronouns/component_pronouns = component.get_pronouns()
		to_chat(user, SPAN_WARNING("\The [component] [component_pronouns.is] not ready to install."))
		return 0
	if(user)
		visible_message(SPAN_NOTICE("\The [user] begins installing \the [thing] into \the [src]."))
		if(!user.can_unequip_item(thing) || !user.do_skilled(3 SECONDS, SKILL_DEVICES, src) || user.get_active_held_item() != thing)
			return
		if(!user.try_unequip(thing))
			return
	thing.forceMove(src)
	visible_message(SPAN_NOTICE("\The [user] installs \the [thing] into \the [src]."))
	playsound(user.loc, 'sound/machines/click.ogg', 50, 1)
	return 1

/obj/structure/heavy_vehicle_frame/proc/uninstall_component(var/obj/item/component, var/mob/user)
	if(!istype(component) || (component.loc != src) || !istype(user))
		return FALSE
	if(!user.do_skilled(4 SECONDS, SKILL_DEVICES, src) || component.loc != src)
		return FALSE
	user.visible_message(SPAN_NOTICE("\The [user] crowbars \the [component] off \the [src]."))
	component.forceMove(get_turf(src))
	user.put_in_hands(component)
	playsound(user.loc, 'sound/items/Deconstruct.ogg', 50, 1)
	return TRUE