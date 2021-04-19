/* Morgue stuff
 * Contains:
 *		Morgue
 *		Morgue trays
 *		Creamatorium
 *		Creamatorium trays
 */

/*
 * Morgue
 */

/obj/structure/morgue
	name = "morgue"
	desc = "Used to keep bodies in until someone fetches them."
	icon = 'icons/obj/structures/morgue.dmi'
	icon_state = "morgue1"
	dir = EAST
	density = 1
	var/obj/structure/m_tray/connected = null
	anchored = 1.0

/obj/structure/morgue/Destroy()
	if(connected)
		qdel(connected)
		connected = null
	return ..()

/obj/structure/morgue/proc/update()
	if (src.connected)
		src.icon_state = "morgue0"
	else
		if (src.contents.len)
			src.icon_state = "morgue2"
		else
			src.icon_state = "morgue1"
	return

/obj/structure/morgue/explosion_act(severity)
	..()
	if(!QDELETED(src) && (severity == 1 || (severity == 2 && prob(50)) || (severity == 3 && prob(5))))
		physically_destroyed()

/obj/structure/morgue/attack_hand(mob/user)
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.connected.loc)
			if (!( A.anchored ))
				A.forceMove(src)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		qdel(src.connected)
		src.connected = null
	else
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		src.connected = new /obj/structure/m_tray( src.loc )
		step(src.connected, src.dir)
		var/turf/T = get_step(src, src.dir)
		if (T.contents.Find(src.connected))
			src.connected.connected = src
			src.icon_state = "morgue0"
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.connected.loc)
			src.connected.icon_state = "morguet"
			src.connected.set_dir(src.dir)
		else
			qdel(src.connected)
			src.connected = null
	src.add_fingerprint(user)
	update()
	return

/obj/structure/morgue/attack_robot(var/mob/user)
	if(Adjacent(user))
		return attack_hand(user)
	else return ..()

/obj/structure/morgue/attackby(P, mob/user)
	if (istype(P, /obj/item/pen))
		var/t = input(user, "What would you like the label to be?", text("[]", src.name), null)  as text
		if (user.get_active_hand() != P)
			return
		if ((!in_range(src, usr) && src.loc != user))
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.SetName(text("Morgue- '[]'", t))
		else
			src.SetName("Morgue")
	src.add_fingerprint(user)
	return

/obj/structure/morgue/relaymove(mob/user)
	if (user.stat)
		return
	src.connected = new /obj/structure/m_tray( src.loc )
	step(src.connected, EAST)
	var/turf/T = get_step(src, EAST)
	if (T.contents.Find(src.connected))
		src.connected.connected = src
		src.icon_state = "morgue0"
		for(var/atom/movable/A as mob|obj in src)
			A.forceMove(src.connected.loc)
		src.connected.icon_state = "morguet"
	else
		qdel(src.connected)
		src.connected = null
	return


/*
 * Morgue tray
 */
/obj/structure/m_tray
	name = "morgue tray"
	desc = "Apply corpse before closing."
	icon = 'icons/obj/structures/morgue.dmi'
	icon_state = "morguet"
	density = 1
	layer = BELOW_OBJ_LAYER
	var/obj/structure/morgue/connected = null
	anchored = 1
	throwpass = 1

/obj/structure/m_tray/Destroy()
	if(connected && connected.connected == src)
		connected.connected = null
	connected = null
	return ..()

/obj/structure/m_tray/attack_hand(mob/user)
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.loc)
			if (!( A.anchored ))
				A.forceMove(src.connected)
		src.connected.connected = null
		src.connected.update()
		add_fingerprint(user)
		//SN src = null
		qdel(src)
		return
	return

/obj/structure/m_tray/receive_mouse_drop(atom/dropping, mob/user)
	. = ..()
	if(!. && (ismob(dropping) || istype(dropping, /obj/structure/closet/body_bag)))
		var/atom/movable/AM = dropping
		if(!AM.anchored)
			AM.forceMove(loc)
			if(user != dropping)
				user.visible_message(SPAN_NOTICE("\The [user] stuffs \the [dropping] into \the [src]!"))
			return TRUE

/*
 * Crematorium
 */

/obj/structure/crematorium
	name = "crematorium"
	desc = "A human incinerator. Works well on barbeque nights."
	icon = 'icons/obj/structures/crematorium.dmi'
	icon_state = "crema1"
	density = TRUE
	var/obj/structure/c_tray/connected = null
	anchored = TRUE
	var/cremating = FALSE
	var/id = 1
	var/locked = FALSE

/obj/structure/crematorium/Destroy()
	if(connected)
		qdel(connected)
		connected = null
	return ..()

/obj/structure/crematorium/proc/update()
	if(cremating)
		icon_state = "crema_active"
	else if (src.connected)
		src.icon_state = "crema0"
	else if (src.contents.len)
		src.icon_state = "crema2"
	else
		src.icon_state = "crema1"


/obj/structure/crematorium/explosion_act(severity)
	..()
	if(!QDELETED(src) && (severity == 1 || (severity == 2 && prob(50)) || (severity == 3 && prob(5))))
		physically_destroyed()

/obj/structure/crematorium/attack_hand(mob/user)
	if(cremating)
		to_chat(usr, "<span class='warning'>It's locked.</span>")
		return
	if(src.connected && (src.locked == FALSE))
		for(var/atom/movable/A as mob|obj in src.connected.loc)
			if (!( A.anchored ))
				A.forceMove(src)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		qdel(src.connected)
	else if(src.locked == 0)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		src.connected = new /obj/structure/c_tray(src.loc)
		step(src.connected, dir)
		var/turf/T = get_step(src, dir)
		if (T.contents.Find(src.connected))
			src.connected.connected = src
			src.icon_state = "crema0"
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.connected.loc)
			src.connected.icon_state = "cremat"
		else
			qdel(src.connected)
	src.add_fingerprint(user)
	update()

/obj/structure/crematorium/attackby(P, mob/user)
	if(istype(P, /obj/item/pen))
		var/t = input(user, "What would you like the label to be?", text("[]", src.name), null)  as text
		if(user.get_active_hand() != P)
			return
		if((!in_range(src, usr) > 1 && src.loc != user))
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if(t)
			src.SetName(text("Crematorium- '[]'", t))
		else
			src.SetName("Crematorium")
	src.add_fingerprint(user)
	return

/obj/structure/crematorium/relaymove(mob/user)
	if (user.stat || locked)
		return
	src.connected = new /obj/structure/c_tray( src.loc )
	step(src.connected, SOUTH)
	var/turf/T = get_step(src, SOUTH)
	if (T.contents.Find(src.connected))
		src.connected.connected = src
		src.icon_state = "crema0"
		for(var/atom/movable/A as mob|obj in src)
			A.forceMove(src.connected.loc)
	else
		qdel(src.connected)
		src.connected = null
	return

/obj/structure/crematorium/proc/cremate(atom/A, mob/user)
	if(cremating)
		return //don't let you cremate something twice or w/e

	if(contents.len <= 0)
		src.audible_message("<span class='warning'>You hear a hollow crackle.</span>", 1)
		return

	else
		if(length(search_contents_for(/obj/item/disk/nuclear)))
			to_chat(loc, "The button's status indicator flashes yellow, indicating that something important is inside the crematorium, and must be removed.")
			return
		src.audible_message("<span class='warning'>You hear a roar as the [src] activates.</span>", 1)

		cremating = 1
		locked = 1
		update()

		for(var/mob/living/M in contents)
			admin_attack_log(A, M, "Began cremating their victim.", "Has begun being cremated.", "began cremating")
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				for(var/I, I < 60, I++)

					if(C.stat >= UNCONSCIOUS || !(C in contents)) //In case we die or are removed at any point.
						cremating = 0
						update()
						break

					sleep(0.5 SECONDS)
					if(prob(40))
						var/desperation = rand(1,5)
						switch(desperation) //This is messy. A better solution would probably be to make more sounds, but...
							if(1)
								playsound(src.loc, 'sound/weapons/genhit.ogg', 45, 1)
								shake_animation(2)
								playsound(src.loc, 'sound/weapons/genhit.ogg', 45, 1)
							if(2)
								playsound(src.loc, 'sound/effects/grillehit.ogg', 45, 1)
								shake_animation(3)
								playsound(src.loc, 'sound/effects/grillehit.ogg', 45, 1)
							if(3)
								playsound(src, 'sound/effects/bang.ogg', 45, 1)
								if(prob(50))
									playsound(src, 'sound/effects/bang.ogg', 45, 1)
									shake_animation()
								else
									shake_animation(5)
							if(4)
								playsound(src, 'sound/effects/clang.ogg', 45, 1)
								shake_animation(5)
							if(5)
								playsound(src, 'sound/weapons/smash.ogg', 50, 1)
								if(prob(50))
									playsound(src, 'sound/weapons/smash.ogg', 50, 1)
									shake_animation(9)
								else
									shake_animation()

			if(round_is_spooky())
				if(prob(50))
					playsound(src, 'sound/effects/ghost.ogg', 10, 5)
				else
					playsound(src, 'sound/effects/ghost2.ogg', 10, 5)

			if (!M.stat)
				M.audible_message("[M]'s screams cease, as does any movement within the [src]. All that remains is a dull, empty silence.")

			admin_attack_log(M, A, "Cremated their victim.", "Was cremated.", "cremated")
			M.dust()

		for(var/obj/O in contents) //obj instead of obj/item so that bodybags and ashes get destroyed. We dont want tons and tons of ash piling up
			qdel(O)

		new /obj/effect/decal/cleanable/ash(src)
		sleep(30)
		cremating = initial(cremating)
		locked = initial(locked)
		update()
		playsound(src.loc, 'sound/effects/spray.ogg', 50, 1)
	return

/*
 * Crematorium tray
 */
/obj/structure/c_tray
	name = "crematorium tray"
	desc = "Apply body before burning."
	icon = 'icons/obj/structures/morgue.dmi'
	icon_state = "morguet"
	density = 1
	layer = BELOW_OBJ_LAYER
	var/obj/structure/crematorium/connected = null
	anchored = 1
	throwpass = 1

/obj/structure/c_tray/Destroy()
	if(connected && connected.connected == src)
		connected.connected = null
	connected = null
	return ..()

/obj/structure/c_tray/attack_hand(mob/user)
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.loc)
			if (!( A.anchored ))
				A.forceMove(src.connected)
		src.connected.connected = null
		src.connected.update()
		add_fingerprint(user)
		//SN src = null
		qdel(src)
		return
	return

/obj/structure/c_tray/receive_mouse_drop(atom/dropping, mob/user)
	. = ..()
	if(!. && (ismob(dropping) || istype(dropping, /obj/structure/closet/body_bag)))
		var/atom/movable/AM = dropping
		if(!AM.anchored)
			AM.forceMove(loc)
			if(user != dropping)
				user.visible_message(SPAN_NOTICE("\The [user] stuffs \the [dropping] into \the [src]!"))
			return TRUE

/obj/machinery/button/crematorium
	name = "crematorium igniter"
	desc = "Burn baby burn!"
	icon = 'icons/obj/power.dmi'
	icon_state = "crema_switch"
	initial_access = list(access_crematorium)
	id_tag = 1

/obj/machinery/button/crematorium/on_update_icon()
	return

/obj/machinery/button/crematorium/activate(mob/user)
	if(operating)
		return
	for(var/obj/structure/crematorium/C in range())
		if (C.id == id_tag)
			if (!C.cremating)
				C.cremate(user)
	..() // sets operating for click cooldown.
