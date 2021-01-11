/obj/item/grenade
	name = "grenade"
	desc = "A hand held grenade, with an adjustable timer."
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/items/grenades/grenade.dmi'
	icon_state = ICON_STATE_WORLD
	throw_speed = 4
	throw_range = 20
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	var/active
	var/det_time = 50
	var/fail_det_time = 5 // If you are clumsy and fail, you get this time.
	var/arm_sound = 'sound/weapons/armbomb.ogg'

/obj/item/grenade/dropped(mob/user)
	. = ..()
	if(active)
		update_icon()

/obj/item/grenade/equipped(mob/user)
	. = ..()
	if(active)
		update_icon()

/obj/item/grenade/on_update_icon()
	cut_overlays()
	if(active)
		if(check_state_in_icon("[icon_state]-active", icon))
			var/image/I = image(icon, "[icon_state]-active")
			if(plane != HUD_PLANE)
				I.layer = ABOVE_LIGHTING_LAYER
				I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
			add_overlay(I)
	else if(check_state_in_icon("[icon_state]-pin", icon))
		add_overlay("[icon_state]-pin")

/obj/item/grenade/proc/clown_check(var/mob/living/user)
	if((MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>Huh? How does this thing work?</span>")
		det_time = fail_det_time
		activate(user)
		add_fingerprint(user)
		return 0
	return 1

/obj/item/grenade/examine(mob/user, distance)
	. = ..()
	if(distance <= 0)
		if(det_time > 1)
			to_chat(user, "The timer is set to [det_time/10] seconds.")
			return
		if(det_time == null)
			return
		to_chat(user, "\The [src] is set for instant detonation.")

/obj/item/grenade/attack_self(mob/user)
	if(active)
		return
	if(clown_check(user))
		to_chat(user, "<span class='warning'>You prime \the [name]! [det_time/10] seconds!</span>")
		activate(user)
		add_fingerprint(user)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.throw_mode_on()

/obj/item/grenade/proc/activate(mob/user)
	if(active)
		return
	if(user)
		msg_admin_attack("[user.name] ([user.ckey]) primed \a [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
	active = TRUE
	update_icon()
	playsound(loc, arm_sound, 75, 0, -3)
	addtimer(CALLBACK(src, .proc/detonate), det_time)

/obj/item/grenade/proc/detonate()
	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(700,125)

/obj/item/grenade/attackby(obj/item/W, mob/user)
	if(isScrewdriver(W))
		switch(det_time)
			if (1)
				det_time = 10
				to_chat(user, "<span class='notice'>You set the [name] for 1 second detonation time.</span>")
			if (10)
				det_time = 30
				to_chat(user, "<span class='notice'>You set the [name] for 3 second detonation time.</span>")
			if (30)
				det_time = 50
				to_chat(user, "<span class='notice'>You set the [name] for 5 second detonation time.</span>")
			if (50)
				det_time = 1
				to_chat(user, "<span class='notice'>You set the [name] for instant detonation.</span>")
		add_fingerprint(user)
	..()

/obj/item/grenade/attack_hand()
	walk(src, null, null)
	..()