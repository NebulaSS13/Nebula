/obj/structure/deity/trap
	density = 0
	health = 1
	var/triggered = 0

/obj/structure/deity/trap/Initialize()
	. = ..()
	events_repository.register(/decl/observ/entered, get_turf(src),src,/obj/structure/deity/trap/proc/trigger)

/obj/structure/deity/trap/Destroy()
	events_repository.unregister(/decl/observ/entered, get_turf(src),src)
	return ..()

/obj/structure/deity/trap/Move()
	events_repository.unregister(/decl/observ/entered, get_turf(src),src)
	. = ..()
	events_repository.register(/decl/observ/entered, get_turf(src), src, /obj/structure/deity/trap/proc/trigger)

/obj/structure/deity/trap/attackby(obj/item/W, mob/user)
	trigger(user)
	return ..()

/obj/structure/deity/trap/bullet_act()
	return

/obj/structure/deity/trap/proc/trigger(var/atom/entered, var/atom/movable/enterer)
	if(triggered > world.time || !istype(enterer, /mob/living))
		return

	triggered = world.time + 30 SECONDS