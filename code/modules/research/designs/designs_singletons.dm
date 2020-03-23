/datum/design/item/encryptionkey/ModifyDesignName()
	name = "Encryption key design ([name])"

/datum/design/item/encryptionkey/binary
	name = "binary"
	desc = "Allows for deciphering the binary channel on-the-fly."
	req_tech = list(TECH_ESOTERIC = 2)
	build_path = /obj/item/encryptionkey/binary

/datum/design/item/camouflage/ModifyDesignName()
	name = "Camouflage design ([name])"

/datum/design/item/camouflage/chameleon
	name = "holographic equipment kit"
	desc = "A kit of dangerous, high-tech equipment with changeable looks."
	req_tech = list(TECH_ESOTERIC = 2)
	build_path = /obj/item/storage/backpack/chameleon/sydie_kit

/datum/design/item/advmop
	name = "Advanced Mop"
	desc = "An upgraded mop with a large internal capacity for holding water or other cleaning chemicals."
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_POWER = 3)
	build_path = /obj/item/mop/advanced

/datum/design/blutrash
	name = "Trashbag of Holding"
	desc = "An advanced trash bag with bluespace properties; capable of holding a plethora of garbage."
	req_tech = list(TECH_BLUESPACE = 5, TECH_MATERIALS = 6)
	build_path = /obj/item/storage/bag/trash/bluespace

/datum/design/item/holosign
	name = "Holographic Sign Projector"
	desc = "A holograpic projector used to project various warning signs."
	req_tech = list(TECH_ENGINEERING = 5, TECH_BLUESPACE = 4, TECH_POWER = 4)
	build_path = /obj/item/holosign_creator

/datum/design/item/party
	name = "Uncertified module: PRTY"
	desc = "Schematics for a robotic module, scraped from seedy parts of the net. Who knows what it does."
	req_tech = list(TECH_DATA = 2, TECH_ESOTERIC = 2)
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/uncertified/party
	category = "Cyborg Upgrade Modules"