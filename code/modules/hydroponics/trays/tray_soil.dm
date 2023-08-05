/obj/machinery/portable_atmospherics/hydroponics/soil
	name = "soil"
	desc = "A mound of earth. You could plant some seeds here."
	icon_state = "soil"
	density = FALSE
	use_power = POWER_USE_OFF
	stat_immune = NOINPUT | NOSCREEN | NOPOWER
	mechanical = 0
	tray_light = 0
	matter = null

/obj/machinery/portable_atmospherics/hydroponics/soil/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/tank))
		return
	else
		..()

/obj/machinery/portable_atmospherics/hydroponics/soil/Initialize()
	. = ..()
	verbs -= /obj/machinery/portable_atmospherics/hydroponics/verb/close_lid_verb
	verbs -= /obj/machinery/portable_atmospherics/hydroponics/verb/setlight

// Holder for vine plants.
// Icons for plants are generated as overlays, so setting it to invisible wouldn't work.
// Hence using a blank icon.
/obj/machinery/portable_atmospherics/hydroponics/soil/invisible
	name = "plant"
	desc = null
	icon = 'icons/obj/seeds.dmi'
	icon_state = "blank"
	var/list/connected_zlevels //cached for checking if we someone is obseving us so we should process

/obj/machinery/portable_atmospherics/hydroponics/soil/is_burnable()
	return ..() && seed.get_trait(TRAIT_HEAT_TOLERANCE) < 1000

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/Initialize(mapload,var/datum/seed/newseed, var/start_mature)
	. = ..(mapload) // avoid passing newseed as dir
	seed = newseed
	dead = 0
	age = start_mature ? seed.get_trait(TRAIT_MATURATION) : 1
	plant_health = seed.get_trait(TRAIT_ENDURANCE)
	lastcycle = world.time
	if(isnull(default_pixel_y))
		default_pixel_y = rand(-12,12)
	if(isnull(default_pixel_y))
		default_pixel_x = rand(-12,12)
	reset_offsets(0)
	if(seed)
		name = seed.display_name
	check_plant_health()
	connected_zlevels = SSmapping.get_connected_levels(z)

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/Process()
	if(!seed)
		qdel_self()
		return
	if(isStationLevel(z)) //plants on station always tick
		return ..()
	if(living_observers_present(connected_zlevels))
		return ..()

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/remove_dead(mob/user, silent)
	..()
	qdel(src)

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/harvest()
	..()
	if(!seed) // Repeat harvests are a thing.
		qdel(src)

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/die()
	qdel(src)

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/Destroy()
	// Check if we're masking a decal that needs to be visible again.
	for(var/obj/effect/vine/plant in get_turf(src))
		if(plant.invisibility == INVISIBILITY_MAXIMUM)
			plant.set_invisibility(initial(plant.invisibility))
	. = ..()