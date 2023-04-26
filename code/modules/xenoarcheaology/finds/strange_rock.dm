
/obj/item/strangerock
	name        = "strange rock"
	desc        = "Seems to have some unusal strata evident throughout it."
	icon        = 'icons/obj/xenoarchaeology.dmi'
	icon_state  = "strange"
	origin_tech = "{'materials':5}"
	material    = /decl/material/solid/stone/sandstone
	var/obj/item/inside

/obj/item/strangerock/Initialize(mapload, var/find_type = 0)
	. = ..(mapload)
	if(find_type)
		var/decl/archaeological_find/find = GET_DECL(find_type)
		inside = find.create_find(src)

/obj/item/strangerock/Destroy()
	QDEL_NULL(inside)
	. = ..()

/obj/item/strangerock/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/pickaxe/xeno/brush))
		if(inside)
			inside.dropInto(loc)
			visible_message(SPAN_NOTICE("\The [src] is brushed away, revealing \the [inside]."))
			inside = null
		else
			visible_message(SPAN_NOTICE("\The [src] is brushed away into nothing."))
		physically_destroyed()
		return TRUE

	if(IS_WELDER(I))
		var/obj/item/weldingtool/W = I
		if(W.isOn())
			if(W.weld(2))
				if(inside)
					inside.dropInto(loc)
					visible_message(SPAN_NOTICE("\The [src] burns away revealing \the [inside]."))
					inside = null
				else
					visible_message(SPAN_NOTICE("\The [src] burns away into nothing."))
				physically_destroyed()
			else
				visible_message(SPAN_NOTICE("A few sparks fly off \the [src], but nothing else happens."))
			return TRUE

	else if(istype(I, /obj/item/core_sampler))
		var/obj/item/core_sampler/S = I
		S.sample_item(src, user)
		return TRUE

	return ..()

/obj/item/strangerock/bash()
	if(prob(33))
		visible_message(SPAN_WARNING("[src] crumbles away, leaving some dust and gravel behind."))
		physically_destroyed()
