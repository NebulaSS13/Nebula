
/obj/item/ore/strangerock
	name = "strange rock"
	desc = "Seems to have some unusal strata evident throughout it."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "strange"
	origin_tech = "{'materials':5}"
	var/obj/item/inside

/obj/item/ore/strangerock/Initialize(mapload, var/find_type = 0)
	. = ..(mapload)
	if(find_type)
		var/decl/archaeological_find/find = GET_DECL(find_type)
		inside = find.create_find(src)

/obj/item/ore/strangerock/Destroy()
	QDEL_NULL(inside)
	. = ..()
	
/obj/item/ore/strangerock/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/pickaxe/xeno/brush))
		if(inside)
			inside.dropInto(loc)
			visible_message(SPAN_NOTICE("\The [src] is brushed away, revealing \the [inside]."))
		else
			visible_message(SPAN_NOTICE("\The [src] is brushed away into nothing."))
		qdel(src)
		return

	if(isWelder(I))
		var/obj/item/weldingtool/W = I
		if(W.isOn())
			if(W.remove_fuel(2))
				if(inside)
					inside.dropInto(loc)
					visible_message(SPAN_NOTICE("\The [src] burns away revealing \the [inside]."))
				else
					visible_message(SPAN_NOTICE("\The [src] burns away into nothing."))
				qdel(src)
			else
				visible_message(SPAN_NOTICE("A few sparks fly off \the [src], but nothing else happens."))
			return

	else if(istype(I, /obj/item/core_sampler))
		var/obj/item/core_sampler/S = I
		S.sample_item(src, user)
		return

	..()

/obj/item/ore/strangerock/bash()
	if(prob(33))
		visible_message(SPAN_WARNING("[src] crumbles away, leaving some dust and gravel behind."))
		qdel(src)
