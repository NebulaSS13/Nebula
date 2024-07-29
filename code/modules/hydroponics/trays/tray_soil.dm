/obj/machinery/portable_atmospherics/hydroponics/soil
	name = "tilled soil"
	desc = "A mound of earth. You could plant some seeds here."
	icon_state = "soil"
	density = FALSE
	use_power = POWER_USE_OFF
	stat_immune = NOINPUT | NOSCREEN | NOPOWER
	mechanical = 0
	tray_light = 0
	matter = null
	pixel_z = 8
	color = "#7c5e42"
	var/obj/item/stack/material/brick/reinforced_with

/obj/machinery/portable_atmospherics/hydroponics/soil/Initialize()

	. = ..()

	verbs -= /obj/machinery/portable_atmospherics/hydroponics/verb/close_lid_verb
	verbs -= /obj/machinery/portable_atmospherics/hydroponics/verb/setlight

	if(isturf(loc))
		var/turf/turf = loc
		color = turf.get_soil_color()

	pixel_x = rand(-1,1)
	pixel_y = rand(-1,1)
	update_icon()

/obj/machinery/portable_atmospherics/hydroponics/soil/physically_destroyed()
	if(reinforced_with)
		reinforced_with.dropInto(loc)
		reinforced_with = null
	return ..()

/obj/machinery/portable_atmospherics/hydroponics/soil/Destroy()
	var/oldloc = loc
	QDEL_NULL(reinforced_with)
	. = ..()
	if(oldloc)
		for(var/obj/machinery/portable_atmospherics/hydroponics/soil/neighbor in orange(1, oldloc))
			neighbor.update_icon()

/obj/machinery/portable_atmospherics/hydroponics/soil/Crossed(atom/movable/AM)
	. = ..()
	if(!istype(AM) || !ismob(AM) || !AM.simulated || !seed || dead)
		return
	var/mob/walker = AM
	if(walker.mob_size < MOB_SIZE_SMALL)
		return
	if(MOVING_DELIBERATELY(walker) && prob(90))
		return
	if(prob(25))
		return
	to_chat(walker, SPAN_DANGER("You trample \the [seed]!"))
	plant_health = max(0, plant_health - rand(3,5))
	check_plant_health()

/obj/machinery/portable_atmospherics/hydroponics/soil/Process()
	. = ..()
	if(. == PROCESS_KILL || QDELETED(src))
		return
	var/turf/my_turf = get_turf(src)
	if(!istype(my_turf))
		return
	if(closed_system || !reagents || waterlevel >= 100)
		return
	if((reagents.maximum_volume - reagents.total_volume) <= 0 || reagents.total_volume >= 10)
		return
	for(var/step_dir in global.alldirs)
		var/turf/neighbor = get_step_resolving_mimic(src, step_dir)
		if(neighbor == my_turf || !neighbor?.reagents?.total_volume || !Adjacent(neighbor))
			continue
		neighbor.reagents.trans_to_obj(src, rand(2,3))
		if((reagents.maximum_volume - reagents.total_volume) <= 0 || reagents.total_volume >= 10)
			break
	return ..()

/obj/machinery/portable_atmospherics/hydroponics/soil/attackby(var/obj/item/O, var/mob/user)

	if(istype(O, /obj/item/stack/material/brick))
		if(reinforced_with)
			to_chat(user, SPAN_WARNING("\The [src] has already been fenced with bricks."))
			return TRUE
		var/obj/item/stack/material/brick/bricks = O
		if(bricks.get_amount() < 4)
			to_chat(user, SPAN_WARNING("You need at least four bricks to fence off \the [src]."))
			return TRUE

		var/obj/item/stack/material/brick/new_bricks = bricks.split(5)
		if(!QDELETED(new_bricks) && istype(new_bricks) && new_bricks.get_amount() >= 4)
			reinforced_with = new_bricks
			to_chat(user, SPAN_NOTICE("You fence \the [src] off with \the [reinforced_with]."))
			update_icon()
			for(var/obj/machinery/portable_atmospherics/hydroponics/soil/neighbor in orange(1, loc))
				neighbor.update_icon()
		return TRUE

	if(!seed && user.a_intent == I_HURT && (IS_SHOVEL(O) || IS_HOE(O)))
		var/use_tool = O.get_tool_quality(TOOL_SHOVEL) > O.get_tool_quality(TOOL_HOE) ? TOOL_SHOVEL : TOOL_HOE
		if(use_tool)
			if(O.do_tool_interaction(use_tool, user, src, 3 SECONDS, "filling in", "filling in", check_skill = SKILL_BOTANY))
				qdel(src)
			return TRUE
	if(istype(O, /obj/item/tank))
		return TRUE
	return ..()

/obj/machinery/portable_atmospherics/hydroponics/soil/on_update_icon()
	. = ..()
	if(reinforced_with)
		for(var/step_dir in global.cardinal)
			var/obj/machinery/portable_atmospherics/hydroponics/soil/neighbor = locate() in get_step_resolving_mimic(loc, step_dir)
			if(istype(neighbor) && neighbor.reinforced_with)
				continue
			var/image/I = image(icon, "bricks", dir = step_dir)
			I.color = reinforced_with.get_color()
			I.appearance_flags |= RESET_COLOR
			I.pixel_x = -(pixel_x)
			I.pixel_y = -(pixel_y)
			I.pixel_z = -(pixel_z)
			add_overlay(I)

/obj/machinery/portable_atmospherics/hydroponics/soil/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return TRUE
	. = ..()
	if(. && reinforced_with)
		var/obj/machinery/portable_atmospherics/hydroponics/soil/neighbor = locate() in get_turf(mover)
		if(!neighbor?.reinforced_with)
			return FALSE

// Holder for vine plants.
// Icons for plants are generated as overlays, so setting it to invisible wouldn't work.
// Hence using a blank icon.
/obj/machinery/portable_atmospherics/hydroponics/soil/invisible
	name = "plant"
	desc = null
	icon_state = "blank"
	is_spawnable_type = FALSE
	var/list/connected_zlevels //cached for checking if we someone is obseving us so we should process

/obj/machinery/portable_atmospherics/hydroponics/soil/is_burnable()
	return ..() && seed.get_trait(TRAIT_HEAT_TOLERANCE) < 1000

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/Initialize(mapload,var/datum/seed/newseed, var/start_mature)
	. = ..(mapload) // avoid passing newseed as dir
	seed = newseed
	if(!seed)
		return INITIALIZE_HINT_QDEL
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

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/harvest(mob/user)
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