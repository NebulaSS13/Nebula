/obj/structure/crematorium
	name = "crematorium"
	desc = "A human incinerator. Works well on barbeque nights."
	icon = 'icons/obj/structures/crematorium.dmi'
	icon_state = "crematorium_closed"
	density = TRUE
	anchored = TRUE

	var/cremating = FALSE
	var/locked = FALSE
	var/open = FALSE

	var/obj/structure/crematorium_tray/connected_tray

	var/id_tag

/obj/structure/crematorium/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	connected_tray = new /obj/structure/crematorium_tray(src)
	connected_tray.connected_crematorium = src

/obj/structure/crematorium/Destroy()
	if(!QDELETED(connected_tray))
		QDEL_NULL(connected_tray)
	return ..()

/obj/structure/crematorium/on_update_icon()
	..()
	if(cremating)
		icon_state = "crematorium_active"
	else if (open)
		icon_state = "crematorium_open"
	else if (contents.len > 1)
		icon_state = "crematorium_filled"
	else
		icon_state = "crematorium_closed"

/obj/structure/crematorium/explosion_act(severity)
	..()
	if(!QDELETED(src) && (severity == 1 || (severity == 2 && prob(50)) || (severity == 3 && prob(5))))
		physically_destroyed()

/obj/structure/crematorium/proc/open()
	if(cremating || locked || open)
		return

	if(!connected_tray)
		return

	playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
	var/turf/T = get_step(src, dir)
	connected_tray.forceMove(T)
	connected_tray.set_dir(dir)
	for(var/atom/movable/A in src)
		A.forceMove(get_turf(connected_tray))

	open = TRUE
	update_icon()

/obj/structure/crematorium/proc/close()
	if(!open)
		return
	
	if(!connected_tray)
		return

	for(var/atom/movable/A in get_turf(connected_tray))
		if(A.simulated && !A.anchored && A != connected_tray)
			A.forceMove(src)

	playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
	connected_tray.forceMove(src)

	open = FALSE
	update_icon()

/obj/structure/crematorium/attack_hand(mob/user)
	if(locked)
		to_chat(usr, SPAN_WARNING("It's currently locked."))
		return
	
	if(open)
		close()
	else
		open()

	return ..()

/obj/structure/crematorium/attack_robot(mob/user)
	if(Adjacent(user))
		return attack_hand(user)

/obj/structure/crematorium/attackby(P, mob/user)
	if(istype(P, /obj/item/pen))
		var/new_label = sanitize_safe(input(user, "What would you like the label to be?", capitalize(name), null) as text|null, MAX_NAME_LEN)

		if((!Adjacent(user) || loc == user))
			return
		
		if(has_extension(src, /datum/extension/labels))
			var/datum/extension/labels/L = get_extension(src, /datum/extension/labels)
			if(!L.CanAttachLabel(user, new_label))
				return
		
		attach_label(user, P, new_label)
		return
	else 
		return ..()

/obj/structure/crematorium/relaymove(mob/user)
	if(user.incapacitated() || locked)
		return

	open()

/obj/structure/crematorium/proc/cremate(atom/A, mob/user)
	if(cremating || open)
		return //don't let you cremate something twice or w/e

	if(contents.len <= 1)
		audible_message(SPAN_WARNING("You hear a hollow crackle."), 1)
		return

	else
		if(length(search_contents_for(/obj/item/disk/nuclear)))
			to_chat(user, "The button's status indicator flashes yellow, indicating that something important is inside the crematorium, and must be removed.")
			return

		audible_message("<span class='warning'>You hear a roar as the [src] activates.</span>", 1)

		cremating = TRUE
		locked = TRUE
		update_icon()

		for(var/mob/living/M in contents)
			admin_attack_log(A, M, "Began cremating their victim.", "Has begun being cremated.", "began cremating")
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				for(var/I, I < 60, I++)

					if(C.stat >= UNCONSCIOUS || !(C in contents)) //In case we die or are removed at any point.
						cremating = 0
						update_icon()
						break

					sleep(0.5 SECONDS)

					if(QDELETED(src))
						return

					if(prob(40))
						var/desperation = rand(1,5)
						switch(desperation) //This is messy. A better solution would probably be to make more sounds, but...
							if(1)
								playsound(loc, 'sound/weapons/genhit.ogg', 45, 1)
								shake_animation(2)
								playsound(loc, 'sound/weapons/genhit.ogg', 45, 1)
							if(2)
								playsound(loc, 'sound/effects/grillehit.ogg', 45, 1)
								shake_animation(3)
								playsound(loc, 'sound/effects/grillehit.ogg', 45, 1)
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
			if(!istype(O, connected_tray))
				qdel(O)

		new /obj/effect/decal/cleanable/ash(src)
		sleep(30)
		cremating = initial(cremating)
		locked = initial(locked)
		playsound(src, 'sound/effects/spray.ogg', 50, 1)
		update_icon()

/obj/structure/crematorium_tray
	name = "crematorium tray"
	desc = "Apply body before burning."
	icon = 'icons/obj/structures/crematorium.dmi'
	icon_state = "crematorium_tray"
	density = TRUE
	anchored = TRUE
	throwpass = TRUE
	layer = BELOW_OBJ_LAYER

	var/obj/structure/crematorium/connected_crematorium

/obj/structure/crematorium_tray/Destroy()
	if(!QDELETED(connected_crematorium))
		QDEL_NULL(connected_crematorium)
	return ..()

/obj/structure/crematorium_tray/attack_hand(mob/user)
	if(Adjacent(user))
		connected_crematorium.attack_hand(user)
	return ..()

/obj/structure/crematorium_tray/attack_robot(mob/user)
	if(Adjacent(user))
		attack_hand(user)

/obj/structure/crematorium_tray/receive_mouse_drop(atom/dropping, mob/user)
	. = ..()
	if(!. && (ismob(dropping) || istype(dropping, /obj/structure/closet/body_bag)))
		var/atom/movable/AM = dropping
		if(!AM.anchored)
			AM.forceMove(loc)
			if(user != dropping)
				user.visible_message(SPAN_NOTICE("\The [user] stuffs \the [dropping] onto \the [src]!"))
			return TRUE

/obj/machinery/button/crematorium
	name = "crematorium igniter"
	desc = "Burn baby burn!"
	icon = 'icons/obj/power.dmi'
	icon_state = "crematorium_switch"
	initial_access = list(access_crematorium)

/obj/machinery/button/crematorium/on_update_icon()
	return

/obj/machinery/button/crematorium/activate(mob/user)
	if(operating)
		return

	for(var/obj/structure/crematorium/C in range())
		if (C.id_tag == id_tag || isnull(C.id_tag))
			if (!C.cremating)
				C.cremate(user)

	..() // sets operating for click cooldown.
