/obj/structure/bookcase/manuals/xenoarchaeology
	name = "Xenoarchaeology Manuals bookcase"

/obj/structure/bookcase/manuals/xenoarchaeology/Initialize()
	. = ..()
	new /obj/item/book/manual/excavation(src)
	new /obj/item/book/manual/mass_spectrometry(src)
	new /obj/item/book/manual/materials_chemistry_analysis(src)
	new /obj/item/book/manual/anomaly_testing(src)
	new /obj/item/book/manual/anomaly_spectroscopy(src)
	new /obj/item/book/manual/stasis(src)
	update_icon()

/obj/structure/closet/secure_closet/xenoarchaeologist
	name = "Xenoarchaeologist Locker"
	req_access = list(access_xenoarch)
	closet_appearance = /decl/closet_appearance/secure_closet/expedition/science

/obj/structure/closet/secure_closet/xenoarchaeologist/Initialize()
	. = ..()
	if(prob(50))
		new /obj/item/storage/backpack/toxins(src)
	if(prob(50))
		new /obj/item/storage/backpack/dufflebag(src)
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/color/white(src)
	new /obj/item/clothing/glasses/science(src)
	new /obj/item/radio/headset/headset_sci(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clipboard(src)
	new /obj/item/storage/belt/archaeology(src)
	new /obj/item/storage/excavation(src)
	new /obj/item/stack/tape_roll/barricade_tape/research(src)

/obj/structure/closet/excavation
	name = "excavation tools"
	closet_appearance = /decl/closet_appearance/secure_closet/engineering/tools

/obj/structure/closet/excavation/Initialize()
	. = ..()
	new /obj/item/storage/belt/archaeology(src)
	new /obj/item/storage/excavation(src)
	new /obj/item/flashlight/lantern(src)
	new /obj/item/ano_scanner(src)
	new /obj/item/depth_scanner(src)
	new /obj/item/core_sampler(src)
	new /obj/item/gps(src)
	new /obj/item/pinpointer/radio(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/pickaxe(src)
	new /obj/item/measuring_tape(src)
	new /obj/item/pickaxe/xeno/hand(src)
	new /obj/item/storage/bag/fossils(src)
	new /obj/item/hand_labeler(src)
	new /obj/item/stack/tape_roll/barricade_tape/research(src)

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
