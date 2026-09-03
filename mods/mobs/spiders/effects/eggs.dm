/obj/effect/spider/eggcluster
	name = "egg cluster"
	desc = "They seem to pulse slightly with an inner life."
	icon_state = "eggs"
	var/grown_type = /obj/effect/spider/spiderling
	var/amount_grown = 0

/obj/effect/spider/eggcluster/Initialize(mapload, atom/parent)
	. = ..()
	color = parent?.color || color
	pixel_x = rand(3,-3)
	pixel_y = rand(3,-3)
	START_PROCESSING(SSobj, src)

/obj/effect/spider/eggcluster/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(istype(loc, /obj/item/organ/external))
		var/obj/item/organ/external/O = loc
		LAZYREMOVE(O.implants, src)
	. = ..()

/obj/effect/spider/eggcluster/Process()

	if(!loc)
		qdel(src)
		return

	if(prob(80))
		amount_grown += rand(0,2)

	if(amount_grown >= 100)
		var/num = rand(3,9)
		if(istype(loc, /obj/item/organ/external))
			var/obj/item/organ/external/O = loc
			for(var/i=0, i<num, i++)
				LAZYADD(O.implants, new grown_type(O, src))
		else
			new grown_type(loc, src)
		qdel(src)
