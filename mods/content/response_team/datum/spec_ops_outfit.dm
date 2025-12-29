/decl/outfit/spec_op_officer
	name = "Spec Ops - Officer"
	uniform = /obj/item/clothing/pants/casual/camo/outfit_combat
	suit = /obj/item/clothing/suit/armor/officer
	l_ear = /obj/item/radio/headset/specops/ert
	glasses = /obj/item/clothing/glasses/thermal/plain/eyepatch
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/havana
	head = /obj/item/clothing/head/beret
	belt = /obj/item/gun/energy/pulse_pistol
	back = /obj/item/backpack/satchel
	shoes = /obj/item/clothing/shoes/jackboots/swat/combat
	gloves = /obj/item/clothing/gloves/thick/combat

	id_slot = slot_wear_id_str
	id_type = /obj/item/card/id/centcom/ERT
	id_desc = "Special operations ID."
	id_pda_assignment = "Special Operations Officer"

/decl/outfit/spec_op_officer/space
	name = "Spec Ops - Officer in space"
	suit = /obj/item/clothing/suit/space/void/swat
	back = /obj/item/tank/jetpack/oxygen
	mask = /obj/item/clothing/mask/gas/swat

	outfit_flags = OUTFIT_HAS_JETPACK|OUTFIT_RESET_EQUIPMENT