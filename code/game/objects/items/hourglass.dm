// I considered just putting this in the fantasy modpack, but
// it's probably better in core code, since it's a nice prop.
/obj/item/hourglass
	name = "hourglass"
	icon = 'icons/obj/items/hourglass.dmi'
	icon_state = "world-preview"
	desc = "Sand trickles from one fused dome to another, tracking the inevitable passage of time. What are you doing with your life?"
	w_class = ITEM_SIZE_SMALL
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_COLOR
	material = /decl/material/solid/organic/wood/mahogany
	max_health = null // autoset from material, let it be destroyed!
	// These two variables cannot be null, currently. If you want to allow that, you need to change a lot of the code.
	var/decl/material/glass_material = /decl/material/solid/glass
	var/decl/material/sand_material = /decl/material/solid/sand
	/// The world.time at which the hourglass was last flipped. Used to determine if sand is currently falling.
	var/last_flipped = null
	/// How long in deciseconds does it take for the sand to finish falling?
	var/sand_duration = 1 MINUTE // TODO: Make this based off of matter somehow, instead of vice versa? This means damaging it and leaking sand would make it run fast...
	/// The number of falling sand states to use, [0, X) (including 0 but excluding X).
	var/sand_falling_states = 4
	/// This is an internal variable used to prevent unnecessary update_icon calls.
	var/tmp/last_sand_state = null

/obj/item/hourglass/Initialize(ml, material_key, glass_material_key, sand_material_key)
	if(!isnull(glass_material_key))
		glass_material = glass_material_key
	if(ispath(glass_material))
		glass_material = GET_DECL(glass_material)
	if(!isnull(sand_material_key))
		sand_material = sand_material_key
	if(ispath(sand_material))
		sand_material = GET_DECL(sand_material)
	last_flipped = -sand_duration
	. = ..() // Materials should be set when going into create_matter
	update_icon()

/obj/item/hourglass/create_matter()
	var/sand_matter = sand_duration / (1 MINUTE) * MATTER_AMOUNT_TRACE // Shorter duration, less sand; higher duration, more sand.
	LAZYSET(matter, sand_material.type, sand_matter)
	LAZYSET(matter, glass_material.type, MATTER_AMOUNT_REINFORCEMENT)
	return ..() // Parent call has to go last so we apply size modifiers properly.

/obj/item/hourglass/proc/sand_is_falling()
	return (world.time - last_flipped) < sand_duration

/obj/item/hourglass/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 2)
		var/sand_string = "not falling"
		switch(clamp(world.time - last_flipped, 0, sand_duration) / sand_duration)
			if(0)
				sand_string = "not falling"
			if(0 to 0.25)
				sand_string = "almost done falling"
			if(0.25 to 0.4)
				sand_string = "over halfway done falling"
			if(0.4 to 0.6)
				sand_string = "about halfway done falling"
			if(0.6 to 0.75)
				sand_string = "almost halfway done falling"
			if(0.75 to 1)
				sand_string = "just starting to fall"
		. += SPAN_NOTICE("The [sand_material.solid_name] in \the [src] is [sand_string].")

/obj/item/hourglass/proc/get_sand_state(world_inventory_state)
	/// This is a fraction of the sand_duration.
	var/sand_progress = (world.time - last_flipped) / sand_duration
	switch(sand_progress)
		if(0 to 1)
			return "sand-falling[floor(sand_progress * sand_falling_states)]-[world_inventory_state]" // 0 to sand_falling_states exclusive.
		else
			return "sand-[world_inventory_state]"

/obj/item/hourglass/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	last_sand_state = get_sand_state(icon_state)
	// Sand goes before glass
	add_overlay(overlay_image(icon, last_sand_state, sand_material.color, RESET_ALPHA|RESET_COLOR))
	// Glass goes over the sand
	add_overlay(overlay_image(icon, "glass-[icon_state]", glass_material.color, RESET_ALPHA|RESET_COLOR))
	compile_overlays() // Don't wait for SSoverlays, this is pretty time-sensitive.

/obj/item/hourglass/apply_additional_mob_overlays(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing)
	// TODO: held item falling sand states?
	overlay.add_overlay(overlay_image(overlay.icon, "sand-[overlay.icon_state]", sand_material.color, RESET_ALPHA | RESET_COLOR))
	overlay.add_overlay(overlay_image(overlay.icon, "glass-[overlay.icon_state]", glass_material.color, RESET_ALPHA | RESET_COLOR))
	return ..()

/obj/item/hourglass/attack_self(mob/user)
	. = ..()
	if(.) // Already did something like squash it or empty storage.
		return
	return flip_hourglass(user)

/obj/item/hourglass/proc/flip_hourglass(mob/user)
	if(user)
		// You can't see or hear this from very far.
		user.visible_message("<b>\The [user]</b> flips \the [src].", SPAN_NOTICE("You flip \the [src]."), SPAN_NOTICE("You hear falling sand."), range = 2)
	// Invert the time elapsed so that it becomes the time remaining.
	var/time_elapsed = sand_duration - clamp(world.time - last_flipped, 0, sand_duration)
	last_flipped = world.time - time_elapsed
	update_icon()
	if(!is_processing)
		START_PROCESSING(SSobj, src)
	return TRUE

/obj/item/hourglass/Process()
	if(!sand_is_falling())
		return PROCESS_KILL
	if(get_sand_state(get_world_inventory_state()) == last_sand_state) // No need to do an update yet.
		return
	update_icon()

/obj/item/hourglass/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/hourglass/physically_destroyed(skip_qdel)
	// This code is adapted from compost bins.
	// TODO: Make a helper for 'create or add to scraps'.
	var/obj/item/debris/scraps/remains = (locate() in loc) || new(loc)
	LAZYINITLIST(remains.matter)
	if(matter[sand_material.type]) // Make sure we haven't already lost our sand... somehow?
		remains.matter[sand_material.type] += matter[sand_material.type]
	UNSETEMPTY(remains.matter)
	remains.update_primary_material()
	// Now create shards of our glass material.
	// At some point in the future this should probably respect matter conservation.
	// Right now we just make sure we have any glass left at all.
	if(matter[glass_material.type])
		glass_material.place_shards(loc)
	return ..()