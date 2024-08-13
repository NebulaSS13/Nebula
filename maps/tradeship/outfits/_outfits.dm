// OUTFITS
/decl/outfit/job/tradeship
	abstract_type = /decl/outfit/job/tradeship
	pda_type = /obj/item/modular_computer/pda
	pda_slot = slot_l_store_str
	l_ear = null
	r_ear = null

/decl/outfit/job/tradeship/hand
	name = "Tradeship - Job - Deck Hand"

/decl/outfit/job/tradeship/hand/pre_equip(mob/living/human/H)
	..()
	uniform = pick(list(
		/obj/item/clothing/pants/mustard/overalls,
		/obj/item/clothing/jumpsuit/hazard,
		/obj/item/clothing/jumpsuit/cargotech,
		/obj/item/clothing/jumpsuit/black,
		/obj/item/clothing/jumpsuit/grey
	))

/decl/outfit/job/tradeship/hand/cook
	name = "Tradeship - Job - Cook"
	head = /obj/item/clothing/head/chefhat
