//Master Command Outfit
/decl/hierarchy/outfit/job/tradeship/command
	hierarchy_type = /decl/hierarchy/outfit/job/tradeship/command
	shoes = /obj/item/clothing/shoes/jackboots
	glasses = /obj/item/clothing/glasses/sunglasses/big
	r_pocket = /obj/item/radio

//Bridge Staff
/decl/hierarchy/outfit/job/tradeship/command/commanding_officer
	name = TRADESHIP_OUTFIT_JOB_NAME("Captain")
	pda_type = /obj/item/modular_computer/pda/heads/captain
	id_type = /obj/item/card/id/tradeship/command/gold
	uniform = /obj/item/clothing/under/nt/service

/decl/hierarchy/outfit/job/tradeship/command/executive_officer
	name = TRADESHIP_OUTFIT_JOB_NAME("First Mate")
	pda_type = /obj/item/modular_computer/pda/heads/hop
	id_type = /obj/item/card/id/tradeship/command/silver
	uniform = /obj/item/clothing/under/nt/service

/decl/hierarchy/outfit/job/tradeship/command/bridge_officer
	name = TRADESHIP_OUTFIT_JOB_NAME("Bridge Officer")
	pda_type = /obj/item/modular_computer/pda/heads/hop
	id_type = /obj/item/card/id/tradeship/command/bo
	uniform = /obj/item/clothing/under/nt/service/bridge

/decl/hierarchy/outfit/job/tradeship/command/enlisted_advisor
	name = TRADESHIP_OUTFIT_JOB_NAME("Senior Enlisted Advisor")
	pda_type = /obj/item/modular_computer/pda/heads/hop
	id_type = /obj/item/card/id/tradeship/command/sea
	uniform = /obj/item/clothing/under/armsmen/utility

//

// Heads of Staff
/decl/hierarchy/outfit/job/tradeship/command/cso
	name = TRADESHIP_OUTFIT_JOB_NAME("Chief Science Officer")
	pda_type = /obj/item/modular_computer/pda/heads/hop
	id_type = /obj/item/card/id/tradeship/command/cso
	uniform = /obj/item/clothing/under/nt/science
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/nt/chief
	
/decl/hierarchy/outfit/job/tradeship/command/ce
	name = TRADESHIP_OUTFIT_JOB_NAME("Chief Engineer")
	pda_type = /obj/item/modular_computer/pda/heads/hop
	id_type = /obj/item/card/id/tradeship/command/ce
	uniform = /obj/item/clothing/under/nt/service
	suit = /obj/item/clothing/accessory/cloak/nt/ce

/decl/hierarchy/outfit/job/tradeship/command/cmo
	name = TRADESHIP_OUTFIT_JOB_NAME("Chief Medical Officer")
	pda_type = /obj/item/modular_computer/pda/heads/hop
	id_type = /obj/item/card/id/tradeship/command/cmo
	uniform = /obj/item/clothing/under/nt/service
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/nt/medical/chief

/decl/hierarchy/outfit/job/tradeship/command/cos
	name = TRADESHIP_OUTFIT_JOB_NAME("Chief of Security")
	pda_type = /obj/item/modular_computer/pda/heads/hop
	id_type = /obj/item/card/id/tradeship/command/cos
	uniform = /obj/item/clothing/under/nt/security/cos

//
