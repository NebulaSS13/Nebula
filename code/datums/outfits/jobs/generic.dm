/decl/outfit/job/generic
	abstract_type = /decl/outfit/job/generic
	id_type = /obj/item/card/id/civilian

/decl/outfit/job/generic/assistant
	name = "Job - Assistant"

/decl/outfit/job/generic/scientist
	name = "Job - Default Scientist"
	l_ear = /obj/item/radio/headset/headset_sci
	suit = /obj/item/clothing/suit/toggle/labcoat/science
	shoes = /obj/item/clothing/shoes/color/white
	pda_type = /obj/item/modular_computer/pda/science
	uniform = /obj/item/clothing/jumpsuit/white

/decl/outfit/job/generic/engineer
	name = "Job - Default Engineer"
	head = /obj/item/clothing/head/hardhat
	uniform = /obj/item/clothing/jumpsuit/engineer
	r_pocket = /obj/item/t_scanner
	belt = /obj/item/belt/utility/full
	l_ear = /obj/item/radio/headset/headset_eng
	shoes = /obj/item/clothing/shoes/workboots
	pda_type = /obj/item/modular_computer/pda/engineering
	pda_slot = slot_l_store_str
	outfit_flags = OUTFIT_HAS_BACKPACK | OUTFIT_EXTENDED_SURVIVAL | OUTFIT_HAS_VITALS_SENSOR

/decl/outfit/job/generic/engineer/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/outfit/job/generic/doctor
	name = "Job - Default Doctor"
	uniform = /obj/item/clothing/jumpsuit/medical
	suit = /obj/item/clothing/suit/toggle/labcoat
	hands = list(/obj/item/firstaid/adv)
	r_pocket = /obj/item/flashlight/pen
	l_ear = /obj/item/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/color/white
	pda_type = /obj/item/modular_computer/pda/medical
	pda_slot = slot_l_store_str

/decl/outfit/job/generic/doctor/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_MEDICAL

/decl/outfit/job/generic/chef
	name = "Job - Default Chef"
	l_ear = /obj/item/radio/headset/headset_service
	uniform = /obj/item/clothing/pants/slacks/outfit_chef
	suit = /obj/item/clothing/suit/chef
	head = /obj/item/clothing/head/chefhat
	pda_type = /obj/item/modular_computer/pda
