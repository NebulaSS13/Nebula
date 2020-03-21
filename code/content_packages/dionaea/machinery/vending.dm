/obj/machinery/vending
	var/diona_spawn_chance = 0.1

/obj/machinery/vending/finish_vending()
	if(prob(diona_spawn_chance)) //Hehehe
		var/mob/living/carbon/alien/diona/S = new(get_turf(src))
		visible_message(SPAN_NOTICE("\The [src] makes an odd grinding noise before coming to a halt as \a [S.name] slithers out of the receptacle."))
		return
	..()

/obj/machinery/vending/dinnerware/Initialize(mapload, d, populate_parts)
	products[/obj/item/storage/lunchbox/nymph] = 3
	. = ..()

/obj/machinery/vending/hydroseeds/Initialize(mapload, d, populate_parts)
	products[/obj/item/seeds/diona] = 3
	. = ..()
