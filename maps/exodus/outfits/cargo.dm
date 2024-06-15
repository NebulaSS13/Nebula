/decl/hierarchy/outfit/job/cargo
	l_ear = /obj/item/radio/headset/headset_cargo
	abstract_type = /decl/hierarchy/outfit/job/cargo

/decl/hierarchy/outfit/job/cargo/qm
	name = "Job - Cargo"
	pants = /obj/item/clothing/jumpsuit/cargo
	shoes = /obj/item/clothing/shoes/color/brown
	glasses = /obj/item/clothing/glasses/sunglasses
	hands = list(/obj/item/clipboard)
	id_type = /obj/item/card/id/cargo/head
	pda_type = /obj/item/modular_computer/pda/cargo

/obj/item/card/id/cargo/head
	name = "identification card"
	desc = "A card which represents service and planning."
	extra_details = list("goldstripe")

/decl/hierarchy/outfit/job/cargo/cargo_tech
	name = "Job - Cargo technician"
	pants = /obj/item/clothing/jumpsuit/cargotech
	id_type = /obj/item/card/id/cargo
	pda_type = /obj/item/modular_computer/pda/cargo

/decl/hierarchy/outfit/job/cargo/mining
	name = "Job - Shaft miner"
	pants = /obj/item/clothing/jumpsuit/miner
	id_type = /obj/item/card/id/cargo
	pda_type = /obj/item/modular_computer/pda/science
	backpack_contents = list(/obj/item/crowbar = 1, /obj/item/ore = 1)
	outfit_flags = OUTFIT_HAS_BACKPACK | OUTFIT_EXTENDED_SURVIVAL | OUTFIT_HAS_VITALS_SENSOR

/decl/hierarchy/outfit/job/cargo/mining/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_ENGINEERING
