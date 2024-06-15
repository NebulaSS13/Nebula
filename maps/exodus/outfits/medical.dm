/decl/hierarchy/outfit/job/medical
	abstract_type = /decl/hierarchy/outfit/job/medical
	l_ear = /obj/item/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/color/white
	pda_type = /obj/item/modular_computer/pda/medical
	pda_slot = slot_l_store_str

/decl/hierarchy/outfit/job/medical/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_MEDICAL

/decl/hierarchy/outfit/job/medical/cmo
	name = "Job - Chief Medical Officer"
	l_ear = /obj/item/radio/headset/heads/cmo
	pants = /obj/item/clothing/jumpsuit/chief_medical_officer
	suit = /obj/item/clothing/suit/toggle/labcoat/cmo
	shoes = /obj/item/clothing/shoes/color/brown
	hands = list(/obj/item/firstaid/adv)
	r_pocket = /obj/item/flashlight/pen
	id_type = /obj/item/card/id/medical/head
	pda_type = /obj/item/modular_computer/pda/heads

/decl/hierarchy/outfit/job/medical/doctor
	name = "Job - Medical Doctor"
	pants = /obj/item/clothing/jumpsuit/medical
	suit = /obj/item/clothing/suit/toggle/labcoat
	hands = list(/obj/item/firstaid/adv)
	r_pocket = /obj/item/flashlight/pen
	id_type = /obj/item/card/id/medical

/decl/hierarchy/outfit/job/medical/doctor/emergency_physician
	name = "Job - Emergency physician"
	suit = /obj/item/clothing/suit/jacket/first_responder

/decl/hierarchy/outfit/job/medical/doctor/surgeon
	name    = "Job - Surgeon"
	pants   = /obj/item/clothing/pants/scrubs/blue
	uniform = /obj/item/clothing/shirt/scrubs/blue
	head    = /obj/item/clothing/head/surgery/blue

/decl/hierarchy/outfit/job/medical/doctor/virologist
	name = "Job - Virologist"
	pants = /obj/item/clothing/jumpsuit/virologist
	suit = /obj/item/clothing/suit/toggle/labcoat/virologist
	mask = /obj/item/clothing/mask/surgical

/decl/hierarchy/outfit/job/medical/doctor/virologist/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_VIROLOGY

/decl/hierarchy/outfit/job/medical/doctor/nurse
	name    = "Job - Nurse"
	suit    = null
	pants   = /obj/item/clothing/pants/scrubs/purple
	uniform = /obj/item/clothing/shirt/scrubs/purple
	head    = null
/decl/hierarchy/outfit/job/medical/chemist
	name = "Job - Chemist"
	pants = /obj/item/clothing/jumpsuit/chemist
	suit = /obj/item/clothing/suit/toggle/labcoat/chemist
	id_type = /obj/item/card/id/medical
	pda_type = /obj/item/modular_computer/pda/medical

/decl/hierarchy/outfit/job/medical/chemist/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_VIROLOGY

/decl/hierarchy/outfit/job/medical/psychiatrist
	name = "Job - Psychiatrist"
	pants = /obj/item/clothing/jumpsuit/psych
	suit = /obj/item/clothing/suit/toggle/labcoat
	shoes = /obj/item/clothing/shoes/dress
	id_type = /obj/item/card/id/medical
