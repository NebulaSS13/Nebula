#define FISHING_FAILED_SILENT  0
#define FISHING_FAILED_WARNING 1
#define FISHING_POSSIBLE       2

// Abstract item for pulling the minigame delay and interaction out of afterattack at some point.
/obj/abstract/fishing_marker
	is_spawnable_type = FALSE
	var/turf/target
	var/mob/user
	var/obj/item/fishing_rod/rod
	// Atom-typed so we can use initial().
	var/atom/hooked

/obj/abstract/fishing_marker/Destroy()
	if(rod?.is_fishing == src)
		rod.is_fishing = null

	target = null
	user   = null
	hooked = null
	rod    = null
	return ..()

/obj/abstract/fishing_marker/Initialize(ml, mob/_user, obj/item/fishing_rod/_rod)

	. = ..(ml)

	rod    = _rod
	user   = _user
	target = get_turf(src)

	if(!istype(rod) || !istype(user) || !istype(target))
		return INITIALIZE_HINT_QDEL

	user.visible_message(SPAN_NOTICE("\The [user] casts \the [rod] into \the [target.get_fluid_name()]."))
	playsound(target, 'sound/effects/watersplash.ogg', 25, 1)
	target.show_bubbles()
	addtimer(CALLBACK(src, PROC_REF(notify_catch)), rod.get_fishing_delay(user, target))
	return INITIALIZE_HINT_NORMAL

/obj/abstract/fishing_marker/proc/notify_catch()

	if(QDELETED(src))
		return

	if(QDELETED(target) || QDELETED(user) || QDELETED(rod))
		qdel(src)
		return

	hooked = target.get_fishing_result(rod.bait) || FALSE
	to_chat(user, SPAN_NOTICE("You feel a tug on \the [rod]!"))
	target.show_bubbles()
	playsound(target, 'sound/effects/bubbles3.ogg', 50, 1)
	addtimer(CALLBACK(src, PROC_REF(lose_catch), hooked), 3 SECONDS)

/obj/abstract/fishing_marker/proc/lose_catch(old_hooked)

	if(QDELETED(src))
		return

	if(QDELETED(target) || QDELETED(user) || QDELETED(rod) || hooked != old_hooked)
		qdel(src)
		return

	hooked = null
	to_chat(user, SPAN_NOTICE("\The [rod]'s line goes slack..."))
	playsound(target, 'sound/effects/slosh.ogg', 25, 1)
	addtimer(CALLBACK(src, PROC_REF(notify_catch)), rod.get_fishing_delay(user, target))

// TODO: more interesting fishing minigame.
/obj/abstract/fishing_marker/proc/catch_fish()

	if(QDELETED(src))
		return

	if(QDELETED(target) || QDELETED(user) || QDELETED(rod))
		qdel(src)
		return

	if(istype(rod) && istype(user) && istype(target) && user.get_active_held_item() == rod && rod.is_fishing == src)

		if(!ispath(hooked) || ispath(hooked, /obj/effect) || ispath(hooked, /obj/abstract) || !initial(hooked.simulated))
			to_chat(user, SPAN_NOTICE("You catch... nothing."))

		else

			var/atom/movable/result = new hooked(target)
			to_chat(user, SPAN_NOTICE("You catch \a [result]!"))
			if(ismob(result))
				var/mob/feesh = result
				SET_STATUS_MAX(feesh, STAT_STUN, 3)
				QDEL_NULL(rod.bait)

			rod.line.take_damage(round(result.get_object_size() * rand(0.5, 1.5)))
			if(QDELETED(rod.line))
				to_chat(user, SPAN_DANGER("Your fishing line snaps!"))
				rod.line = null
				rod.update_icon()

			var/turf/result_turf = get_step(get_turf(user), get_dir(user, result))
			if(result_turf && get_turf(result) != result_turf)
				result.throw_at(result_turf, get_dist(rod, result), 0.5, user, FALSE)

		playsound(target, 'sound/effects/slosh.ogg', 25, 1)

	if(!QDELETED(src))
		qdel(src)

/obj/item/fishing_rod
	name = "fishing rod"
	desc = "A simple fishing rod with eyelets for stringing a line."
	material = /decl/material/solid/organic/wood
	matter = null
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	icon = 'icons/obj/fishing_rod.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_LARGE
	force = 5 // bonk

	var/const/base_fishing_time = 25 SECONDS
	var/obj/abstract/fishing_marker/is_fishing
	var/obj/item/bait
	var/obj/item/fishing_line/line
	var/fishing_rod_quality = 0.1

/obj/item/fishing_rod/Initialize()
	if(line)
		if(ispath(line))
			line = new line(src)
		if(!istype(line))
			line = null
	. = ..()
	update_icon()

/obj/item/fishing_rod/Destroy()
	QDEL_NULL(is_fishing)
	QDEL_NULL(bait)
	QDEL_NULL(line)
	return ..()

/obj/item/fishing_rod/on_update_icon()
	..()
	if(line)
		add_overlay(overlay_image(icon, "[icon_state]-line", line.color, RESET_COLOR | RESET_ALPHA))
	if(bait)
		add_overlay(overlay_image(icon, "[icon_state]-bait", bait.color, RESET_COLOR | RESET_ALPHA))
	if(ismob(loc))
		var/mob/M = loc
		M.update_inhand_overlays()

/obj/item/fishing_rod/physically_destroyed()
	if(bait)
		bait.dropInto(loc)
		bait = null
	if(line)
		line.dropInto(loc)
		line = null
	return ..()

/obj/item/fishing_rod/examine(mob/user, distance)
	. = ..()
	if(user && distance <= 1)
		if(line)
			to_chat(user, "\The [src] has been strung with some [get_line_damage()] [line.name].")
		if(bait)
			to_chat(user, "\The [src] has been baited with \a [bait].")

/obj/item/fishing_rod/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_offset = FALSE)
	if(overlay)
		if(line)
			overlay.overlays += overlay_image(overlay.icon, "[overlay.icon_state]-line", line.color, RESET_COLOR | RESET_ALPHA)
		if(bait)
			overlay.overlays += overlay_image(overlay.icon, "[overlay.icon_state]-bait", bait.color, RESET_COLOR | RESET_ALPHA)
	. = ..()

/obj/item/fishing_rod/attack(mob/living/M, mob/living/user)
	return user.a_intent != I_HURT ? FALSE : ..()

/obj/item/fishing_rod/proc/can_fish_in(mob/user, atom/target)
	if(!isturf(target))
		return FISHING_FAILED_SILENT
	if(!target.submerged())
		to_chat(user, SPAN_WARNING("The water is not deep enough to fish there."))
		return FISHING_FAILED_WARNING
	var/list/hit = check_trajectory(target, src, pass_flags=PASS_FLAG_TABLE, lifespan = get_dist(target, src))
	if(length(hit))
		to_chat(user, SPAN_WARNING("Your fishing line is blocked from reaching \the [target] by \the [hit[1]]."))
		return FISHING_FAILED_WARNING
	return FISHING_POSSIBLE

/obj/item/fishing_rod/afterattack(atom/target, mob/user, proximity_flag, click_parameters)

	if(user.a_intent == I_HURT)
		return ..()

	if(is_fishing)
		to_chat(user, SPAN_WARNING("You are already fishing with \the [src]!"))
		return

	if(!line)
		to_chat(user, SPAN_WARNING("\The [src] has no line!"))
		return

	if(get_dist(user, target) > 5)
		to_chat(user, SPAN_WARNING("\The [target] is too far away!"))
		return

	var/fish_check = can_fish_in(user, target)
	if(fish_check == FISHING_FAILED_SILENT)
		// TODO: throw the hook at them without doing the fishing minigame.
		return ..()

	if(fish_check == FISHING_FAILED_WARNING)
		return

	is_fishing = new(get_turf(target), user, src)

/obj/item/fishing_rod/proc/get_fishing_delay(mob/user, turf/target)
	var/speed_mult = fishing_rod_quality + (bait?.get_bait_value() || 0)
	return clamp(base_fishing_time - (base_fishing_time * speed_mult), 1, base_fishing_time * 2)

/obj/item/fishing_rod/attack_self(mob/user)

	if(is_fishing)
		if(isnull(is_fishing.hooked))
			to_chat(user, SPAN_NOTICE("You reel your line back in and abandon fishing in \the [is_fishing.target]."))
			QDEL_NULL(is_fishing)
		else
			// This is where the proper fishing minigame should go (when it exists).
			is_fishing.catch_fish()
		return TRUE

	if(bait)
		bait.dropInto(loc)
		user.put_in_hands(bait)
		to_chat(user, SPAN_NOTICE("You remove \the [bait] from \the [src]'s hook."))
		bait = null
		update_icon()
		return TRUE

	if(line)
		remove_line(user)
		return TRUE

	return ..()

/obj/item/fishing_rod/attackby(obj/item/W, mob/user)

	if(load_line(user, W))
		return TRUE

	if(istype(W, /obj/item/chems/food))

		if(bait)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [bait] on the hook."))
			return TRUE

		if(!line)
			to_chat(user, SPAN_WARNING("\The [src] needs a line before you can bait it."))
			return TRUE

		if(user.try_unequip(W, src))
			bait = W
			to_chat(user, SPAN_NOTICE("You thread \the [W] onto \the [src]'s hook."))
			update_icon()

		return TRUE

	return ..()

/obj/item/fishing_rod/proc/get_line_damage()
	var/line_health = line.get_health_ratio()
	if(line_health >= 1)
		return "pristine"
	if(line_health >= 0.65)
		return "flimsy-looking"
	if(line_health >= 0.35)
		return "rather worn"
	return "badly worn"

/obj/item/fishing_rod/proc/remove_line(mob/user)
	if(!line)
		return FALSE
	line.dropInto(loc)
	if(user)
		user.put_in_hands(line)
		to_chat(user, SPAN_NOTICE("You remove \the [line] from \the [src]."))
	line = null
	if(bait)
		bait.dropInto(loc)
		bait = null
	update_icon()
	return TRUE

/obj/item/fishing_rod/proc/load_line(mob/user, obj/item/new_line)

	var/static/list/valid_line_types = list(
		/obj/item/fishing_line,
		/obj/item/stack/cable_coil,
		/obj/item/stack/net_cable_coil,
		/obj/item/stack/material/bundle
	)

	if(!new_line || !is_type_in_list(new_line, valid_line_types))
		return FALSE

	if(!new_line.material?.tensile_strength)
		to_chat(user, SPAN_WARNING("\The [new_line] isn't suitable for the rigors of fishing."))
		return TRUE

	if(line)
		to_chat(user, SPAN_WARNING("\The [src] already has a line."))
		return TRUE

	if(istype(new_line, /obj/item/stack))
		var/obj/item/stack/cable = new_line
		if(cable.get_amount() < 5)
			to_chat(user, SPAN_WARNING("You need at least 5 [cable.plural_name] to string \the [src]."))
			return TRUE

	if(user)
		to_chat(user, SPAN_NOTICE("You begin threading \the [new_line] onto \the [src]."))
		if(!do_after(user, 3 SECONDS, src, check_holding = TRUE) || line || QDELETED(new_line))
			return TRUE

	if(istype(new_line, /obj/item/stack))
		var/obj/item/stack/cable = new_line
		var/cable_mat = cable.material?.type
		if(!cable.use(5))
			return TRUE
		new_line = new /obj/item/fishing_line(src, cable_mat)

	if(!user || user.try_unequip(new_line))
		new_line.forceMove(src)
		line = new_line
		update_icon()
		user.visible_message(SPAN_NOTICE("\The [user] strings \the [src] with \the [line]."))

	return TRUE

#undef FISHING_FAILED_SILENT
#undef FISHING_FAILED_WARNING
#undef FISHING_POSSIBLE

// Subtypes below.
/obj/item/fishing_rod/advanced
	name = "advanced fishing rod"
	desc = "It's a fishing rod, an enhanced fiberglass Telescope Ultralight 47; the latest model."
	material = /decl/material/solid/fiberglass
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT
	)
	icon = 'icons/obj/fishing_rod_advanced.dmi'
	material_alteration = MAT_FLAG_ALTERATION_COLOR
	fishing_rod_quality = 0.2
	line = /obj/item/fishing_line/high_quality
