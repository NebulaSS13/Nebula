/obj/item/gun/launcher/bow
	name = "bow"
	desc = "A projectile weapon of ancient design that turns elastic tension into long-range death."
	icon = 'icons/obj/guns/launcher/bow.dmi'
	icon_state = ICON_STATE_WORLD
	fire_sound = 'sound/weapons/punchmiss.ogg' // TODO: Decent THWOK noise.
	fire_sound_text = "a solid thunk"
	fire_delay = 25
	slot_flags = SLOT_BACK
	has_safety = FALSE
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	material = /decl/material/solid/organic/wood/yew
	fire_verb = "loose"
	autofire_enabled = TRUE

	/// What are we strung with?
	var/obj/item/bowstring/string = /obj/item/bowstring
	/// Currently loaded ammo.
	var/obj/item/_loaded
	/// Current draw on the bow.
	var/tension = 0
	/// Highest possible tension.
	var/max_tension = 3
	/// Speed per unit of tension.
	var/release_speed = 14
	/// Time needed to draw the bow back by one "tension"
	var/draw_time = 1 SECOND
	/// Does this bow need an arrow nocked to draw?
	var/require_loaded_to_draw = TRUE
	/// What skill is used to load and fire this bow?
	var/work_skill = SKILL_WEAPONS
	/// Does this bow keep tension when dropped?
	var/keep_tension_when_dropped = FALSE
	/// What kind of ammunition does this bow expect?
	var/bow_ammo_type = /obj/item/stack/material/bow_ammo/arrow
	/// Flag for tracking if a bow is currently being drawn, to avoid double draw.
	var/drawing_bow = FALSE
	/// Timer for tracking next increase in tension from click and hold.
	var/next_tension_step

/obj/item/gun/launcher/bow/set_autofire(var/atom/fire_at, var/mob/fire_by, var/autoturn = TRUE)
	if(!autofire_enabled || autofiring_at)
		return ..()
	. = ..()
	if(ismob(fire_by))
		if(!get_loaded_arrow(fire_by) && fire_by.skill_check(SKILL_WEAPONS, SKILL_ADEPT))
			load_available_ammo(fire_by)
		if(check_can_draw(fire_by))
			tension = 0
			next_tension_step = world.time + get_draw_time(fire_by)
			fire_by.set_dir(get_dir(fire_by, fire_at))
			show_draw_message(fire_by)
			update_icon()

/obj/item/gun/launcher/bow/try_autofire(autoturn)
	if(!autofire_enabled)
		return ..()
	var/mob/wielder = loc
	if(!ismob(wielder) || !check_can_draw(wielder))
		clear_autofire()
	else
		wielder.set_dir(get_dir(wielder, autofiring_at))
		if(world.time >= next_tension_step && tension < max_tension)
			next_tension_step = world.time + get_draw_time(wielder)
			tension++
			if(tension == max_tension)
				show_max_draw_message(wielder)
			else
				show_working_draw_message(wielder)
			update_icon()

/obj/item/gun/launcher/bow/clear_autofire()
	if(!autofire_enabled)
		return ..()
	var/mob/living/wielder = loc
	if(tension && istype(wielder) && !wielder.incapacitated() && wielder.get_active_held_item() == src && get_loaded_arrow())
		wielder.set_dir(get_dir(wielder, autofiring_at))
		Fire(autofiring_at, autofiring_by, null, (get_dist(autofiring_at, autofiring_by) <= 1), FALSE, FALSE)
	. = ..()
	if(tension)
		if(istype(wielder))
			show_cancel_draw_message(wielder)
		tension = 0
		update_icon()

/obj/item/gun/launcher/bow/handle_click_empty(atom/movable/firer)
	if(check_fire_message_spam("click"))
		to_chat(firer, SPAN_WARNING("\The [src] has nothing loaded."))

/obj/item/gun/launcher/bow/fancy
	desc = "A projectile weapon of ancient design that turns elastic tension into long-range death. This one has decorative engraving and flourishes."
	icon = 'icons/obj/guns/launcher/bow_fancy.dmi'

/obj/item/gun/launcher/bow/crafted
	string = null

/obj/item/gun/launcher/bow/fancy/crafted
	string = null


/obj/item/gun/launcher/bow/Initialize()
	if(ispath(string))
		string = new string(src)
	return ..()

/obj/item/gun/launcher/bow/Destroy()
	QDEL_NULL(_loaded)
	QDEL_NULL(string)
	return ..()

/obj/item/gun/launcher/bow/physically_destroyed()
	if(_loaded)
		_loaded.dropInto(loc)
		_loaded = null
	if(string)
		string.dropInto(loc)
		string = null
	return ..()

/obj/item/gun/launcher/bow/dropped()
	if(!keep_tension_when_dropped)
		if(tension)
			tension = 0
		if(_loaded)
			remove_arrow()
		update_icon()
	return ..()

/obj/item/gun/launcher/bow/get_firing_name(obj/projectile)
	if(!projectile)
		return ..()
	return "\the [projectile] from \the [src]"

/obj/item/gun/launcher/bow/proc/add_base_bow_overlays()
	return

/obj/item/gun/launcher/bow/on_update_icon()

	. = ..()

	icon_state = get_world_inventory_state()

	add_base_bow_overlays()

	if(_loaded)
		var/bolt_state = "[icon_state]-loaded"
		if(tension)
			bolt_state = "[bolt_state]-drawn"
		if(check_state_in_icon(bolt_state, icon))
			add_overlay(overlay_image(icon, bolt_state, _loaded.color, RESET_COLOR))

	if(string)
		var/string_state = "[icon_state]-string"
		if(tension)
			string_state = "[string_state]-drawn"
		if(check_state_in_icon(string_state, icon))
			add_overlay(overlay_image(icon, string_state, string.color, RESET_COLOR))

/obj/item/gun/launcher/bow/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay)
		if(string)
			var/string_state = "[overlay.icon_state]-string"
			if(check_state_in_icon(string_state, overlay.icon))
				overlay.overlays += overlay_image(overlay.icon, string_state, string.color, RESET_COLOR)
		if(_loaded)
			var/loaded_state = "[overlay.icon_state]-loaded"
			if(check_state_in_icon(loaded_state, overlay.icon))
				overlay.overlays += overlay_image(overlay.icon, loaded_state, _loaded.color, RESET_COLOR)
	return ..()

/obj/item/gun/launcher/bow/examine(mob/user)
	. = ..()
	var/list/strings = list()
	if(material_alteration & MAT_FLAG_ALTERATION_DESC)
		strings += "is made of [material.solid_name]"
	if(string)
		strings += "is strung with \a [string]"
	if(_loaded)
		strings += "has \a [_loaded] ready"
	if(!length(strings))
		return
	to_chat(user, "It [english_list(strings)].")
