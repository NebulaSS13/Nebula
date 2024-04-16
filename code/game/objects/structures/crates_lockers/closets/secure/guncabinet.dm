/obj/structure/closet/secure_closet/guncabinet
	name = "gun cabinet"
	req_access = list(access_armory)
	icon = 'icons/obj/guncabinet.dmi'
	closet_appearance = null

/obj/structure/closet/secure_closet/guncabinet/Initialize()
	. = ..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/LateInitialize(mapload, ...)
	. = ..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/toggle()
	..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/open(mob/user) //There are plenty of things that can open it that don't use toggle
	. = ..()
	update_icon()

// TODO rewrite to use parent call and proper closet icon stuff.
/obj/structure/closet/secure_closet/guncabinet/on_update_icon()
	cut_overlays()
	if(opened)
		add_overlay("door_open")
	else
		var/lazors = 0
		var/shottas = 0
		for (var/obj/item/gun/G in contents)
			if (istype(G, /obj/item/gun/energy))
				lazors++
			if (istype(G, /obj/item/gun/projectile/))
				shottas++
		for (var/i = 0 to 2)
			if(lazors || shottas) // only make icons if we have one of the two types.
				var/image/gun = image(icon(src.icon))
				if (lazors > shottas)
					lazors--
					gun.icon_state = "laser"
				else if (shottas)
					shottas--
					gun.icon_state = "projectile"
				gun.pixel_x = i*4
				overlays += gun

		add_overlay("door")

		if(welded)
			add_overlay("welded")

		if(!broken)
			if(locked)
				add_overlay("locked")
			else
				add_overlay("open")

// Subtypes
/obj/structure/closet/secure_closet/guncabinet/sidearm
	name = "emergency weapon cabinet"
	req_access = list(
		access_armory,
		access_captain
	)

/obj/structure/closet/secure_closet/guncabinet/sidearm/WillContain()
	return list(
		/obj/item/gun/energy/gun = 4
	)
