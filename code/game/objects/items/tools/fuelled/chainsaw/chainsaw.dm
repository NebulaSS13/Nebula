/datum/composite_sound/chainsaw_idle
	start_sound = null
	mid_sounds = list('sound/weapons/chainsaw_idle.ogg')
	mid_length = 19
	end_sound = 'sound/weapons/chainsaw_turnoff.ogg'
	play_volume = 50

/datum/composite_sound/chainsaw_cutting
	start_sound = 'sound/weapons/chainsaw_saw_start.ogg'
	start_length = 11
	mid_sounds = list('sound/weapons/chainsaw_saw_mid.ogg')
	mid_length = 10
	end_sound = 'sound/weapons/chainsaw_saw_end.ogg'
	play_volume = 100

// TODO:
// - fix to saw through walls
// - fix to saw through machines (airlocks, windows)
// - sparks when sawing through metal

/obj/item/fuelled_tool/chainsaw
	name = "chainsaw"
	desc = "C'mere boys, I've got something to say!"
	icon = 'icons/obj/chainsaw.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_LARGE
	slot_flags = null

	// Null these as we use a composite sound and a manual startup sound.
	activate_sound = null
	deactivate_sound = null
	running_loop = /datum/composite_sound/chainsaw_idle

	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_ALL
	paint_color = COLOR_ORANGE
	can_be_twohanded = TRUE
	tank = /obj/item/chems/fuel_tank/large

	var/saw_time_multiplier = 1

	var/active_force   = 25
	var/inactive_force = 10

	var/attack_sound = 'sound/weapons/chainsaw_attack.ogg'
	var/datum/composite_sound/cutting_loop = /datum/composite_sound/chainsaw_cutting

	var/static/alist/destroyable_atoms = list(
		/obj/item,
		/obj/machinery,
		/obj/structure,
		/turf/wall
	)

/obj/item/fuelled_tool/chainsaw/ocp
	paint_color = COLOR_RED_GRAY
	material = /decl/material/solid/metal/plasteel/ocp

/obj/item/fuelled_tool/chainsaw/Initialize(ml, material_key)
	if(ispath(cutting_loop))
		cutting_loop = new cutting_loop(list(src), FALSE)
	. = ..()

/obj/item/fuelled_tool/chainsaw/Destroy()
	if(cutting_loop)
		QDEL_NULL(cutting_loop)
	. = ..()

/obj/item/fuelled_tool/chainsaw/apply_additional_mob_overlays(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing)
	if(overlay)
		var/run_state = overlay.icon_state
		if(running_state)
			run_state = "[run_state]-running"
			if(tank)
				var/smoke_state = "[overlay.icon_state]-smoke"
				if(check_state_in_icon(smoke_state, overlay.icon))
					overlay.overlays += overlay_image(overlay.icon, smoke_state, COLOR_WHITE, RESET_COLOR)
		run_state = "[run_state]-blade"
		if(check_state_in_icon(run_state, overlay.icon))
			overlay.overlays += overlay_image(overlay.icon, run_state, material.color, RESET_COLOR)
	. = ..()

/obj/item/fuelled_tool/chainsaw/on_update_icon()
	. = ..()
	cut_overlays()
	if(running_state)
		add_overlay(overlay_image(icon, "[icon_state]-running-blade", material.color, RESET_COLOR))
		if(tank)
			var/smoke_state = "[icon_state]-smoke"
			if(check_state_in_icon(smoke_state, icon))
				add_overlay(overlay_image(icon, smoke_state, COLOR_WHITE, RESET_COLOR))
	else
		add_overlay(overlay_image(icon, "[icon_state]-blade", material.color, RESET_COLOR))
	compile_overlays()

/obj/item/fuelled_tool/chainsaw/get_running_force()
	return tool_is_running() ? active_force : inactive_force

/obj/item/fuelled_tool/chainsaw/update_physical_damage()
	. = ..()
	if(running_state)
		hitsound = attack_sound
		sharp = TRUE
		edge  = TRUE
	else
		hitsound = initial(hitsound)
		sharp = initial(sharp)
		edge  = initial(sharp)
	update_attack_force()

// Stagger a couple of playsounds like you're trying to get the engine to turn over.
/obj/item/fuelled_tool/chainsaw/perform_activation_check(mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] begins yanking the pull cord on \the [src]."))
	playsound(src, 'sound/weapons/chainsaw_startup.ogg', 35, TRUE)
	return do_after(user, 2 SECONDS, src)

/obj/item/fuelled_tool/chainsaw/handle_afterattack(var/atom/target, var/mob/user, proximity, click_parameters)
	. = proximity && user.check_intent(I_FLAG_HARM) && can_saw_apart(user, target)
	if(.)
		saw_apart(user, target)
		return TRUE
	return ..()

/obj/item/fuelled_tool/chainsaw/resolve_attackby(atom/A, mob/user)
	if(user.check_intent(I_FLAG_HARM) && can_saw_apart(user, A))
		return FALSE
	return ..()

/obj/item/fuelled_tool/chainsaw/show_activation_message(mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] brandishes \the [src] as it snarls to life!"))

/obj/item/fuelled_tool/chainsaw/proc/can_saw_apart(mob/user, atom/target)
	if(QDELETED(src) || QDELETED(user) || QDELETED(target) || !target.simulated)
		return FALSE
	if(user.incapacitated() || !tool_is_running() || loc != user || !is_held_twohanded(user))
		return FALSE
	if(!is_type_in_list(target, destroyable_atoms))
		return FALSE
	if(!istype(material))
		return FALSE
	var/decl/material/mat = target.get_material()
	return istype(mat) && mat.hardness < material.hardness

/obj/item/fuelled_tool/chainsaw/proc/get_chainsaw_delay(mob/user, atom/target)
	// Use the start sound as minimum length because composite sounds loop forever if you try to stop them before the start sound has finished.
	. = clamp(5 SECONDS * floor(target.get_object_size() / ITEM_SIZE_STRUCTURE), ceil(/datum/composite_sound/chainsaw_cutting::start_length * 1.5), 10 SECONDS)

/obj/item/fuelled_tool/chainsaw/proc/saw_apart(mob/user, atom/target)

	if(istype(cutting_loop) && !cutting_loop.started)
		cutting_loop.start()

	// Try/catch to avoid getting stuck with an always-on cutting loop
	try
		user.visible_message(SPAN_DANGER("\The [user] begins sawing apart \the [target] with \the [src]!"))
		if(do_after(user, get_chainsaw_delay(user, target), target) && can_saw_apart(user, target))
			target.handle_chainsawed(user, src)
			user.visible_message(SPAN_DANGER("\The [user] saws through \the [target] with \the [src]!"))
	catch(var/exception/E)
		log_error("Exception during chainsaw saw_apart() proc: [EXCEPTION_TEXT(E)]")

	if(istype(cutting_loop) && cutting_loop.started)
		cutting_loop.stop()

	return TRUE
