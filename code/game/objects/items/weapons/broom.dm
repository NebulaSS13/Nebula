/obj/item/staff/broom
	name = "broom"
	desc = "Used for sweeping, and flying into the night while cackling. Black cat not included."
	icon = 'icons/obj/items/broom.dmi'
	matter = list(/decl/material/solid/organic/cloth = MATTER_AMOUNT_SECONDARY)
	var/bristle_material = /decl/material/solid/organic/plantmatter/grass/dry

/obj/item/staff/broom/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(bristle_material)
		var/decl/material/bristle_mat = GET_DECL(bristle_material)
		to_chat(user, "\The [src]'s bristles are made from [bristle_mat.name].")

/obj/item/staff/broom/Initialize(ml, material_key, bristles_key)
	if(!isnull(bristles_key))
		bristle_material = bristles_key
	. = ..()
	if(bristle_material)
		update_icon()

/obj/item/staff/broom/on_update_icon()
	. = ..()
	if(bristle_material)
		var/bristle_state = "[icon_state]-bristles"
		if(check_state_in_icon(bristle_state, icon))
			var/decl/material/bristle_mat = GET_DECL(bristle_material)
			add_overlay(overlay_image(icon, bristle_state, bristle_mat.color, RESET_COLOR))

/obj/item/staff/broom/apply_additional_mob_overlays(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && bristle_material)
		var/bristle_state = "[overlay.icon_state]-bristles"
		if(check_state_in_icon(bristle_state, overlay.icon))
			var/decl/material/bristle_mat = GET_DECL(bristle_material)
			overlay.overlays += overlay_image(overlay.icon, bristle_state, bristle_mat.color, RESET_COLOR)
	. = ..()

/obj/item/staff/broom/can_make_broom_with(mob/user, obj/item/thing)
	return FALSE

/obj/item/staff/broom/resolve_attackby(atom/A, mob/user, click_params)

	if(user.a_intent != I_HURT)

		// Sweep up dirt.
		if(isturf(A))
			var/turf/cleaning = A
			var/dirty = cleaning.get_dirt()
			if(dirty)
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				user.visible_message(SPAN_NOTICE("\The [user] sweeps \the [A]."))
				// TODO: shff sound
				cleaning.remove_dirt(min(dirty, rand(20,30)))
			else
				to_chat(user, SPAN_WARNING("\The [cleaning] is not in need of sweeping."))
			return TRUE

		// Sweep up dry spills.
		if(istype(A, /obj/effect/decal/cleanable))
			var/obj/effect/decal/cleanable/cleaning = A
			if(cleaning.sweepable)
				user.visible_message(SPAN_NOTICE("\The [user] sweeps up \the [A]."))
				qdel(A)
			else
				to_chat(user, SPAN_WARNING("\The [cleaning] cannot be swept up."))
			return TRUE

	. = ..()
