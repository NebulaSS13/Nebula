/obj/machinery/disposal/deliveryChute
	name = "delivery chute"
	desc = "A chute to put things into a disposal network. Takes big and small packages alike!"
	density = TRUE
	icon = 'icons/obj/pipes/disposal_chute.dmi'
	icon_state = "chute"
	base_type = /obj/machinery/disposal/deliveryChute/buildable
	frame_type = /obj/structure/disposalconstruct/machine/chute
	// TODO: Convert attackby() override and c_mode vars to use construct states
	construct_state = null

	var/c_mode = 0

/obj/machinery/disposal/deliveryChute/buildable
	uncreated_component_parts = null

/obj/machinery/disposal/deliveryChute/Initialize()
	. = ..()
	trunk = locate() in src.loc
	if(trunk)
		trunk.linked = src	// link the pipe trunk to self

/obj/machinery/disposal/deliveryChute/interact()
	return

/obj/machinery/disposal/deliveryChute/on_update_icon()
	return

/obj/machinery/disposal/deliveryChute/CanPass(atom/movable/mover, turf/target, height=1.5, air_group = 0)
	. = (get_dir(src, mover) != dir) && ..()

/obj/machinery/disposal/deliveryChute/Bumped(var/atom/movable/AM) //Go straight into the chute

	if(istype(AM, /obj/item/projectile) || istype(AM, /obj/effect))
		return

	if(get_dir(src, AM) != dir)
		return

	var/mob/living/L = AM
	if (istype(L) && L.ckey)
		log_and_message_admins("has flushed themselves down \the [src].", L)
	if(istype(AM, /obj))
		var/obj/O = AM
		O.forceMove(src)
	else if(ismob(AM))
		var/mob/M = AM
		M.forceMove(src)
	src.flush()

/obj/machinery/disposal/deliveryChute/flush()
	flushing = 1
	flick("[icon_state]-closing", src)
	var/obj/structure/disposalholder/H = new()	// virtual holder object which actually
												// travels through the pipes.
	air_contents = new()		// new empty gas resv.

	sleep(10)
	playsound(src, 'sound/machines/disposalflush.ogg', 50, 0, 0)
	sleep(5) // wait for animation to finish

	if(prob(35))
		for(var/mob/living/human/L in src)
			var/list/obj/item/organ/external/crush = L.get_damageable_organs()
			if(!crush.len)
				return

			var/obj/item/organ/external/E = pick(crush)

			E.take_damage(45, inflicter = "Blunt Trauma")
			to_chat(L, "\The [src]'s mechanisms crush your [E.name]!")

	H.init(src)	// copy the contents of disposer to holder

	H.start(src) // start the holder processing movement
	flushing = 0
	// now reset disposal state
	flush = 0
	if(mode == 2)	// if was ready,
		mode = 1	// switch to charging
	update_icon()
	return

/obj/machinery/disposal/deliveryChute/attackby(var/obj/item/used_item, var/mob/user)
	if(IS_SCREWDRIVER(used_item))
		if(c_mode==0)
			c_mode=1
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, TRUE)
			to_chat(user, "You remove the screws around the power connection.")
			return TRUE
		else if(c_mode==1)
			c_mode=0
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, TRUE)
			to_chat(user, "You attach the screws around the power connection.")
			return TRUE
	else if(IS_WELDER(used_item) && c_mode==1)
		var/obj/item/weldingtool/welder = used_item
		if(!welder.weld(1,user)) // 'you need more welding fuel' messages are already handled
			return TRUE
		to_chat(user, "You start slicing the floorweld off the delivery chute.")
		if(!do_after(user, 2 SECONDS, src))
			to_chat(user, "You stop slicing the floorweld off the delivery chute.")
			return TRUE
		playsound(src.loc, 'sound/items/Welder2.ogg', 100, TRUE)
		if(!src || !welder.isOn()) return TRUE
		to_chat(user, "You slice the floorweld off the delivery chute.")
		var/obj/structure/disposalconstruct/C = new (loc, src)
		C.update()
		qdel(src)
		return TRUE
	return ..()

/obj/machinery/disposal/deliveryChute/Destroy()
	if(trunk)
		trunk.linked = null
	return ..()
