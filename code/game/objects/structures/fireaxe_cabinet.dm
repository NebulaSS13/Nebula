/obj/structure/fireaxecabinet
	name = "fire axe cabinet"
	desc = "There is small label that reads \"For Emergency use only\" along with details for safe use of the axe. As if."
	icon = 'icons/obj/structures/fireaxe.dmi'
	icon_state = "fireaxe"
	anchored = 1
	density = 0
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	directional_offset = "{'NORTH':{'y':-32}, 'SOUTH':{'y':32}, 'EAST':{'x':-32}, 'WEST':{'x':32}}"
	hitsound = 'sound/effects/Glasshit.ogg'
	sound_break =  'sound/effects/Glassbr3.ogg'
	armor = list(DEF_MELEE = ARMOR_MELEE_KNIVES)
	var/open
	var/unlocked
	var/shattered
	var/obj/item/twohanded/fireaxe/fireaxe

//#TODO: Need some more work to properly handle the broken state

/obj/structure/fireaxecabinet/on_update_icon()
	..()
	if(fireaxe)
		add_overlay("fireaxe_item")
	if(shattered)
		add_overlay("fireaxe_window_broken")
	else if(!open)
		add_overlay("fireaxe_window")

/obj/structure/fireaxecabinet/Initialize()
	. = ..()
	if(!fireaxe)
		fireaxe = new(src)
	update_icon()

/obj/structure/fireaxecabinet/attack_ai(var/mob/user)
	toggle_lock(user)

/obj/structure/fireaxecabinet/attack_hand(var/mob/user)
	if(!unlocked)
		to_chat(user, "<span class='warning'>\The [src] is locked.</span>")
		return
	toggle_open(user)

/obj/structure/fireaxecabinet/handle_mouse_drop(atom/over, mob/user)
	if(over == user)
		if(!open)
			to_chat(user, SPAN_WARNING("\The [src] is closed."))
			return TRUE
		if(!fireaxe)
			to_chat(user, SPAN_WARNING("\The [src] is empty."))
			return TRUE
		user.put_in_hands(fireaxe)
		fireaxe = null
		update_icon()
		return TRUE
	. = ..()

/obj/structure/fireaxecabinet/Destroy()
	QDEL_NULL(fireaxe)
	. = ..()

/obj/structure/fireaxecabinet/dismantle()
	if(loc && !dismantled && !QDELETED(fireaxe))
		fireaxe.dropInto(loc)
		fireaxe = null
	. = ..()

/obj/structure/fireaxecabinet/attackby(var/obj/item/O, var/mob/user)

	if(IS_MULTITOOL(O))
		toggle_lock(user)
		return

	if(istype(O, /obj/item/twohanded/fireaxe))
		if(open)
			if(fireaxe)
				to_chat(user, "<span class='warning'>There is already \a [fireaxe] inside \the [src].</span>")
			else if(user.unEquip(O))
				O.forceMove(src)
				fireaxe = O
				to_chat(user, "<span class='notice'>You place \the [fireaxe] into \the [src].</span>")
				update_icon()
			return
	return ..()

/obj/structure/fireaxecabinet/proc/toggle_open(var/mob/user)
	if(shattered)
		open = 1
		unlocked = 1
	else
		user.setClickCooldown(10)
		open = !open
		to_chat(user, "<span class='notice'>You [open ? "open" : "close"] \the [src].</span>")
	update_icon()

/obj/structure/fireaxecabinet/proc/toggle_lock(var/mob/user)


	if(open)
		return

	if(shattered)
		open = 1
		unlocked = 1
	else
		user.setClickCooldown(10)
		to_chat(user, "<span class='notice'>You begin [unlocked ? "enabling" : "disabling"] \the [src]'s maglock.</span>")

		if(!do_after(user, 20,src))
			return

		if(shattered) return

		unlocked = !unlocked
		playsound(user, 'sound/machines/lockreset.ogg', 50, 1)
		to_chat(user, "<span class = 'notice'>You [unlocked ? "disable" : "enable"] the maglock.</span>")

	update_icon()
