/obj/abstract/ministation/random_asteroid_spawner/
	name = "random asteroid spawner"
	icon = 'icons/misc/mark.dmi'
	icon_state = "X"
	color = COLOR_PURPLE
	alpha = 255 //so it's not invisible in map editor

/obj/abstract/ministation/random_asteroid_spawner/Initialize()
	..()
	. = INITIALIZE_HINT_LATELOAD

/obj/abstract/ministation/random_asteroid_spawner/LateInitialize(var/ml)
	var/turf/space/thisturf = src.loc
	if(prob(1) && istype(thisturf)) //if this turf is space there is a one percent chance of turning it into an asteroid.
		generate_asteroid(70, thisturf.ChangeTurf(/turf/exterior/wall/random/ministation)) //turn the turf into an asteroid wall and call generate asteroid on it, which will generate more walls around it.
	qdel(src)

//tries to convert the space turfs around the asteroid into asteroids.
/obj/abstract/ministation/random_asteroid_spawner/proc/generate_asteroid(var/probability, var/turf/sourceasteroid)
	for(var/ndir in global.cardinal)
		var/turf/ad = get_step(sourceasteroid, ndir)
		if(prob(probability))
			if(istype(ad, /turf/space)) //if it's space turn it into asteroid
				//newasteroid = ad.ChangeTurf(/turf/exterior/wall/random/ministation)
				generate_asteroid(max(10,probability-10), ad.ChangeTurf(/turf/exterior/wall/random/ministation)) //reduce the probability of conversion with 10 percent for each turf away from the starting one.

/turf/exterior/wall/random/ministation/get_weighted_mineral_list()
	if(prob(80))
		. = list()
	else if(prob(75))
		if(strata_override)
			var/decl/strata/strata_info = GET_DECL(strata_override)
			. = strata_info.ores_sparse
		if(!.)
			. = SSmaterials.weighted_minerals_sparse
	else
		if(strata_override)
			var/decl/strata/strata_info = GET_DECL(strata_override)
			. = strata_info.ores_rich
		if(!.)
			. = SSmaterials.weighted_minerals_rich

//trash bins
/decl/closet_appearance/crate/ministation
	decals = null
	extra_decals = null
	base_icon =  'bin.dmi'
	decal_icon = 'icons/obj/closets/decals/crate.dmi'
	color = COLOR_WHITE

/obj/structure/closet/crate/bin/ministation
	name = "garbage bin"
	desc = "A large bin for putting trash in."
	icon = 'bin.dmi'
	icon_state = "base"
	closet_appearance = /decl/closet_appearance/crate/ministation
	storage_types = CLOSET_STORAGE_MOBS | CLOSET_STORAGE_ITEMS

//suit cyclers
/obj/machinery/suit_cycler/ministation //this one goes in eva
	req_access = list()
	suit = /obj/item/clothing/suit/space
	helmet = /obj/item/clothing/head/helmet/space

/obj/machinery/suit_cycler/engineering/ministation
	suit = /obj/item/clothing/suit/space/void/engineering
	helmet = /obj/item/clothing/head/helmet/space/void/engineering
	boots = /obj/item/clothing/shoes/magboots

/obj/machinery/suit_cycler/mining/ministation
	suit = /obj/item/clothing/suit/space/void/mining
	helmet = /obj/item/clothing/head/helmet/space/void/mining
	boots = /obj/item/clothing/shoes/magboots

/obj/structure/closet/medical_wall/ministation/WillContain() // for common area, has slightly less than normal
	return list(
		/obj/random/firstaid,
		/obj/random/medical/lite = 8)

/obj/machinery/vending/assist/ministation/Initialize() //vending machines found in maint tunnels
	. = ..()
	contraband += list(/obj/item/multitool = 1)

//cameras
/obj/machinery/camera/network/ministation/sat
	preset_channels = list("Satellite")

/obj/machinery/camera/motion/ministation
	preset_channels = list("Satellite")

//Detective bs
/obj/item/camera_film/high
	name = "high capacity film cartridge"
	max_uses  = 30
	uses_left = 30

/obj/item/camera/detective
	name = "detective's camera"
	desc = "A single use disposable polaroid photo camera."

/obj/item/camera/detective/Initialize()
	. = ..()
	film = new /obj/item/camera_film/high(src)

/obj/item/camera/detective/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/camera_film))
		return FALSE //Prevent reloading
	return ..()

/obj/item/camera/detective/eject_film(mob/user)
	return

/obj/item/camera/detective/get_alt_interactions(mob/user)
	. = ..()
	LAZYREMOVE(., /decl/interaction_handler/camera_eject_film)
