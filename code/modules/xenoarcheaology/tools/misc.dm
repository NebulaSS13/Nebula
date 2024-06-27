/obj/structure/bookcase/manuals/xenoarchaeology
	name = "Xenoarchaeology Manuals bookcase"

/obj/structure/bookcase/manuals/xenoarchaeology/WillContain()
	return list(
		/obj/item/book/manual/excavation,
		/obj/item/book/manual/mass_spectrometry,
		/obj/item/book/fluff/materials_chemistry_analysis,
		/obj/item/book/fluff/anomaly_testing,
		/obj/item/book/fluff/anomaly_spectroscopy,
		/obj/item/book/fluff/stasis,
	)

/obj/structure/closet/secure_closet/xenoarchaeologist
	name = "Xenoarchaeologist Locker"
	req_access = list(access_xenoarch)
	closet_appearance = /decl/closet_appearance/secure_closet/expedition/science

/obj/structure/closet/secure_closet/xenoarchaeologist/WillContain()
	return list(
		new /datum/atom_creator/simple(/obj/item/backpack/toxins,    50),
		new /datum/atom_creator/simple(/obj/item/backpack/dufflebag, 50),
		/obj/item/clothing/jumpsuit/white,
		/obj/item/clothing/suit/toggle/labcoat,
		/obj/item/clothing/shoes/color/white,
		/obj/item/clothing/glasses/science,
		/obj/item/radio/headset/headset_sci,
		/obj/item/clothing/mask/gas,
		/obj/item/clipboard,
		/obj/item/belt/archaeology,
		/obj/item/excavation,
		/obj/item/stack/tape_roll/barricade_tape/research,
	)

/obj/structure/closet/excavation
	name = "excavation tools"
	closet_appearance = /decl/closet_appearance/secure_closet/engineering/tools

/obj/structure/closet/excavation/WillContain()
	return list(
		/obj/item/belt/archaeology,
		/obj/item/excavation,
		/obj/item/flashlight/lantern,
		/obj/item/ano_scanner,
		/obj/item/depth_scanner,
		/obj/item/core_sampler,
		/obj/item/gps,
		/obj/item/pinpointer/radio,
		/obj/item/clothing/glasses/meson,
		/obj/item/tool,
		/obj/item/measuring_tape,
		/obj/item/bag/fossils,
		/obj/item/hand_labeler,
		/obj/item/stack/tape_roll/barricade_tape/research,
	)

/obj/machinery/alarm/isolation
	req_access = list(list(access_research, access_atmospherics, access_engine_equip))

/obj/machinery/alarm/monitor/isolation
	req_access = list(list(access_research, access_atmospherics, access_engine_equip))

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
	path = /obj/item/tool/xeno/hand

/datum/fabricator_recipe/protolathe/tool/xeno_brush
	path = /obj/item/tool/xeno/brush

/datum/fabricator_recipe/protolathe/tool/xeno_pick_one
	path = /obj/item/tool/xeno/one_pick

/datum/fabricator_recipe/protolathe/tool/xeno_pick_two
	path = /obj/item/tool/xeno/two_pick

/datum/fabricator_recipe/protolathe/tool/xeno_pick_three
	path = /obj/item/tool/xeno/three_pick

/datum/fabricator_recipe/protolathe/tool/xeno_pick_four
	path = /obj/item/tool/xeno/four_pick

/datum/fabricator_recipe/protolathe/tool/xeno_pick_five
	path = /obj/item/tool/xeno/five_pick

/datum/fabricator_recipe/protolathe/tool/xeno_pick_six
	path = /obj/item/tool/xeno/six_pick

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
	path = /obj/item/bag/fossils

/datum/fabricator_recipe/textiles/storage/archeology_tool_belt
	path = /obj/item/belt/archaeology

/datum/fabricator_recipe/textiles/storage/excavation_bag
	path = /obj/item/excavation/empty
