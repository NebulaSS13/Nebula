// OUTFITS
#define TRADESHIP_OUTFIT_JOB_NAME(job_name) ("Tradeship - Job - " + job_name)

/decl/hierarchy/outfit/job/tradeship
	hierarchy_type = /decl/hierarchy/outfit/job/tradeship
	pda_type = /obj/item/modular_computer/pda
	pda_slot = slot_l_store
	suit = /obj/item/clothing/suit/storage/toggle/redcoat
	l_ear = null
	r_ear = null
	yinglet_suit_fallback = TRUE

/decl/hierarchy/outfit/job/tradeship/hand
	name = TRADESHIP_OUTFIT_JOB_NAME("Deck Hand")

/decl/hierarchy/outfit/job/tradeship/hand/pre_equip(mob/living/carbon/human/H)
	..()
	uniform = pick(list(/obj/item/clothing/under/overalls, /obj/item/clothing/under/hazard, /obj/item/clothing/under/rank/cargotech, /obj/item/clothing/under/color/black, /obj/item/clothing/under/color/grey, /obj/item/clothing/under/casual_pants/track))

/decl/hierarchy/outfit/job/tradeship/hand/cook
	name = TRADESHIP_OUTFIT_JOB_NAME("Cook")
	head = /obj/item/clothing/head/chefhat
	suit = /obj/item/clothing/suit/storage/toggle/redcoat/service
