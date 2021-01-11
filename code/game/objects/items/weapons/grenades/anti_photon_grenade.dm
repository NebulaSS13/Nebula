/obj/item/grenade/anti_photon
	desc = "An experimental device for temporarily removing light in a limited area."
	name = "photon disruption grenade"
	icon = 'icons/obj/items/grenades/grenade_light.dmi'
	det_time = 20
	origin_tech = "{'wormholes':4,'materials':4}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)

/obj/item/grenade/anti_photon/detonate()
	playsound(src.loc, 'sound/effects/phasein.ogg', 50, 1, 5)
	set_light(-1, 6, 10, 2, "#ffffff")
	addtimer(CALLBACK(src, .proc/finish), rand(20 SECONDS, 29 SECONDS))

/obj/item/grenade/anti_photon/proc/finish()
	set_light(1, 1, 10, 2, "#[num2hex(rand(64,255))][num2hex(rand(64,255))][num2hex(rand(64,255))]")
	playsound(loc, 'sound/effects/bang.ogg', 50, 1, 5)
	sleep(1 SECOND)
	qdel(src)