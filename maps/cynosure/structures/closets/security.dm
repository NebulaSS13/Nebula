/obj/structure/closet/secure_closet/hos/cynosure
	name = "head of security's locker"
	req_access = list(access_hos)
	storage_capacity = 2.6 * MOB_SIZE_MEDIUM
	closet_appearance = /decl/closet_appearance/secure_closet/security/hos

/obj/structure/closet/secure_closet/hos/cynosure/WillContain()
	. = list(
		/obj/item/clothing/head/HoS,
		/obj/item/clothing/head/HoS,
		/obj/item/clothing/suit/armor/pcarrier/light/cynosure,
		/obj/item/clothing/jumpsuit/head_of_security/jensen,
		/obj/item/clothing/jumpsuit/head_of_security/corp,
		/obj/item/clothing/suit/armor/hos/jensen,
		/obj/item/clothing/suit/armor/hos,
		/obj/item/radio/headset/heads/hos,
		/obj/item/radio/headset/heads/hos,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/stack/tape_roll/barricade_tape/police,
		/obj/item/box/holobadge,
		/obj/item/clothing/badge/holo,
		/obj/item/chems/spray/pepper,
		/obj/item/crowbar/red,
		/obj/item/box/flashbangs,
		/obj/item/belt/security,
		/obj/item/flash,
		/obj/item/baton/loaded,
		/obj/item/gun/energy/gun,
		/obj/item/cell/gun,
		/obj/item/clothing/webbing/holster/waist,
		/obj/item/telebaton,
		/obj/item/clothing/head/beret/corp/sec/corporate/hos,
		/obj/item/clothing/suit/jacket/winter/security,
		/obj/item/clothing/shoes/winterboots/security,
		/obj/item/flashlight/maglight,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/webbing/vest/black
	)
	if(prob(50))
		. += /obj/item/backpack/security
	else
		. += /obj/item/backpack/satchel/sec
	if(prob(50))
		. += /obj/item/backpack/dufflebag/sec


/obj/structure/closet/secure_closet/warden/cynosure
	name = "warden's locker"
	storage_capacity = 42
	req_access = list(access_armory)
	closet_appearance = /decl/closet_appearance/secure_closet/security/warden

/obj/structure/closet/secure_closet/warden/cynosure/WillContain()
	. = list(
		/obj/item/clothing/suit/armor/pcarrier/light/cynosure,
		/obj/item/clothing/jumpsuit/warden,
		/obj/item/clothing/jumpsuit/warden,
		/obj/item/clothing/suit/armor/warden,
		/obj/item/clothing/suit/armor/warden,
		/obj/item/clothing/head/warden,
		/obj/item/clothing/head/warden,
		/obj/item/radio/headset/headset_sec,
		/obj/item/radio/headset/headset_sec/bowman,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/stack/tape_roll/barricade_tape/police,
		/obj/item/clothing/badge/holo,
		/obj/item/box/flashbangs,
		/obj/item/belt/security,
		/obj/item/chems/spray/pepper,
		/obj/item/baton/loaded,
		/obj/item/gun/energy/gun,
		/obj/item/cell/gun,
		/obj/item/box/holobadge,
		/obj/item/clothing/head/beret/corp/sec/corporate/warden,
		/obj/item/clothing/suit/jacket/winter/security,
		/obj/item/clothing/shoes/winterboots/security,
		/obj/item/flashlight/maglight,
		/obj/item/megaphone,
		/obj/item/clothing/mask/gas/half
	)
	if(prob(50))
		. += /obj/item/backpack/security
	else
		. += /obj/item/backpack/satchel/sec
	if(prob(50))
		. += /obj/item/backpack/dufflebag/sec

/obj/structure/closet/secure_closet/security/cynosure
	name = "security officer's locker"
	req_access = list(access_brig)
	closet_appearance = /decl/closet_appearance/secure_closet/security

/obj/structure/closet/secure_closet/security/cynosure/WillContain()
	. = list(
		/obj/item/clothing/suit/armor/pcarrier/light/cynosure,
		/obj/item/clothing/head/helmet,
		/obj/item/radio/headset/headset_sec,
		/obj/item/radio/headset/headset_sec/bowman,
		/obj/item/belt/security,
		/obj/item/flash,
		/obj/item/chems/spray/pepper,
		/obj/item/grenade/flashbang,
		/obj/item/baton/loaded,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/stack/tape_roll/barricade_tape/police,
		/obj/item/hailer,
		/obj/item/flashlight/flare,
		/obj/item/clothing/webbing/vest/black,
		/obj/item/clothing/head/soft/sec/corp,
		/obj/item/clothing/jumpsuit/security/corp,
		/obj/item/ammo_magazine/pistol/rubber,
		/obj/item/gun/energy/taser,
		/obj/item/cell/gun,
		/obj/item/clothing/suit/jacket/winter/security,
		/obj/item/clothing/shoes/winterboots/security,
		/obj/item/flashlight/maglight
	)
	if(prob(50))
		. += /obj/item/backpack/security
	else
		. += /obj/item/backpack/satchel/sec
	if(prob(50))
		. += /obj/item/backpack/dufflebag/sec

/obj/structure/closet/secure_closet/security/cargo/WillContain()
	. = ..()
	. += /obj/item/clothing/armband/cargo
	. += /obj/item/encryptionkey/cargo

/obj/structure/closet/secure_closet/security/engine/WillContain()
	. = ..()
	. += /obj/item/clothing/armband/engine
	. += /obj/item/encryptionkey/eng

/obj/structure/closet/secure_closet/security/science/WillContain()
	. = ..()
	. += /obj/item/clothing/armband/science
	. += /obj/item/encryptionkey/sci

/obj/structure/closet/secure_closet/security/med/WillContain()
	. = ..()
	. += /obj/item/clothing/armband/medblue
	. += /obj/item/encryptionkey/med

/obj/structure/closet/secure_closet/detective/cynosure
	name = "detective's cabinet"
	req_access = list(access_forensics_lockers)
	closet_appearance = /decl/closet_appearance/cabinet/secure

/obj/structure/closet/secure_closet/detective/cynosure/WillContain()
	. = list(
		/obj/item/clothing/badge/holo,
		/obj/item/clothing/gloves/black,
		/obj/item/belt/holster/forensic,
		/obj/item/box/evidence,
		/obj/item/radio/headset/headset_sec,
		/obj/item/radio/headset/headset_sec/bowman,
		/obj/item/clothing/suit/jacket/vest/gray,
		/obj/item/stack/tape_roll/barricade_tape/police,
		/obj/item/clothing/webbing/holster/armpit,
		/obj/item/flashlight/maglight,
		/obj/item/chems/drinks/flask/detflask,
		/obj/item/briefcase/crimekit,
		/obj/item/taperecorder,
		/obj/item/magnetic_tape/random = 3
	)
