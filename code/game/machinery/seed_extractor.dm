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
	stat_immune = 0

/obj/machinery/seed_extractor/attackby(var/obj/item/O, var/mob/user)

	if((. = component_attackby(O, user)))
		return

	// Fruits and vegetables.
	if(istype(O, /obj/item/food/grown))
		if(!user.try_unequip(O))
			return TRUE
		var/obj/item/food/grown/F = O
		if(!F.seed)
			to_chat(user, SPAN_WARNING("\The [O] doesn't seem to have any usable seeds inside it."))
			return TRUE
		to_chat(user, SPAN_NOTICE("You extract some seeds from [O]."))
		for(var/i = 1 to rand(1,4))
			new /obj/item/seeds/modified(get_turf(src), null, F.seed)
		qdel(O)
		return TRUE

	//Grass.
	if(istype(O, /obj/item/stack/tile/grass))
		var/obj/item/stack/tile/grass/S = O
		if (S.use(1))
			to_chat(user, SPAN_NOTICE("You extract some seeds from the grass tile."))
			new /obj/item/seeds/grassseed(loc)
		return TRUE

	if(istype(O, /obj/item/fossil/plant)) // Fossils
		var/obj/item/seeds/random/R = new(get_turf(src))
		to_chat(user, SPAN_NOTICE("\The [src] scans \the [O] and spits out \a [R]."))
		qdel(O)
		return TRUE

	return ..()
