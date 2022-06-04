/turf/exterior/wall/random/ministation/
	var/starting = FALSE //if the turf was there on mapload
	var/guaranteed = FALSE //only matters for starting turfs. it is guaranteed to be not deleted on mapload.
	var/generatepercent = 70 //the percentage chance tof each surrounding turf turning into asteroids

/turf/exterior/wall/random/ministation/get_weighted_mineral_list()
	if(prob(80))
		. = list()
	else if(prob(75))
		if(strata)
			var/decl/strata/strata_info = GET_DECL(strata)
			. = strata_info.ores_sparse
		if(!.)
			. = SSmaterials.weighted_minerals_sparse
	else
		if(strata)
			var/decl/strata/strata_info = GET_DECL(strata)
			. = strata_info.ores_rich
		if(!.)
			. = SSmaterials.weighted_minerals_rich

/turf/exterior/wall/random/ministation/Initialize(var/ml, var/materialtype, var/rmaterialtype)
	..(ml, materialtype, rmaterialtype)
	if(ml)
		starting = TRUE
	. = INITIALIZE_HINT_LATELOAD

/turf/exterior/wall/random/ministation/LateInitialize()
	if(starting) //only need to call generate_asteroid here if this is a first node, the others are called in the generate_asteroid function
		if(prob(99) && !guaranteed) //99% chance that the asteroid turns into space
			ChangeTurf(/turf/space)
		else //otherwise, try to convert the turfs in the cardinal direction into asteroid as well
			generate_asteroid(generatepercent)
	. = ..()

//tries to convert the space turfs around the asteroid into asteroids as well and tries to keep already existing asteroids around it from deleting in mapload.
/turf/exterior/wall/random/ministation/proc/generate_asteroid(var/probability)
	var/turf/exterior/wall/random/ministation/newasteroid
	for(var/ndir in global.cardinal)
		var/turf/ad = get_step(src, ndir)
		if(prob(probability))
			if(istype(ad, /turf/space)) //if it's space turn it into asteroid
				newasteroid = ad.ChangeTurf(/turf/exterior/wall/random/ministation)
				newasteroid.generate_asteroid(max(10,probability-10)) //reduce the probability of conversion with 10 percent for each turf away from the starting one.
			if(istype(ad, /turf/exterior/wall/random/ministation)) //if it's asteroid prevent it from being deleted in it's own LateInitialize proc.
				newasteroid = ad
				newasteroid.guaranteed = TRUE
				newasteroid.generatepercent = max(10,probability-10) //reduce the probability of conversion with 10 percent for each turf away from the starting one.
		

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