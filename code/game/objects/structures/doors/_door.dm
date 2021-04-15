/obj/structure/door
	name = "door"
	icon = 'icons/obj/doors/material_doors.dmi'
	icon_state = "metal"
	hitsound = 'sound/weapons/genhit.ogg'
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_COLOR
	maxhealth = 50
	density =  TRUE
	anchored = TRUE
	opacity =  TRUE

	var/has_window = FALSE
	var/changing_state = FALSE
	var/icon_base
	var/datum/lock/lock

/obj/structure/door/Initialize()
	. = ..()
	if(lock)
		lock = new /datum/lock(src, lock)
	changing_state = FALSE
	update_nearby_tiles(need_rebuild=TRUE)
	
/obj/structure/door/on_material_change()
	. = ..()
	var/decl/material/material = get_primary_material()
	if(material)
		icon_base = material.door_icon_base
		if(material.luminescence)
			set_light(material.luminescence, 0.5, material.color)
		else
			set_light(0)
		if(material.opacity < 0.5)
			alpha = 180
		else
			alpha = initial(alpha)
	else
		icon_base = initial(icon_base)
		set_light(0)
		alpha = initial(alpha)

/obj/structure/door/Destroy()
	update_nearby_tiles()
	QDEL_NULL(lock)
	return ..()

/obj/structure/door/get_material_health_modifier()
	. = 10

/obj/structure/door/on_update_icon()
	..()
	if(density)
		icon_state = "[icon_base]"
	else
		icon_state = "[icon_base]open"

/obj/structure/door/proc/post_change_state()
	update_nearby_tiles()
	update_icon()
	changing_state = FALSE

/obj/structure/door/attack_hand(var/mob/user)
	return density ? open() : close()

/obj/structure/door/proc/close()
	set waitfor = 0
	if(!can_close())
		return FALSE
	flick("[icon_base]closing", src)
	var/decl/material/material = get_primary_material()
	playsound(src.loc, material.dooropen_noise, 100, 1)

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
	flick("[icon_base]opening", src)
	var/decl/material/material = get_primary_material()
	playsound(src.loc, material.dooropen_noise, 100, 1)

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

/obj/structure/door/attack_ai(mob/living/silicon/ai/user)
	if(Adjacent(user) && isrobot(user))
		return attack_hand(user)

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
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/door/CanFluidPass(var/coming_from)
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
	material_composition = list(/decl/material/solid/metal/iron = MATTER_AMOUNT_PRIMARY)

/obj/structure/door/silver
	material_composition = list(/decl/material/solid/metal/silver = MATTER_AMOUNT_PRIMARY)

/obj/structure/door/gold
	material_composition = list(/decl/material/solid/metal/gold = MATTER_AMOUNT_PRIMARY)

/obj/structure/door/uranium
	material_composition = list(/decl/material/solid/metal/uranium = MATTER_AMOUNT_PRIMARY)

/obj/structure/door/sandstone
	material_composition = list(/decl/material/solid/stone/sandstone = MATTER_AMOUNT_PRIMARY)

/obj/structure/door/diamond
	material_composition = list(/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_PRIMARY)

/obj/structure/door/wood
	material_composition = list(/decl/material/solid/wood = MATTER_AMOUNT_PRIMARY)

/obj/structure/door/mahogany
	material_composition = list(/decl/material/solid/wood/mahogany = MATTER_AMOUNT_PRIMARY)

/obj/structure/door/maple
	material_composition = list(/decl/material/solid/wood/maple = MATTER_AMOUNT_PRIMARY)

/obj/structure/door/ebony
	material_composition = list(/decl/material/solid/wood/ebony = MATTER_AMOUNT_PRIMARY)

/obj/structure/door/walnut
	material_composition = list(/decl/material/solid/wood/walnut = MATTER_AMOUNT_PRIMARY)

/obj/structure/door/cult
	material_composition = list(/decl/material/solid/stone/cult = MATTER_AMOUNT_PRIMARY)

/obj/structure/door/wood/saloon
	material_composition = list(/decl/material/solid/wood = MATTER_AMOUNT_PRIMARY)
	opacity = FALSE

/obj/structure/door/glass
	material_composition = list(/decl/material/solid/glass = MATTER_AMOUNT_PRIMARY)

/obj/structure/door/plastic
	material_composition = list(/decl/material/solid/plastic = MATTER_AMOUNT_PRIMARY)

/obj/structure/door/exotic_matter
	material_composition = list(/decl/material/solid/exotic_matter = MATTER_AMOUNT_PRIMARY)

/obj/structure/door/shuttle
	material_composition = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_PRIMARY)
