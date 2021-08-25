/decl/hierarchy/supply_pack/operations
	name = "Operations"

/decl/hierarchy/supply_pack/operations/cargotrain
	name = "Equipment - Cargo Train Tug"
	contains = list(/obj/vehicle/train/cargo/engine)
	containertype = /obj/structure/largecrate
	containername = "cargo train tug crate"

/decl/hierarchy/supply_pack/operations/cargotrailer
	name = "Equipment - Cargo Train Trolley"
	contains = list(/obj/vehicle/train/cargo/trolley)
	containertype = /obj/structure/largecrate
	containername = "cargo train trolley crate"

/decl/hierarchy/supply_pack/operations/contraband
	num_contained = 5
	contains = list(/obj/item/seeds/bloodtomatoseed,
					/obj/item/storage/pill_bottle/zoom,
					/obj/item/storage/pill_bottle/happy,
					/obj/item/storage/pill_bottle/gleam,
					/obj/item/chems/drinks/bottle/pwine)

	name = "UNLISTED - Contraband crate"
	containername = "unlabeled crate"
	contraband = 1
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/operations/plasma_cutter
	name = "Equipment - Plasma Cutter"
	contains = list(/obj/item/gun/energy/plasmacutter)
	containertype = /obj/structure/closet/crate/secure
	containername = "plasma cutter crate"
	access = list(list(access_mining,access_engine))

/decl/hierarchy/supply_pack/operations/orebox
	name = "Equipment - Ore box"
	contains = list(/obj/structure/ore_box)
	containertype = /obj/structure/largecrate
	containername = "Ore box crate"

/decl/hierarchy/supply_pack/operations/webbing
	name = "Gear - Webbing, vests, holsters."
	num_contained = 4
	contains = list(/obj/item/clothing/accessory/storage,
					/obj/item/clothing/accessory/storage/holster,
					/obj/item/clothing/accessory/storage/vest/black,
					/obj/item/clothing/accessory/storage/vest/brown,
					/obj/item/clothing/accessory/storage/vest,
					/obj/item/clothing/accessory/storage/drop_pouches/black,
					/obj/item/clothing/accessory/storage/drop_pouches/brown,
					/obj/item/clothing/accessory/storage/drop_pouches/white)
	containername = "webbing crate"

/decl/hierarchy/supply_pack/operations/voidsuit_engineering
	name = "EVA - Engineering voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/engineering/alt,
					/obj/item/clothing/head/helmet/space/void/engineering/alt,
					/obj/item/clothing/shoes/magboots)
	containername = "engineering voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_engine

/decl/hierarchy/supply_pack/operations/voidsuit_medical
	name = "EVA - Medical voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/medical/alt,
					/obj/item/clothing/head/helmet/space/void/medical/alt,
					/obj/item/clothing/shoes/magboots)
	containername = "medical voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_medical_equip

/decl/hierarchy/supply_pack/operations/voidsuit_security
	name = "EVA - Security (armored) voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/security/alt,
					/obj/item/clothing/head/helmet/space/void/security/alt,
					/obj/item/clothing/shoes/magboots)
	containername = "security voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_brig

/decl/hierarchy/supply_pack/operations/bureaucracy
	contains = list(/obj/item/clipboard,
					 /obj/item/clipboard,
					 /obj/item/pen/retractable/red,
					 /obj/item/pen/retractable/blue,
					 /obj/item/pen/green,
					 /obj/item/camera_film,
					 /obj/item/folder/blue,
					 /obj/item/folder/red,
					 /obj/item/folder/yellow,
					 /obj/item/hand_labeler,
					 /obj/item/tape_roll,
					 /obj/structure/filingcabinet/chestdrawer,
					 /obj/item/paper_bin)
	name = "Office supplies"
	containertype = /obj/structure/closet/crate/large
	containername = "office supplies crate"

