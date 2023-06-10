
/obj/machinery/vending/medical
	name = "NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_deny = "med-deny"
	icon_vend = "med-vend"
	vend_delay = 18
	markup = 0
	base_type = /obj/machinery/vending/medical
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?;Ping!"
	initial_access = list(access_medical_equip)
	products = list(
		/obj/item/chems/glass/bottle/antitoxin = 4,
		/obj/item/chems/glass/bottle/stabilizer = 4,
		/obj/item/chems/glass/bottle/sedatives = 4,
		/obj/item/chems/glass/bottle/bromide = 4,
		/obj/item/chems/syringe/antibiotic = 4,
		/obj/item/chems/syringe = 12,
		/obj/item/scanner/health = 5,
		/obj/item/scanner/breath = 5,
		/obj/item/chems/glass/beaker = 4,
		/obj/item/chems/dropper = 2,
		/obj/item/stack/medical/advanced/bruise_pack = 3,
		/obj/item/stack/medical/advanced/ointment = 3,
		/obj/item/stack/medical/splint = 2,
		/obj/item/chems/hypospray/autoinjector/pain = 4
	)
	contraband = list(
		/obj/item/clothing/mask/chewable/candy/lolli/meds = 8,
		/obj/item/chems/pill/bromide = 3,
		/obj/item/chems/pill/stox = 4,
		/obj/item/chems/pill/antitox = 6
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/wallmed1
	name = "NanoMed"
	desc = "A wall-mounted version of the NanoMed."
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	icon_vend = "wallmed-vend"
	base_type = /obj/machinery/vending/wallmed1
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(
		/obj/item/stack/medical/bruise_pack = 3,
		/obj/item/stack/medical/ointment = 3,
		/obj/item/chems/pill/painkillers = 2,
		/obj/item/chems/pill/strong_painkillers = 2,
		/obj/item/storage/med_pouch/trauma,
		/obj/item/storage/med_pouch/burn,
		/obj/item/storage/med_pouch/oxyloss,
		/obj/item/storage/med_pouch/toxin
	)
	contraband = list(/obj/item/chems/syringe/antitoxin = 4,/obj/item/chems/syringe/antibiotic = 4,/obj/item/chems/pill/bromide = 1)
	directional_offset = "{'NORTH':{'y':-24}, 'SOUTH':{'y':24}, 'EAST':{'x':-24}, 'WEST':{'x':24}}"
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED

/obj/machinery/vending/wallmed2
	name = "NanoMed Mini"
	desc = "A wall-mounted version of the NanoMed, containing only vital first aid equipment."
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	icon_vend = "wallmed-vend"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	base_type = /obj/machinery/vending/wallmed2
	products = list(
		/obj/item/chems/hypospray/autoinjector = 5,
		/obj/item/stack/medical/bruise_pack = 4,
		/obj/item/stack/medical/ointment = 4,
		/obj/item/storage/med_pouch/trauma,
		/obj/item/storage/med_pouch/burn,
		/obj/item/storage/med_pouch/oxyloss,
		/obj/item/storage/med_pouch/toxin,
		/obj/item/storage/med_pouch/radiation
	)
	contraband = list(/obj/item/chems/pill/bromide = 3, /obj/item/chems/hypospray/autoinjector/pain = 2)
	directional_offset = "{'NORTH':{'y':-24}, 'SOUTH':{'y':24}, 'EAST':{'x':-24}, 'WEST':{'x':24}}"
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
