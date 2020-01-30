/datum/design/item/encryptionkey/AssembleDesignName()
	..()
	name = "Encryption key design ([item_name])"

/datum/design/item/encryptionkey/binary
	name = "binary"
	desc = "Allows for deciphering the binary channel on-the-fly."
	id = "binaryencrypt"
	req_tech = list(TECH_ESOTERIC = 2)
	materials = list(MAT_STEEL = 300, MAT_GLASS = 300)
	build_path = /obj/item/encryptionkey/binary
	sort_string = "VASAA"

/datum/design/item/camouflage/AssembleDesignName()
	..()
	name = "Camouflage design ([item_name])"

/datum/design/item/camouflage/chameleon
	name = "holographic equipment kit"
	desc = "A kit of dangerous, high-tech equipment with changeable looks."
	id = "chameleon"
	req_tech = list(TECH_ESOTERIC = 2)
	materials = list(MAT_STEEL = 500, MAT_ALUMINIUM = 500, MAT_PLASTIC = 500)
	build_path = /obj/item/storage/backpack/chameleon/sydie_kit
	sort_string = "VASBA"

/datum/design/item/advmop
	name = "Advanced Mop"
	desc = "An upgraded mop with a large internal capacity for holding water or other cleaning chemicals."
	id = "advmop"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_POWER = 3)
	materials = list(MAT_ALUMINIUM = 2500, MAT_STEEL = 500, MAT_PLASTIC = 200)
	build_path = /obj/item/mop/advanced

/datum/design/blutrash
	name = "Trashbag of Holding"
	desc = "An advanced trash bag with bluespace properties; capable of holding a plethora of garbage."
	id = "blutrash"
	req_tech = list(TECH_BLUESPACE = 5, TECH_MATERIALS = 6)
	materials = list(MAT_PLASTIC = 5000, MAT_GOLD = 1500, MAT_URANIUM = 250, MAT_PHORON = 1500)
	build_path = /obj/item/storage/bag/trash/bluespace

/datum/design/item/holosign
	name = "Holographic Sign Projector"
	desc = "A holograpic projector used to project various warning signs."
	id = "holosign"
	req_tech = list(TECH_ENGINEERING = 5, TECH_BLUESPACE = 4, TECH_POWER = 4)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000)
	build_path = /obj/item/holosign_creator

/datum/design/item/party
	name = "Uncertified module: PRTY"
	desc = "Schematics for a robotic module, scraped from seedy parts of the net. Who knows what it does."
	id = "borg_party_module"
	req_tech = list(TECH_DATA = 2, TECH_ESOTERIC = 2)
	build_type = MECHFAB
	materials = list(MAT_STEEL = 7500, MAT_ALUMINIUM = 5000, MAT_DIAMOND = 2000)
	build_path = /obj/item/borg/upgrade/uncertified/party
	category = "Cyborg Upgrade Modules"