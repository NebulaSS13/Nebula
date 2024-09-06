/obj/structure/town_bell
	name                = "town bell"
	desc                = "A heavy bell on a strong brace. It looks loud enough to reach the entire surrounding area."
	icon                = 'icons/obj/structures/town_bell.dmi'
	icon_state          = ICON_STATE_WORLD
	anchored            = TRUE
	opacity             = FALSE
	density             = TRUE
	material            = /decl/material/solid/organic/wood/walnut
	color               = /decl/material/solid/organic/wood/walnut::color
	material_alteration = MAT_FLAG_ALTERATION_COLOR

	var/near_sound      = 'sound/effects/bell_near.ogg'
	var/far_sound       = 'sound/effects/bell_far.ogg'
	var/next_ring       = 0
	var/ring_cooldown   = 1 MINUTE
	var/decl/material/bell_material = /decl/material/solid/metal/bronze

/obj/structure/town_bell/Initialize(mapload)
	if(bell_material)
		LAZYSET(matter, bell_material, MATTER_AMOUNT_REINFORCEMENT)
	. = ..()
	update_icon()

/obj/structure/town_bell/update_material_desc(override_desc)
	. = ..()
	if(material && bell_material)
		var/decl/material/bell_mat_decl = GET_DECL(bell_material)
		desc += " The frame is made of [material.solid_name] and the bell has been cast from [bell_mat_decl.solid_name]."

/obj/structure/town_bell/on_update_icon()
	. = ..()
	if(bell_material)
		var/bell_state = "[icon_state]-bell"
		if(world.time < next_ring)
			bell_state = "[bell_state]-ringing"
		if(check_state_in_icon(bell_state, icon))
			add_overlay(overlay_image(icon, bell_state, bell_material::color, RESET_COLOR))

/obj/structure/town_bell/proc/can_be_rung(mob/user)
	if(!isturf(loc) || !z)
		return FALSE
	if(world.time < next_ring)
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] cannot be rung again so soon."))
		return FALSE
	return TRUE

/obj/structure/town_bell/attackby(obj/item/used_item, mob/user)
	. = ..()
	if(used_item.get_attack_force())
		ding_dong()

/obj/structure/town_bell/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	if(!can_be_rung(user))
		return TRUE
	var/choice = alert(user, "Are you sure you wish to ring \the [src]? The entire region will be notified.", "Ring Bell", "No", "Yes")
	if(QDELETED(src) || QDELETED(user) || choice != "Yes" || !user.Adjacent(src) || !can_be_rung(user))
		return TRUE
	visible_message(SPAN_NOTICE("\The [user] rings \the [src], sending its sonorous tones rolling across the region."))
	ding_dong()
	return TRUE

/obj/structure/town_bell/proc/play_near_sound()
	set waitfor = FALSE
	playsound(loc, near_sound, 80, 0)
	sleep(3 SECONDS)
	if(QDELETED(src) || !isturf(loc))
		return
	playsound(loc, near_sound, 80, 0)
	sleep(3 SECONDS)
	if(QDELETED(src) || !isturf(loc))
		return
	playsound(loc, near_sound, 80, 0)

/obj/structure/town_bell/proc/play_far_sound(mob/listener)
	set waitfor = FALSE
	listener.playsound_local(loc, far_sound, 100)
	sleep(3 SECONDS)
	if(QDELETED(src) || QDELETED(listener) || !isturf(loc))
		return
	listener.playsound_local(loc, far_sound, 100)
	sleep(3 SECONDS)
	if(QDELETED(src) || QDELETED(listener) || !isturf(loc))
		return
	listener.playsound_local(loc, far_sound, 100)

/obj/structure/town_bell/proc/ding_dong()
	if(!can_be_rung())
		return
	next_ring = world.time + ring_cooldown
	update_icon()
	play_near_sound()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, queue_icon_update)), ring_cooldown)
	var/list/affected_zs = SSmapping.get_connected_levels(z)
	for(var/client/player)
		var/turf/player_turf = get_turf(player.mob)
		if(!istype(player_turf) || !(player_turf.z in affected_zs) || player.mob.is_deaf())
			continue
		if(src in view(player.mob, world.view))
			continue
		play_far_sound(player.mob)
		to_chat(player, SPAN_NOTICE("<b><font size=3>You hear the sonorous ringing of the town bell coming from \the [get_dir_z_text(player_turf, loc)].</font></b>"))
