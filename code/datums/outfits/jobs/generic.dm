/decl/hierarchy/outfit/job/generic
	abstract_type = /decl/hierarchy/outfit/job/generic
	id_type = /obj/item/card/id/civilian

/decl/hierarchy/outfit/job/generic/assistant
	name = "Job - Assistant"

/decl/hierarchy/outfit/job/generic/scientist
	name = "Job - Default Scientist"
	l_ear = /obj/item/radio/headset/headset_sci
	suit = /obj/item/clothing/suit/toggle/labcoat/science
	shoes = /obj/item/clothing/shoes/color/white
	pda_type = /obj/item/modular_computer/pda/science
	pants = /obj/item/clothing/jumpsuit/white

/decl/hierarchy/outfit/job/generic/engineer
	name = "Job - Default Engineer"
	head = /obj/item/clothing/head/hardhat
	pants = /obj/item/clothing/jumpsuit/engineer
	r_pocket = /obj/item/t_scanner
	belt = /obj/item/belt/utility/full
	l_ear = /obj/item/radio/headset/headset_eng
	shoes = /obj/item/clothing/shoes/workboots
	pda_type = /obj/item/modular_computer/pda/engineering
	pda_slot = slot_l_store_str
	outfit_flags = OUTFIT_HAS_BACKPACK | OUTFIT_EXTENDED_SURVIVAL | OUTFIT_HAS_VITALS_SENSOR

/decl/hierarchy/outfit/job/generic/engineer/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/generic/doctor
	name = "Job - Default Doctor"
	pants = /obj/item/clothing/jumpsuit/medical
	suit = /obj/item/clothing/suit/toggle/labcoat
	hands = list(/obj/item/firstaid/adv)
	r_pocket = /obj/item/flashlight/pen
	l_ear = /obj/item/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/color/white
	pda_type = /obj/item/modular_computer/pda/medical
	pda_slot = slot_l_store_str

/decl/hierarchy/outfit/job/generic/doctor/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_MEDICAL

/decl/hierarchy/outfit/job/generic/chef
	name = "Job - Default Chef"
	l_ear = /obj/item/radio/headset/headset_service
	pants = /obj/item/clothing/pants/slacks/white
	uniform = /obj/item/clothing/shirt/button
	suit = /obj/item/clothing/suit/chef
	head = /obj/item/clothing/head/chefhat
	pda_type = /obj/item/modular_computer/pda
