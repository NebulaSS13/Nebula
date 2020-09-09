/decl/hierarchy/outfit/job/yinglet/yinglet_rep
	name = MINISTATION_OUTFIT_JOB_NAME("Enclave Patriarch")
	suit = /obj/item/clothing/suit/yinglet
	id_type = /obj/item/card/id/ministation/yinglet_rep

/decl/hierarchy/outfit/job/yinglet/yinglet_rep/matriarch
	name = MINISTATION_OUTFIT_JOB_NAME("Enclave Matriarch")
	uniform = /obj/item/clothing/under/yinglet/matriarch
	head = /obj/item/clothing/head/yinglet/matriarch
	id_type = /obj/item/card/id/ministation/yinglet_rep
	suit = null

/obj/item/card/id/ministation/yinglet_rep
	name = "identification card"
	desc = "A card issued to Enclave delegates."
	job_access_type = /datum/job/yinglet/yinglet_rep
	color = COLOR_BRONZE
	extra_details = list("goldstripe")