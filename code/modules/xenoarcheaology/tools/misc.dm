/obj/structure/bookcase/manuals/xenoarchaeology
	name = "Xenoarchaeology Manuals bookcase"

/obj/structure/bookcase/manuals/xenoarchaeology/WillContain()
	return list(
		/obj/item/book/manual/excavation,
		/obj/item/book/manual/mass_spectrometry,
		/obj/item/book/manual/materials_chemistry_analysis,
		/obj/item/book/manual/anomaly_testing,
		/obj/item/book/manual/anomaly_spectroscopy,
		/obj/item/book/manual/stasis,
	)

/obj/structure/closet/secure_closet/xenoarchaeologist
	name = "Xenoarchaeologist Locker"
	req_access = list(access_xenoarch)
	closet_appearance = /decl/closet_appearance/secure_closet/expedition/science

/obj/structure/closet/secure_closet/xenoarchaeologist/WillContain()
	return list(
		new /datum/atom_creator/simple(/obj/item/storage/backpack/toxins,    50),
		new /datum/atom_creator/simple(/obj/item/storage/backpack/dufflebag, 50),
		/obj/item/clothing/under/color/white,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/shoes/color/white,
		/obj/item/clothing/glasses/science,
		/obj/item/radio/headset/headset_sci,
		/obj/item/clothing/mask/gas,
		/obj/item/clipboard,
		/obj/item/storage/belt/archaeology,
		/obj/item/storage/excavation,
		/obj/item/stack/tape_roll/barricade_tape/research,
	)

/obj/structure/closet/excavation
	name = "excavation tools"
	closet_appearance = /decl/closet_appearance/secure_closet/engineering/tools

/obj/structure/closet/excavation/WillContain()
	return list(
		/obj/item/storage/belt/archaeology,
		/obj/item/storage/excavation,
		/obj/item/flashlight/lantern,
		/obj/item/ano_scanner,
		/obj/item/depth_scanner,
		/obj/item/core_sampler,
		/obj/item/gps,
		/obj/item/pinpointer/radio,
		/obj/item/clothing/glasses/meson,
		/obj/item/pickaxe,
		/obj/item/measuring_tape,
		/obj/item/pickaxe/xeno/hand,
		/obj/item/storage/bag/fossils,
		/obj/item/hand_labeler,
		/obj/item/stack/tape_roll/barricade_tape/research,
	)

/obj/machinery/alarm/isolation
	req_access = list(list(access_research, access_atmospherics, access_engine_equip))

/obj/machinery/alarm/monitor/isolation
	req_access = list(list(access_research, access_atmospherics, access_engine_equip))

//
// Archeology designs
//

//Structures
/decl/material/solid/metal/chromium/generate_recipes(reinforce_material)
	. = ..()
	. += /datum/stack_recipe/structure/anomaly_container

/datum/stack_recipe/structure/anomaly_container
	title               = "anomaly container"
	result_type         = /obj/structure/anomaly_container
	time                = 10 SECONDS
	one_per_turf        = TRUE
	on_floor            = TRUE
	difficulty          = MAT_VALUE_VERY_HARD_DIY
	apply_material_name = FALSE

//Devices
/datum/fabricator_recipe/protolathe/tool/anomaly_battery
	path = /obj/item/anobattery

/datum/fabricator_recipe/protolathe/tool/anomaly_device
	path = /obj/item/anodevice

/datum/fabricator_recipe/protolathe/tool/depth_scanner
	path = /obj/item/depth_scanner

/datum/fabricator_recipe/protolathe/tool/core_sampler
	path = /obj/item/core_sampler

//Tools
/datum/fabricator_recipe/protolathe/tool/measuring_tape
	path = /obj/item/measuring_tape

/datum/fabricator_recipe/protolathe/tool/hand_pickaxe
	path = /obj/item/pickaxe/xeno/hand

/datum/fabricator_recipe/protolathe/tool/xeno_brush
	path = /obj/item/pickaxe/xeno/brush

/datum/fabricator_recipe/protolathe/tool/xeno_pick_one
	path = /obj/item/pickaxe/xeno/one_pick

/datum/fabricator_recipe/protolathe/tool/xeno_pick_two
	path = /obj/item/pickaxe/xeno/two_pick

/datum/fabricator_recipe/protolathe/tool/xeno_pick_three
	path = /obj/item/pickaxe/xeno/three_pick

/datum/fabricator_recipe/protolathe/tool/xeno_pick_four
	path = /obj/item/pickaxe/xeno/four_pick

/datum/fabricator_recipe/protolathe/tool/xeno_pick_five
	path = /obj/item/pickaxe/xeno/five_pick

/datum/fabricator_recipe/protolathe/tool/xeno_pick_six
	path = /obj/item/pickaxe/xeno/six_pick

//Clothes
/datum/fabricator_recipe/textiles/protective/bio_hood_anomaly
	path = /obj/item/clothing/head/bio_hood/anomaly

/datum/fabricator_recipe/textiles/protective/bio_suit_anomaly
	path = /obj/item/clothing/suit/bio_suit/anomaly

/datum/fabricator_recipe/textiles/space/excavation_helmet
	path = /obj/item/clothing/head/helmet/space/void/excavation

/datum/fabricator_recipe/textiles/space/excavation
	path = /obj/item/clothing/suit/space/void/excavation

//Bags
/datum/fabricator_recipe/textiles/storage/fossils_bag
	path = /obj/item/storage/bag/fossils

/datum/fabricator_recipe/textiles/storage/archeology_tool_belt
	path = /obj/item/storage/belt/archaeology

/datum/fabricator_recipe/textiles/storage/excavation_bag
	path = /obj/item/storage/excavation/empty
