#define FISHING_FAILED_SILENT  0
#define FISHING_FAILED_WARNING 1
#define FISHING_POSSIBLE       2

/obj/item/fishing_rod
	name = "fishing rod"
	desc = "A simple fishing rod with eyelets for stringing a line."
	material = /decl/material/solid/organic/wood
	matter = null
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	icon = 'icons/obj/fishing_rod.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_LARGE

	var/const/base_fishing_time = 25 SECONDS
	var/is_fishing = FALSE
	var/obj/item/bait
	var/obj/item/fishing_line/line
	var/line_integrity
	// Reduces fishing time by 20%.
	var/fishing_rod_quality = 0.1

/obj/item/fishing_rod/Initialize()
	if(line)
		if(ispath(line))
			line = new line(src)
		if(!istype(line))
			line = null
	. = ..()
	update_icon()

/obj/item/fishing_rod/on_update_icon()

	..()

	if(line)
		var/image/I = image(icon, "[icon_state]-line")
		I.appearance_flags |= RESET_COLOR | RESET_ALPHA
		I.color = line.color
		add_overlay(I)

	if(bait)
		var/image/I = image(icon, "[icon_state]-bait")
		I.appearance_flags |= RESET_COLOR | RESET_ALPHA
		I.color = bait.color
		add_overlay(I)

	if(ismob(loc))
		var/mob/M = loc
		M.update_inhand_overlays()

/obj/item/fishing_rod/Destroy()
	QDEL_NULL(bait)
	QDEL_NULL(line)
	return ..()

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

		if(line && check_state_in_icon("[overlay.icon_state]-line", overlay.icon))
			var/image/I = image(overlay.icon, "[overlay.icon_state]-line")
			I.appearance_flags |= RESET_COLOR | RESET_ALPHA
			I.color = line.color
			overlay.overlays += I

		if(bait && check_state_in_icon("[overlay.icon_state]-bait", overlay.icon))
			var/image/I = image(overlay.icon, "[overlay.icon_state]-bait")
			I.appearance_flags |= RESET_COLOR | RESET_ALPHA
			I.color = bait.color
			overlay.overlays += I

	. = ..()

/obj/item/fishing_rod/attack(mob/living/M, mob/living/user)
	return user.a_intent != I_HURT ? FALSE : ..()

/obj/item/fishing_rod/proc/can_fish_in(mob/user, atom/target)
	if(!isturf(target))
		return FISHING_FAILED_SILENT
	if(!target.submerged())
		to_chat(user, SPAN_WARNING("The water is not deep enough to fish there."))
		return FISHING_FAILED_WARNING
	return FISHING_POSSIBLE

/obj/item/fishing_rod/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(is_fishing)
		to_chat(user, SPAN_WARNING("You are already fishing with \the [src]!"))
		return
	if(!line)
		to_chat(user, SPAN_WARNING("\The [src] has no line!"))
		return
	var/fish_check = can_fish_in(user, target)
	if(fish_check == FISHING_FAILED_SILENT)
		// TODO: throw the hook at them without doing the fishing minigame.
		return ..()
	if(fish_check == FISHING_FAILED_WARNING)
		return
	is_fishing = TRUE
	do_fishing_minigame(user, target)
	is_fishing = FALSE

/obj/item/fishing_rod/proc/get_fishing_delay(mob/user)
	var/speed_mult = fishing_rod_quality + (bait?.get_bait_value() || 0)
	return clamp(base_fishing_time - (base_fishing_time * speed_mult), 1, base_fishing_time * 2)

// TODO: more interesting fishing minigame.
/obj/item/fishing_rod/proc/do_fishing_minigame(mob/user, turf/target)
	user.visible_message(SPAN_NOTICE("\The [user] casts \the [src] into \the [target]."))
	playsound(target, 'sound/effects/slosh.ogg', 25, 1)
	target.show_bubbles()
	if(do_after(user, get_fishing_delay(user), target))
		playsound(target, 'sound/effects/slosh.ogg', 25, 1)
		target.show_bubbles()
		var/atom/movable/result = target.get_fishing_result(bait)
		if(ismob(result) || isitem(result) || istype(result, /obj/structure) || istype(result, /obj/machinery))
			to_chat(user, SPAN_NOTICE("You catch \a [result]!"))
			if(ismob(result))
				QDEL_NULL(bait)
			line.take_damage(round(result.get_object_size() * rand(0.5, 1.5)))
			if(QDELETED(line))
				to_chat(user, SPAN_DANGER("Your fishing line snaps!"))
				line = null
			update_icon()
		else
			// A non-item, non-mob result is probably an /obj/effect from a random
			// spawner. "You catch a spiderling remains!" is pretty silly.
			if(isatom(result))
				qdel(result)
			to_chat(user, SPAN_NOTICE("You catch... nothing."))
		return TRUE
	to_chat(user, SPAN_WARNING("You reel your line back in and abandon trying to fish in \the [target]."))
	return FALSE

/obj/item/fishing_rod/attack_self(mob/user)

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

/obj/item/fishing_rod/proc/load_line(mob/user, obj/item/fishing_line/new_line)

	var/static/list/valid_line_types = list(
		/obj/item/stack/cable_coil,
		/obj/item/stack/net_cable_coil,
		/obj/item/stack/material/bundle
	)

	if(!istype(new_line) && !is_type_in_list(new_line, valid_line_types))
		return FALSE

	if(!new_line?.material?.tensile_strength)
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
