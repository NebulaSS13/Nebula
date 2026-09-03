//Gun Cabinets

/obj/structure/closet/secure_closet/guncabinet/sidearm
	name = "emergency weapon cabinet"
	req_access = list(access_armory,access_captain)

/obj/structure/closet/secure_closet/guncabinet/sidearm/WillContain()
	return list(
		/obj/item/gun/energy/gun = 4
	)

/obj/structure/closet/secure_closet/guncabinet/rifle
	name = "rifle cabinet"
	req_access = list(
		access_explorer,
		access_brig
	)

/obj/structure/closet/secure_closet/guncabinet/rifle/WillContain()
	. = list(
		/obj/item/ammo_casing/rifle = 12,
		/obj/item/gun/projectile/bolt_action = 2
	)
	if(prob(85))
		. += /obj/item/gun/projectile/bolt_action
	else
		. += /obj/item/gun/projectile/bolt_action

//SAR Lockers
/obj/structure/closet/secure_closet/sar
	name = "search and rescue locker"
	desc = "Supplies for a wilderness first responder."
	req_access = list(access_medical_equip)
	closet_appearance = /decl/closet_appearance/secure_closet/medical

/obj/structure/closet/secure_closet/sar/WillContain()
	return list(
		/obj/item/backpack/dufflebag/med,
		/obj/item/box/autoinjectors,
		/obj/item/box/syringes,
		/obj/item/chems/glass/bottle/stabilizer,
		/obj/item/chems/glass/bottle/antitoxin,
		/obj/item/belt/medical/emt,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/suit/jacket/winter/medical/sar,
		/obj/item/clothing/shoes/winterboots/explorer,
		/obj/item/radio/headset/headset_sar,
		/obj/item/flashlight,
		/obj/item/tank/emergency/oxygen/engi,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/scanner/health,
		/obj/item/radio/off,
		/obj/random/medical,
		/obj/item/crowbar,
		/obj/item/chems/spray/extinguisher/mini,
		/obj/item/box/freezer,
		/obj/item/clothing/webbing/vest,
		/obj/item/stack/tape_roll/barricade_tape/medical,
		/obj/item/gps,
		/obj/item/geiger,
		/obj/item/bodybag/cryobag
	)

//Cynosure Paramedic Locker
/obj/structure/closet/secure_closet/paramedic
	name = "paramedic locker"
	desc = "Supplies for a first responder."
	req_access = list(access_medical_equip)
	closet_appearance = /decl/closet_appearance/secure_closet/medical/paramedic

/obj/structure/closet/secure_closet/paramedic/WillContain()
	return list(
		/obj/item/backpack/dufflebag/med,
		/obj/item/box/autoinjectors,
		/obj/item/box/syringes,
		/obj/item/chems/glass/bottle/stabilizer,
		/obj/item/chems/glass/bottle/antitoxin,
		/obj/item/belt/medical/emt,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/suit/toggle/labcoat,
		/obj/item/clothing/suit/jacket/first_responder,
		/obj/item/clothing/suit/jacket/winter/medical/sar,
		/obj/item/clothing/shoes/winterboots/explorer,
		/obj/item/radio/headset/headset_med/bowman,
		/obj/item/radio/headset/headset_sar,
		/obj/item/briefcase/inflatable,
		/obj/item/flashlight,
		/obj/item/tank/emergency/oxygen/engi,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/scanner/health,
		/obj/item/radio/off,
		/obj/random/medical,
		/obj/item/crowbar,
		/obj/item/chems/spray/extinguisher/mini,
		/obj/item/box/freezer,
		/obj/item/clothing/webbing/vest,
		/obj/item/stack/tape_roll/barricade_tape/medical,
		/obj/item/gps/medical,
		/obj/item/geiger,
		/obj/item/gun/energy/gun/reloadable/phase/pistol,
		/obj/item/cell/gun
	)

//Pilot Locker
/obj/structure/closet/secure_closet/pilot
	name = "pilot locker"
	req_access = list(access_explorer)

/obj/structure/closet/secure_closet/pilot/WillContain()
	. = list(
		/obj/item/backpack/parachute,
		/obj/item/knife/utility,
		/obj/item/clothing/head/helmet/corp/nt/pilot,
		/obj/item/clothing/jumpsuit/pilot/nanotrasen/blue,
		/obj/item/clothing/suit/jacket/bomber/pilot,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/shoes/color/black,
		/obj/item/clothing/gloves/black,
		/obj/item/radio/headset/headset_exp/bowman,
		/obj/item/flashlight,
		/obj/item/food/junk/liquidfood,
		/obj/item/chems/drinks/cans/waterbottle,
		/obj/item/box/flares,
		/obj/item/cell/device,
		/obj/item/radio
	)
	if(prob(50))
		. += /obj/item/backpack
	else
		. += /obj/item/backpack/satchel

//Exotic Seeds Crate
/obj/structure/closet/crate/hydroponics/exotic
	name = "exotic seeds crate"
	desc = "All you need to destroy that pesky planet."

/obj/structure/closet/crate/hydroponics/WillContain()
	return list(
		/obj/item/seeds/random = 6,
		/obj/item/seeds/ambrosiavulgarisseed = 2,
		/obj/item/seeds/kudzuseed,
		/obj/item/seeds/libertymycelium,
		/obj/item/seeds/reishimycelium
	)
