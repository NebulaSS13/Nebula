/obj/structure/door
	name = "door"
	icon = 'icons/obj/doors/material_doors.dmi'
	icon_state = "metal"
	hitsound = 'sound/weapons/genhit.ogg'
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC | MAT_FLAG_ALTERATION_COLOR
	maxhealth = 50
	density =  TRUE
	anchored = TRUE
	opacity =  TRUE

	var/datum/lock/lock

	var/has_window = FALSE
	var/changing_state = FALSE
	var/icon_base
	var/door_sound_volume = 25

/obj/structure/door/Initialize()
	. = ..()
	if(!istype(material))
		return INITIALIZE_HINT_QDEL
	if(lock)
		lock = new /datum/lock(src, lock)
	if(!icon_base)
		icon_base = material.door_icon_base
	update_icon()
	update_nearby_tiles(need_rebuild = TRUE)
	if(material?.luminescence)
		set_light(material.luminescence, 0.5, material.color)

/obj/structure/door/Destroy()
	update_nearby_tiles()
	QDEL_NULL(lock)
	return ..()

/obj/structure/door/get_material_health_modifier()
	. = 10

/obj/structure/door/on_update_icon()
	..()
	icon_state = "[icon_base][!density ? "_open" : ""]"

/obj/structure/door/proc/post_change_state()
	update_nearby_tiles()
	update_icon()
	changing_state = FALSE

/obj/structure/door/attack_hand(mob/user)
	if(user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, TRUE))
		return density ? open() : close()
	return ..()

/obj/structure/door/proc/close()
	set waitfor = 0
	if(!can_close())
		return FALSE
	flick("[icon_base]_closing", src)
	playsound(src, material.dooropen_noise, door_sound_volume, 1)

	changing_state = TRUE
	sleep(1 SECOND)
	set_density(TRUE)
	set_opacity(!has_window && material.opacity > 0.5)
	post_change_state()
	return TRUE

/obj/structure/door/proc/open()
	set waitfor = 0
	if(!can_open())
		return FALSE
	flick("[icon_base]_opening", src)
	playsound(src, material.dooropen_noise, door_sound_volume, 1)

	changing_state = TRUE
	sleep(1 SECOND)
	set_density(FALSE)
	set_opacity(FALSE)
	post_change_state()
	return TRUE

/obj/structure/door/proc/can_open()
	if(lock && lock.isLocked())
		return FALSE
	return density && !changing_state

/obj/structure/door/proc/can_close()
	return !density && !changing_state

/obj/structure/door/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 && lock)
		to_chat(user, SPAN_NOTICE("It appears to have a lock."))

/obj/structure/door/attack_ai(mob/living/user)
	return attack_hand_with_interaction_checks(user)

/obj/structure/door/explosion_act(severity)
	. = ..()
	if(!QDELETED(src))
		take_damage(100 - (severity * 30))

/obj/structure/door/can_repair(var/mob/user)
	. = ..()
	if(. && !density)
		to_chat(user, SPAN_WARNING("\The [src] must be closed before it can be repaired."))
		return FALSE

/obj/structure/door/attackby(obj/item/I, mob/user)
	add_fingerprint(user, 0, I)

	if((user.a_intent == I_HURT && I.force) || istype(I, /obj/item/stack/material))
		return ..()

	if(lock)
		if(istype(I, /obj/item/key))
			if(!lock.toggle(I))
				to_chat(user, SPAN_WARNING("\The [I] does not fit in the lock!"))
			return TRUE
		if(lock.pick_lock(I,user))
			return TRUE
		if(lock.isLocked())
			to_chat(user, SPAN_WARNING("\The [src] is locked!"))
		return TRUE

	if(istype(I,/obj/item/lock_construct))
		if(lock)
			to_chat(user, SPAN_WARNING("\The [src] already has a lock."))
		else
			var/obj/item/lock_construct/L = I
			lock = L.create_lock(src,user)
		return

	if(density)
		open()
	else
		close()

/obj/structure/door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group)
		return !density
	if(istype(mover, /obj/effect/ir_beam))
		return !opacity
	return !density

/obj/structure/door/CanFluidPass(coming_from)
	return !density

/obj/structure/door/Bumped(atom/AM)
	if(!density || changing_state)
		return
	if(ismob(AM))
		var/mob/M = AM
		if(M.restrained() || issmall(M))
			return
	open()

/obj/structure/door/iron
	material = /decl/material/solid/metal/iron

/obj/structure/door/silver
	material = /decl/material/solid/metal/silver

/obj/structure/door/gold
	material = /decl/material/solid/metal/gold

/obj/structure/door/uranium
	material = /decl/material/solid/metal/uranium

/obj/structure/door/sandstone
	material = /decl/material/solid/stone/sandstone

/obj/structure/door/diamond
	material = /decl/material/solid/gemstone/diamond

/obj/structure/door/wood
	material = /decl/material/solid/wood

/obj/structure/door/mahogany
	material = /decl/material/solid/wood/mahogany

/obj/structure/door/maple
	material = /decl/material/solid/wood/maple

/obj/structure/door/ebony
	material = /decl/material/solid/wood/ebony

/obj/structure/door/walnut
	material = /decl/material/solid/wood/walnut

/obj/structure/door/cult
	material = /decl/material/solid/stone/cult

/obj/structure/door/wood/saloon
	material = /decl/material/solid/wood
	opacity = FALSE

/obj/structure/door/glass
	material = /decl/material/solid/glass

/obj/structure/door/plastic
	material = /decl/material/solid/plastic

/obj/structure/door/exotic_matter
	material = /decl/material/solid/exotic_matter

/obj/structure/door/shuttle
	material = /decl/material/solid/metal/steel
