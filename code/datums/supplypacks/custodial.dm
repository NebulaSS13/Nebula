/decl/hierarchy/supply_pack/custodial
	name = "Custodial"

/decl/hierarchy/supply_pack/custodial/janitor
	name = "Gear - Janitorial supplies"
	contains = list(/obj/item/chems/glass/bucket,
					/obj/item/mop,
					/obj/item/caution = 4,
					/obj/item/bag/trash,
					/obj/item/lightreplacer,
					/obj/item/chems/spray/cleaner,
					/obj/item/box/lights/mixed,
					/obj/item/chems/glass/rag,
					/obj/item/grenade/chem_grenade/cleaner = 3,
					/obj/structure/mopbucket)
	containertype = /obj/structure/closet/crate/large
	containername = "janitorial supplies crate"

/decl/hierarchy/supply_pack/custodial/mousetrap
	num_contained = 3
	contains = list(/obj/item/box/mousetraps)
	name = "Misc - Pest control"
	containername = "pest control crate"

/decl/hierarchy/supply_pack/custodial/lightbulbs
	name = "Spares - Replacement lights"
	contains = list(/obj/item/box/lights/mixed = 3)
	containername = "replacement lights crate"

/decl/hierarchy/supply_pack/custodial/cleaning
	name = "Gear - Cleaning supplies"
	contains = list(/obj/item/mop,
					/obj/item/grenade/chem_grenade/cleaner = 3,
					/obj/item/box/detergent = 3,
					/obj/item/chems/glass/bucket,
					/obj/item/chems/glass/rag,
					/obj/item/chems/spray/cleaner = 2,
					/obj/item/soap)
	containertype = /obj/structure/closet/crate/large
	containername = "cleaning supplies crate"

/decl/hierarchy/supply_pack/custodial/bodybag
	name = "Equipment - Body bags"
	contains = list(/obj/item/box/bodybags = 3)
	containername = "body bag crate"

/decl/hierarchy/supply_pack/custodial/janitorbiosuits
	name = "Gear - Janitor biohazard equipment"
	contains = list(/obj/item/clothing/head/bio_hood/janitor,
					/obj/item/clothing/suit/bio_suit/janitor,
					/obj/item/clothing/mask/gas,
					/obj/item/tank/oxygen)
	containertype = /obj/structure/closet/crate/secure
	containername = "janitor biohazard equipment crate"