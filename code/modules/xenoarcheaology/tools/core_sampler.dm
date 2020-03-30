/obj/item/core_sampler
	name = "core sampler"
	desc = "Used to extract geological core samples."
	icon = 'icons/obj/items/geologic_sampler.dmi'
	icon_state = "sampler0"
	item_state = "screwdriver_brown"
	w_class = ITEM_SIZE_TINY

	var/obj/item/evidencebag/filled_bag

/obj/item/core_sampler/examine(mob/user, distance)
	. = ..(user)
	if(distance <= 2)
		to_chat(user, SPAN_NOTICE("This one is [filled_bag ? "full" : "empty"]"))

/obj/item/core_sampler/proc/sample_item(var/item_to_sample, var/mob/user)
	var/datum/geosample/geo_data

	if(istype(item_to_sample, /turf/simulated/mineral))
		var/turf/simulated/mineral/T = item_to_sample
		geo_data = T.get_geodata()
	else if(istype(item_to_sample, /obj/item/ore))
		var/obj/item/ore/O = item_to_sample
		geo_data = O.geologic_data

	if(geo_data)
		if(filled_bag)
			to_chat(user, SPAN_WARNING("The core sampler is full."))
		else
			//create a new sample bag which we'll fill with rock samples
			filled_bag = new /obj/item/evidencebag/sample(src)
			var/obj/item/rocksliver/R = new(filled_bag, geo_data)
			filled_bag.store_item(R)
			update_icon()

			to_chat(user, SPAN_NOTICE("You take a core sample of the [item_to_sample]."))
	else
		to_chat(user, SPAN_WARNING("You are unable to take a geological sample of [item_to_sample]."))

/obj/item/core_sampler/on_update_icon()
	icon_state = "sampler[!!filled_bag]"

/obj/item/core_sampler/attack_self(var/mob/living/user)
	if(filled_bag)
		to_chat(user, SPAN_NOTICE("You eject the full sample bag."))
		user.put_in_hands(filled_bag)
		filled_bag = null
		update_icon()
	else
		to_chat(user, SPAN_WARNING("The core sampler is empty."))

/obj/item/evidencebag/sample
	name = "sample bag"
	desc = "A bag for holding research samples."
	
/obj/item/rocksliver
	name = "rock sliver"
	desc = "It looks extremely delicate."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "sliver1"
	randpixel = 8
	w_class = ITEM_SIZE_TINY
	sharp = 1
	var/datum/geosample/geologic_data

/obj/item/rocksliver/Initialize(mapload, geodata)
	. = ..()
	icon_state = "sliver[rand(1, 3)]"
	geologic_data = geodata
