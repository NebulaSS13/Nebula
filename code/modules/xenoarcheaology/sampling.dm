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

/datum/geosample
	var/age = 0
	var/age_thousand = 0
	var/age_million = 0
	var/age_billion = 0
	var/artifact_id = ""
	var/artifact_distance = -1
	var/source_mineral = /datum/reagent/toxin/chlorine
	var/list/find_presence = list()

/datum/geosample/New(var/turf/simulated/mineral/container)
	UpdateTurf(container)

/datum/geosample/proc/UpdateTurf(var/turf/simulated/mineral/container)
	if(!istype(container))
		return

	age = rand(1, 999)

	if(container.mineral)
		if(islist(container.mineral.xarch_ages))
			var/list/ages = container.mineral.xarch_ages
			if(ages["thousand"])
				age_thousand = rand(1, ages["thousand"])
			if(ages["million"])
				age_million = rand(1, ages["million"])
			if(ages["billion"])
				if(ages["billion_lower"])
					age_billion = rand(ages["billion_lower"], ages["billion"])
				else
					age_billion = rand(1, ages["billion"])
		if(container.mineral.xarch_source_mineral)
			source_mineral = container.mineral.xarch_source_mineral

	if(prob(75))
		find_presence[/datum/reagent/phosphorus] = rand(1, 500) / 100
	if(prob(25))
		find_presence[/datum/reagent/mercury] = rand(1, 500) / 100
	find_presence[/datum/reagent/toxin/chlorine] = rand(500, 2500) / 100

	for(var/datum/find/F in container.finds)
		var/responsive_reagent = get_responsive_reagent(F.find_type)
		find_presence[responsive_reagent] = F.dissonance_spread

	var/total_presence = 0
	for(var/carrier in find_presence)
		total_presence += find_presence[carrier]
	for(var/carrier in find_presence)
		find_presence[carrier] = find_presence[carrier] / total_presence

/datum/geosample/proc/UpdateNearbyArtifactInfo(var/turf/simulated/mineral/container)
	if(!container || !istype(container))
		return

	if(container.artifact_find)
		artifact_distance = rand()
		artifact_id = container.artifact_find.artifact_id
	else
		for(var/turf/simulated/mineral/T in SSxenoarch.artifact_spawning_turfs)
			if(T.artifact_find)
				var/cur_dist = get_dist(container, T) * 2
				if( (artifact_distance < 0 || cur_dist < artifact_distance))
					artifact_distance = cur_dist + rand() * 2 - 1
					artifact_id = T.artifact_find.artifact_id
			else
				SSxenoarch.artifact_spawning_turfs.Remove(T)

/obj/item/core_sampler
	name = "core sampler"
	desc = "Used to extract geological core samples."
	icon = 'icons/obj/items.dmi'
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