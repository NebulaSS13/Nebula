/obj/machinery/seed_extractor
	name = "seed extractor"
	desc = "Extracts and bags seeds from produce."
	icon = 'icons/obj/hydroponics/hydroponics_machines.dmi'
	icon_state = "sextractor"
	density = TRUE
	anchored = TRUE
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 10
	active_power_usage = 2000
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null

/obj/machinery/seed_extractor/attackby(var/obj/item/used_item, var/mob/user)

	// Fruits and vegetables.
	if(istype(used_item, /obj/item/food/grown))
		if(!user.try_unequip(used_item))
			return TRUE
		var/obj/item/food/grown/F = used_item
		if(!F.seed)
			to_chat(user, SPAN_WARNING("\The [used_item] doesn't seem to have any usable seeds inside it."))
			return TRUE
		to_chat(user, SPAN_NOTICE("You extract some seeds from [used_item]."))
		for(var/i = 1 to rand(1,4))
			new /obj/item/seeds/modified(get_turf(src), null, F.seed)
		qdel(used_item)
		return TRUE

	//Grass.
	if(istype(used_item, /obj/item/stack/tile/grass))
		var/obj/item/stack/tile/grass/S = used_item
		if (S.use(1))
			to_chat(user, SPAN_NOTICE("You extract some seeds from the grass tile."))
			new /obj/item/seeds/grassseed(loc)
		return TRUE

	if(istype(used_item, /obj/item/fossil/plant)) // Fossils
		to_chat(user, SPAN_NOTICE("\The [src] scans \the [used_item] and spits out \a [new /obj/item/seeds/random(get_turf(src))]."))
		qdel(used_item)
		return TRUE

	return ..()
