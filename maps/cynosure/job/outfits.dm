/decl/outfit/job/cynosure_explorer
	name              = "Cynosure - Explorer"
	shoes             = /obj/item/clothing/shoes/winterboots/explorer
	uniform           = /obj/item/clothing/jumpsuit/explorer
	l_ear             = /obj/item/radio/headset/headset_exp
	id_slot           = slot_wear_id_str
	pda_slot          = slot_l_store_str
	pda_type          = /obj/item/modular_computer/pda/cargo // Brown looks more rugged
	id_type           = /obj/item/card/id/civilian
	outfit_flags      = OUTFIT_HAS_BACKPACK | OUTFIT_HAS_VITALS_SENSOR
	id_pda_assignment = "Explorer"
	backpack_contents = list(/obj/item/clothing/permit/gun/planetside = 1)

/decl/outfit/job/cynosure_explorer/post_equip(mob/living/human/H)
	..()
	var/obj/item/backpack = H.get_equipped_item(slot_back_str)
	for(var/obj/item/clothing/permit/gun/planetside/permit in backpack)
		permit.set_owner(H.real_name) // no letting someone else use it!

/decl/outfit/job/cynosure_explorer/technician
	name              = "Cynosure - Explorer Technician"
	belt              = /obj/item/belt/utility/full
	pda_slot          = slot_l_store_str
	id_pda_assignment = "Explorer Technician"

/decl/outfit/job/cynosure_explorer/medic
	name              = "Cynosure - Explorer Medic"
	hands             = list(/obj/item/firstaid/regular)
	pda_slot          = slot_l_store_str
	id_pda_assignment = "Explorer Medic"

/decl/outfit/job/pilot
	name              = "Cynosure - Pilot"
	shoes             = /obj/item/clothing/shoes/color/black
	uniform           = /obj/item/clothing/jumpsuit/pilot/nanotrasen/blue
	suit              = /obj/item/clothing/suit/jacket/bomber/pilot
	gloves            = /obj/item/clothing/gloves/black
	glasses           = /obj/item/clothing/glasses/sunglasses
	l_ear             = /obj/item/radio/headset/headset_exp/bowman
	id_slot           = slot_wear_id_str
	pda_slot          = slot_belt_str
	pda_type          = /obj/item/modular_computer/pda/cargo // Brown looks more rugged
	id_type           = /obj/item/card/id/civilian
	outfit_flags      = OUTFIT_HAS_BACKPACK | OUTFIT_HAS_VITALS_SENSOR
	id_pda_assignment = "Pilot"

/decl/outfit/job/medical/sar
	name              = "Cynosure - Search and Rescue"
	uniform           = /obj/item/clothing/jumpsuit/blue
	suit              = /obj/item/clothing/suit/jacket/winter/medical/sar
	shoes             = /obj/item/clothing/shoes/winterboots/explorer
	l_ear             = /obj/item/radio/headset/headset_sar
	hands             = list(/obj/item/firstaid/regular)
	belt              = /obj/item/belt/medical/emt
	pda_slot          = slot_l_store_str
	id_type           = /obj/item/card/id/medical
	outfit_flags      = OUTFIT_HAS_BACKPACK | OUTFIT_EXTENDED_SURVIVAL | OUTFIT_HAS_VITALS_SENSOR
	id_pda_assignment = "Search and Rescue"

/decl/outfit/job/survivalist
	name              = "Cynosure - Survivalist"
	l_ear             = null
	r_ear             = null
	pda_slot          = null
	pda_type          = null
	id_slot           = null
	id_type           = null
	mask              = /obj/item/clothing/mask/gas
	r_pocket          = /obj/item/tank/emergency/oxygen/double
	l_pocket          = /obj/item/radio
	uniform           = /obj/item/clothing/jumpsuit/grey
	shoes             = /obj/item/clothing/shoes/winterboots
	suit              = /obj/item/clothing/suit/jacket/winter
	belt              = /obj/item/gun/energy/gun/reloadable/phase/pistol // better make that cell count

/decl/outfit/job/survivalist/equip_outfit(mob/living/human/H, assignment, equip_adjustments, datum/job/job, datum/mil_rank/rank)
	. = ..()
	var/obj/item/clothing/shoes/shoes = H?.get_equipped_item(slot_shoes_str)
	if(istype(shoes) && !shoes.hidden_item && shoes.can_add_hidden_item)
		shoes.hidden_item = new /obj/item/knife/utility(H)
		shoes.update_icon()

/decl/outfit/job/survivalist/crash_survivor
	name       = "Cynosure - Crash Survivor"
	uniform    = /obj/item/clothing/jumpsuit/lightblue
	shoes      = /obj/item/clothing/shoes/color/black
	head       = /obj/item/clothing/head/helmet/space/emergency
	suit       = /obj/item/clothing/suit/space/emergency
	suit_store = /obj/item/tank/oxygen
	mask       = null

/decl/outfit/job/medical/cynosure_paramedic
	name = "Cynosure - Paramedic"
	uniform = /obj/item/clothing/jumpsuit/medical/paramedic
	suit = /obj/item/clothing/suit/jacket/first_responder
	shoes = /obj/item/clothing/shoes/jackboots
	hands = list(/obj/item/firstaid/regular)
	belt = /obj/item/belt/medical/emt
	pda_slot = slot_l_store_str
	outfit_flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/outfit/job/medical/cynosure_paramedic/emt
	name = "Cynosure  - Emergency Medical Technician"
	suit = /obj/item/clothing/suit/toggle/labcoat
