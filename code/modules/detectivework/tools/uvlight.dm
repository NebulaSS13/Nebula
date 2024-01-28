/obj/item/uv_light
	name = "\improper UV light"
	desc = "A small handheld black light."
	icon = 'icons/obj/items/device/ultraviolet.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_SMALL
	action_button_name = "Toggle UV light"
	material = /decl/material/solid/metal/steel
	origin_tech = @'{"magnets":1,"engineering":1}'
	z_flags = ZMM_MANGLE_PLANES
	var/list/scanned = list()
	var/list/stored_alpha = list()
	var/list/reset_objects = list()
	var/range = 3
	var/on = 0
	var/step_alpha = 50

/obj/item/uv_light/attack_self(var/mob/user)
	on = !on
	if(on)
		set_light(range, 2, "#007fff")
		START_PROCESSING(SSobj, src)
	else
		set_light(0)
		clear_last_scan()
		STOP_PROCESSING(SSobj, src)
	update_icon()

/obj/item/uv_light/dropped(mob/user)
	. = ..()
	if(on)
		update_icon()

/obj/item/uv_light/equipped(mob/user, slot)
	. = ..()
	if(on)
		update_icon()

/obj/item/uv_light/on_update_icon()
	. = ..()
	z_flags &= ~ZMM_MANGLE_PLANES
	if(on)
		if(plane == HUD_PLANE)
			add_overlay("[icon_state]-on")
		else
			add_overlay(emissive_overlay(icon, "[icon_state]-on"))
			z_flags |= ZMM_MANGLE_PLANES

/obj/item/uv_light/proc/clear_last_scan()
	if(scanned.len)
		for(var/atom/O in scanned)
			O.set_invisibility(scanned[O])
			if(O.fluorescent == FLUORESCENT_GLOWING)
				O.fluorescent = FLUORESCENT_GLOWS
		scanned.Cut()
	if(stored_alpha.len)
		for(var/atom/O in stored_alpha)
			O.alpha = stored_alpha[O]
			if(O.fluorescent == FLUORESCENT_GLOWING)
				O.fluorescent = FLUORESCENT_GLOWS
		stored_alpha.Cut()
	if(reset_objects.len)
		for(var/obj/item/I in reset_objects)
			I.overlays -= I.blood_overlay
			if(I.fluorescent == FLUORESCENT_GLOWING)
				I.fluorescent = FLUORESCENT_GLOWS
		reset_objects.Cut()

/obj/item/uv_light/Process()
	clear_last_scan()
	if(on)
		step_alpha = round(255/range)
		var/turf/origin = get_turf(src)
		if(!origin)
			return
		for(var/turf/T in range(range, origin))
			var/use_alpha = 255 - (step_alpha * get_dist(origin, T))
			for(var/atom/A in T.contents)
				if(A.fluorescent == FLUORESCENT_GLOWS)
					A.fluorescent = FLUORESCENT_GLOWING //To prevent light crosstalk.
					if(A.invisibility)
						scanned[A] = A.invisibility
						A.set_invisibility(INVISIBILITY_NONE)
						stored_alpha[A] = A.alpha
						A.alpha = use_alpha
					if(istype(A, /obj/item))
						var/obj/item/O = A
						if(O.was_bloodied && !(O.blood_overlay in O.overlays))
							O.overlays |= O.blood_overlay
							reset_objects |= O