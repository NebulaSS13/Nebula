/obj/item/gun/launcher/bow/crossbow
	name = "crossbow"
	desc = "A mechanically-powered projectile weapon."
	icon = 'icons/obj/guns/launcher/crossbow.dmi'
	fire_sound = 'sound/weapons/punchmiss.ogg' // TODO: Decent THWOK noise.
	fire_sound_text = "a solid thunk"
	fire_delay = 25
	require_loaded_to_draw = FALSE
	keep_tension_when_dropped = TRUE
	bow_ammo_type = /obj/item/stack/material/bow_ammo/bolt
	draw_time = 2 SECONDS
	release_speed = 18
	autofire_enabled = FALSE

/obj/item/gun/launcher/bow/crossbow/show_load_message(mob/user)
	if(user)
		user.visible_message(
			SPAN_NOTICE("\The [user] slides \the [_loaded] into \the [src]."),
			SPAN_NOTICE("You slide \the [_loaded] into \the [src].")
		)
