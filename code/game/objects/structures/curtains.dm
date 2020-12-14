/obj/item/curtain
	name = "rolled curtain"
	desc = "A rolled curtains."
	icon = 'icons/obj/structures/curtain.dmi'
	icon_state = "curtain_rolled"
	force = 3 //just plastic
	w_class = ITEM_SIZE_HUGE //curtains, yeap
	var/obj/structure/curtain/holder = /obj/structure/curtain

/obj/item/curtain/attackby(obj/item/W, mob/user)
	if(isScrewdriver(W))
		if(!holder)
			return

		if(!isturf(loc))
			to_chat(user, SPAN_DANGER("You cannot install \the [src] from your hands."))
			return

		if(isspaceturf(loc))
			to_chat(user, SPAN_DANGER("You cannot install \the [src] in space."))
			return

		user.visible_message(
			SPAN_NOTICE("\The [user] begins installing \the [src]."),
			SPAN_NOTICE("You begin installing \the [src]."))
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)

		if(!do_after(user, 4 SECONDS, src))
			return

		if(QDELETED(src))
			return

		var/obj/structure/curtain/C = new holder(loc)
		transfer_fingerprints_to(C)
		C.SetName(replacetext(name, "rolled", ""))
		C.color = color
		qdel(src)
	else
		..()

/obj/structure/curtain
	name = "curtain"
	icon = 'icons/obj/structures/curtain.dmi'
	icon_state = "closed"
	layer = ABOVE_WINDOW_LAYER
	opacity = TRUE
	density = FALSE
	anchored = TRUE
	var/obj/item/curtain/holder = /obj/item/curtain

/obj/structure/curtain/open
	icon_state = "open"
	layer = ABOVE_HUMAN_LAYER
	opacity = FALSE

/obj/structure/curtain/Initialize()
	. = ..()
	set_extension(src, /datum/extension/turf_hand)

/obj/structure/curtain/bullet_act(obj/item/projectile/P, def_zone)
	if(!P.nodamage)
		visible_message(SPAN_WARNING("[P] tears [src] down!"))
		qdel(src)
	else
		..(P, def_zone)

/obj/structure/curtain/attack_hand(mob/user)
	toggle()
	..()

/obj/structure/curtain/attackby(obj/item/W, mob/user)
	if(isScrewdriver(W))
		if(!holder)
			return

		user.visible_message(
			SPAN_NOTICE("\The [user] begins uninstalling \the [src]."),
			SPAN_NOTICE("You begin uninstalling \the [src]."))
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)

		if(!do_after(user, 4 SECONDS, src))
			return

		if(QDELETED(src))
			return

		var/obj/item/curtain/C = new holder(loc)
		transfer_fingerprints_to(C)
		C.SetName("rolled [name]")
		C.color = color
		qdel(src)
	else
		..()

/obj/structure/curtain/proc/toggle()
	playsound(src, 'sound/effects/curtain.ogg', 15, 1, -5)
	set_opacity(!opacity)
	if(opacity)
		icon_state = "closed"
		layer = ABOVE_HUMAN_LAYER
	else
		icon_state = "open"
		layer = ABOVE_WINDOW_LAYER

// Normal subtypes
/obj/structure/curtain/bed
	name = "bed curtain"
	color = "#854636"

/obj/structure/curtain/black
	name = "black curtain"
	color = "#222222"

/obj/structure/curtain/medical
	name = "plastic curtain"
	color = "#b8f5e3"
	alpha = 200

/obj/structure/curtain/bar
	name = "bar curtain"
	color = "#854636"

/obj/structure/curtain/privacy
	name = "privacy curtain"
	color = "#b8f5e3"

/obj/structure/curtain/shower
	name = "shower curtain"
	color = "#acd1e9"
	alpha = 200

/obj/structure/curtain/canteen
	name = "privacy curtain"
	color = COLOR_BLUE_GRAY

// Open subtypes
/obj/structure/curtain/open/bed
	name = "bed curtain"
	color = "#854636"

/obj/structure/curtain/open/black
	name = "black curtain"
	color = "#222222"

/obj/structure/curtain/open/medical
	name = "plastic curtain"
	color = "#b8f5e3"
	alpha = 200

/obj/structure/curtain/open/bar
	name = "bar curtain"
	color = "#854636"

/obj/structure/curtain/open/privacy
	name = "privacy curtain"
	color = "#b8f5e3"

/obj/structure/curtain/open/shower
	name = "shower curtain"
	color = "#acd1e9"
	alpha = 200

/obj/structure/curtain/open/canteen
	name = "privacy curtain"
	color = COLOR_BLUE_GRAY

/obj/structure/curtain/open/shower/engineering
	color = "#ffa500"

/obj/structure/curtain/open/shower/security
	color = "#aa0000"
