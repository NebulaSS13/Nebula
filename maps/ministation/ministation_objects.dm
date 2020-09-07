/turf/simulated/wall/natural/random/ministation/get_weighted_mineral_list()
	if(prob(80))	
		. = list()
	else if(prob(75))
		if(strata)
			var/decl/strata/strata_info = decls_repository.get_decl(strata)
			. = strata_info.ores_sparse
		if(!.)
			. = SSmaterials.weighted_minerals_sparse
	else
		if(strata)
			var/decl/strata/strata_info = decls_repository.get_decl(strata)
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
	network = list("Satellite")

/obj/machinery/camera/motion/ministation
	network = list("Satellite")