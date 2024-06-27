/obj/structure/closet/secure_closet/captains
	name = "captain's locker"
	req_access = list(access_captain)
	closet_appearance = /decl/closet_appearance/secure_closet/command

/obj/structure/closet/secure_closet/captains/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/backpack/captain, /obj/item/backpack/satchel/cap)),
		new/datum/atom_creator/simple(/obj/item/backpack/dufflebag/captain, 50),
		/obj/item/clothing/shirt/tunic/captain,
		/obj/item/clothing/suit/jacket/captain,
		/obj/item/clothing/head/caphat/cap,
		/obj/item/clothing/jumpsuit/captain,
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/shoes/color/brown,
		/obj/item/radio/headset/heads/captain,
		/obj/item/clothing/gloves/captain,
		/obj/item/gun/energy/gun,
		/obj/item/telebaton,
		/obj/item/clothing/dress/cap,
		/obj/item/clothing/head/caphat/formal,
		/obj/item/clothing/jumpsuit/captainformal,
	)

/obj/structure/closet/secure_closet/hop
	name = "head of personnel's locker"
	closet_appearance = /decl/closet_appearance/secure_closet/command/hop
	req_access = list(access_hop)

/obj/structure/closet/secure_closet/hop/WillContain()
	return list(
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/head/helmet,
		/obj/item/radio/headset/heads/hop,
		/obj/item/box/ids = 2,
		/obj/item/flash
	)

/obj/structure/closet/secure_closet/hop2
	name = "head of personnel's attire"
	req_access = list(access_hop)
	closet_appearance = /decl/closet_appearance/secure_closet/command/hop

/obj/structure/closet/secure_closet/hop2/WillContain()
	return list(
		/obj/item/clothing/jumpsuit/head_of_personnel,
		/obj/item/clothing/dress/hop,
		/obj/item/clothing/dress/hr,
		/obj/item/clothing/costume/lawyer,
		/obj/item/clothing/costume/lawyer_red,
		/obj/item/clothing/costume/oldman,
		/obj/item/clothing/shoes/color/brown,
		/obj/item/clothing/shoes/color/black,
		/obj/item/clothing/shoes/craftable,
		/obj/item/clothing/shoes/color/white,
		/obj/item/clothing/costume/head_of_personnel_whimsy,
		/obj/item/clothing/head/caphat/hop
	)

/obj/structure/closet/secure_closet/hos
	name = "head of security's locker"
	req_access = list(access_hos)
	closet_appearance = /decl/closet_appearance/secure_closet/security/hos

/obj/structure/closet/secure_closet/hos/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/backpack/security, /obj/item/backpack/satchel/sec)),
		/obj/item/clothing/head/HoS,
		/obj/item/clothing/suit/armor/vest/heavy/hos,
		/obj/item/clothing/jumpsuit/head_of_security/jensen,
		/obj/item/clothing/suit/armor/hos/jensen,
		/obj/item/clothing/suit/armor/hos,
		/obj/item/radio/headset/heads/hos,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/stack/tape_roll/barricade_tape/police,
		/obj/item/shield/riot,
		/obj/item/box/flashbangs,
		/obj/item/belt/holster/security,
		/obj/item/flash,
		/obj/item/baton/loaded,
		/obj/item/gun/energy/gun,
		/obj/item/clothing/webbing/holster/waist,
		/obj/item/telebaton,
		/obj/item/holowarrant
	)

/obj/structure/closet/secure_closet/warden
	name = "warden's locker"
	req_access = list(access_armory)
	closet_appearance = /decl/closet_appearance/secure_closet/security/warden

/obj/structure/closet/secure_closet/warden/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/backpack/security, /obj/item/backpack/satchel/sec)),
		new/datum/atom_creator/simple(/obj/item/backpack/dufflebag/sec, 50),
		/obj/item/clothing/suit/armor/vest/heavy/warden,
		/obj/item/clothing/jumpsuit/warden,
		/obj/item/clothing/suit/armor/warden,
		/obj/item/clothing/head/warden,
		/obj/item/radio/headset/headset_sec,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/stack/tape_roll/barricade_tape/police,
		/obj/item/box/flashbangs,
		/obj/item/box/teargas,
		/obj/item/belt/holster/security,
		/obj/item/chems/spray/pepper,
		/obj/item/baton/loaded,
		/obj/item/gun/energy/gun,
		/obj/item/box/holobadge,
		/obj/item/holowarrant
	)

/obj/structure/closet/secure_closet/security
	name = "security officer's locker"
	req_access = list(access_brig)
	closet_appearance = /decl/closet_appearance/secure_closet/security

/obj/structure/closet/secure_closet/security/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/backpack/security, /obj/item/backpack/satchel/sec)),
		new/datum/atom_creator/simple(/obj/item/backpack/dufflebag/sec, 50),
		/obj/item/clothing/head/helmet,
		/obj/item/radio/headset/headset_sec,
		/obj/item/belt/holster/security,
		/obj/item/flash,
		/obj/item/chems/spray/pepper,
		/obj/item/grenade/chem_grenade/teargas,
		/obj/item/baton/loaded,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/stack/tape_roll/barricade_tape/police,
		/obj/item/hailer,
		/obj/item/clothing/webbing/vest/black,
		/obj/item/gun/energy/taser,
		/obj/item/holowarrant,
	)

/obj/structure/closet/secure_closet/detective
	name = "detective's cabinet"
	req_access = list(access_forensics_lockers)
	closet_appearance = /decl/closet_appearance/cabinet/secure

/obj/structure/closet/secure_closet/detective/WillContain()
	return list(
		/obj/item/clothing/shirt/button/tan,
		/obj/item/clothing/shirt/button,
		/obj/item/clothing/pants/slacks,
		/obj/item/clothing/pants/slacks/black,
		/obj/item/clothing/neck/tie/blue_clip,
		/obj/item/clothing/neck/tie/long/red,
		/obj/item/clothing/suit/jacket/vest/black,
		/obj/item/clothing/suit/det_trench,
		/obj/item/clothing/suit/det_trench/grey,
		/obj/item/clothing/suit/forensics/blue,
		/obj/item/clothing/suit/forensics/red,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/head/det,
		/obj/item/clothing/head/det/grey,
		/obj/item/clothing/shoes/dress,
		/obj/item/box/evidence,
		/obj/item/radio/headset/headset_sec,
		/obj/item/clothing/suit/armor/pcarrier/detective,
		/obj/item/stack/tape_roll/barricade_tape/police,
		/obj/item/gun/projectile/pistol,
		/obj/item/clothing/webbing/holster/armpit,
		/obj/item/chems/drinks/flask/detflask,
		/obj/item/briefcase/crimekit,
		/obj/item/holowarrant
	)

/obj/structure/closet/secure_closet/injection
	name = "lethal injections locker"
	req_access = list(access_captain)

/obj/structure/closet/secure_closet/injection/WillContain()
	return list(/obj/item/chems/syringe/ld50_syringe = 2)

/obj/structure/closet/secure_closet/brig
	name = "brig locker"
	req_access = list(access_brig)
	anchored = TRUE
	var/id = null

/obj/structure/closet/secure_closet/brig/modify_mapped_vars(map_hash)
	..()
	ADJUST_TAG_VAR(id, map_hash)

/obj/structure/closet/secure_closet/brig/WillContain()
	return list(
		/obj/item/clothing/jumpsuit/orange,
		/obj/item/clothing/shoes/color/orange
	)

/obj/structure/closet/secure_closet/courtroom
	name = "courtroom locker"
	req_access = list(access_lawyer)

/obj/structure/closet/secure_closet/courtroom/WillContain()
	return list(
		/obj/item/clothing/shoes/color/brown,
		/obj/item/paper/court = 3,
		/obj/item/pen ,
		/obj/item/clothing/suit/judgerobe,
		/obj/item/clothing/head/powdered_wig ,
		/obj/item/briefcase,
	)

/obj/structure/closet/secure_closet/wall
	name = "wall locker"
	req_access = list(access_security)
	closet_appearance = /decl/closet_appearance/wall

	//too small to put a man in
	large = 0

/obj/structure/closet/secure_closet/wall/Initialize()
	. = ..()
	tool_interaction_flags &= ~TOOL_INTERACTION_ANCHOR

/obj/structure/closet/secure_closet/lawyer
	name = "internal affairs secure closet"
	req_access = list(access_lawyer)

/obj/structure/closet/secure_closet/lawyer/WillContain()
	return list(
		/obj/item/flash = 2,
		/obj/item/camera = 2,
		/obj/item/camera_film = 2,
		/obj/item/taperecorder = 2,
		/obj/item/secure_storage/briefcase = 2,
	)
