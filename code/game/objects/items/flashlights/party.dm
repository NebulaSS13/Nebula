
/obj/item/flashlight/party
	name = "party light"
	desc = "An array of LEDs in tons of colors."
	icon = 'icons/obj/lighting/partylight.dmi'
	material = /decl/material/solid/organic/plastic
	matter = list(
		/decl/material/solid/metal/steel  = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/glass        = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/copper = MATTER_AMOUNT_TRACE,
		/decl/material/solid/silicon      = MATTER_AMOUNT_TRACE
	)
	flashlight_range = 7
	flashlight_power = 1
	light_wedge = LIGHT_OMNI
	var/obj/effect/party_light/strobe_effect

/obj/item/flashlight/party/Destroy()
	. = ..()
	stop_strobing()

/obj/item/flashlight/party/set_flashlight(var/set_direction = TRUE)
	. = ..()
	if(on)
		start_strobing()
	else
		stop_strobing()

/obj/item/flashlight/party/proc/stop_strobing()
	if(strobe_effect)
		// Cause the party light effect to stop following this object, and then delete it.
		events_repository.unregister(/decl/observ/moved, src, strobe_effect)
		update_icon()
		QDEL_NULL(strobe_effect)

/obj/item/flashlight/party/proc/start_strobing()
	if(!strobe_effect)
		strobe_effect = new(get_turf(src))
		events_repository.register(/decl/observ/moved, src, strobe_effect, TYPE_PROC_REF(/atom/movable, move_to_turf_or_null))
		update_icon()

/obj/effect/party_light
	name = "party light"
	desc = "This is probably bad for your eyes."
	icon = 'icons/effects/lens_flare.dmi'
	icon_state = "party_strobe"
	simulated = FALSE
	anchored = TRUE
	pixel_x = -30
	pixel_y = -4
	layer = ABOVE_LIGHTING_LAYER
	plane = ABOVE_LIGHTING_PLANE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
