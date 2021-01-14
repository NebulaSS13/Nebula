#define RANDOM_SCRUBS new/datum/atom_creator/weighted(list( \
				list(/obj/item/clothing/under/medical/scrubs, /obj/item/clothing/head/surgery), \
				list(/obj/item/clothing/under/medical/scrubs/blue, /obj/item/clothing/head/surgery/blue), \
				list(/obj/item/clothing/under/medical/scrubs/green, /obj/item/clothing/head/surgery/green), \
				list(/obj/item/clothing/under/medical/scrubs/purple, /obj/item/clothing/head/surgery/purple), \
				list(/obj/item/clothing/under/medical/scrubs/black, /obj/item/clothing/head/surgery/black), \
				list(/obj/item/clothing/under/medical/scrubs/lilac, /obj/item/clothing/head/surgery/lilac), \
				list(/obj/item/clothing/under/medical/scrubs/teal, /obj/item/clothing/head/surgery/teal), \
				list(/obj/item/clothing/under/medical/scrubs/heliodor, /obj/item/clothing/head/surgery/heliodor), \
				list(/obj/item/clothing/under/medical/scrubs/navyblue, /obj/item/clothing/head/surgery/navyblue)\
			) \
		)

/obj/structure/closet/secure_closet/medical1
	name = "medical equipment closet"
	desc = "Filled with medical junk."
	closet_appearance = /decl/closet_appearance/secure_closet/medical
	req_access = list(access_medical_equip)

/obj/structure/closet/secure_closet/medical1/WillContain()
	return list(
		/obj/item/storage/box/autoinjectors,
		/obj/item/storage/box/syringes,
		/obj/item/chems/dropper = 2,
		/obj/item/chems/glass/beaker = 2,
		/obj/item/chems/glass/bottle/stabilizer = 2,
		/obj/item/chems/glass/bottle/antitoxin = 2,
		/obj/random/firstaid,
		/obj/item/storage/box/masks,
		/obj/item/storage/box/gloves
	)

/obj/structure/closet/secure_closet/medical3
	name = "medical doctor's locker"
	req_access = list(access_medical_equip)
	closet_appearance = /decl/closet_appearance/secure_closet/medical/alt

/obj/structure/closet/secure_closet/medical3/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/storage/backpack/medic, /obj/item/storage/backpack/satchel/med)),
		new/datum/atom_creator/simple(/obj/item/storage/backpack/dufflebag/med, 50),
		/obj/item/clothing/under/nursesuit,
		/obj/item/clothing/head/nursehat,
		/obj/item/clothing/under/medical,
		/obj/item/clothing/under/nurse,
		/obj/item/clothing/under/orderly,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/storage/toggle/fr_jacket,
		/obj/item/clothing/shoes/color/white,
		/obj/item/radio/headset/headset_med,
		/obj/item/taperoll/medical,
		/obj/item/storage/belt/medical/emt,
		RANDOM_SCRUBS,
		RANDOM_SCRUBS
	)

/obj/structure/closet/secure_closet/paramedic
	name = "paramedic locker"
	desc = "Supplies for a first responder."
	closet_appearance = /decl/closet_appearance/secure_closet/medical
	req_access = list(access_medical_equip)

/obj/structure/closet/secure_closet/paramedic/WillContain()
	return list(
	    /obj/item/storage/box/autoinjectors,
	    /obj/item/storage/box/syringes,
	    /obj/item/chems/glass/bottle/stabilizer,
	    /obj/item/chems/glass/bottle/antitoxin,
	    /obj/item/storage/belt/medical/emt,
	    /obj/item/clothing/mask/gas,
	    /obj/item/clothing/suit/storage/toggle/fr_jacket,
	    /obj/item/clothing/suit/storage/toggle/labcoat,
	    /obj/item/radio/headset/headset_med,
	    /obj/item/flashlight,
	    /obj/item/tank/emergency/oxygen/engi,
	    /obj/item/clothing/glasses/hud/health,
	    /obj/item/scanner/health,
	    /obj/item/radio/off,
	    /obj/random/medical,
	    /obj/item/crowbar,
	    /obj/item/extinguisher/mini,
	    /obj/item/storage/box/freezer,
	    /obj/item/clothing/accessory/storage/vest,
	)

/obj/structure/closet/secure_closet/CMO
	name = "chief medical officer's locker"
	req_access = list(access_cmo)
	closet_appearance = /decl/closet_appearance/secure_closet/cmo

/obj/structure/closet/secure_closet/CMO/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/storage/backpack/medic, /obj/item/storage/backpack/satchel/med)),
		new/datum/atom_creator/simple(/obj/item/storage/backpack/dufflebag/med, 50),
		/obj/item/clothing/suit/bio_suit/cmo,
		/obj/item/clothing/head/bio_hood/cmo,
		/obj/item/clothing/shoes/color/white,
		/obj/item/clothing/under/chief_medical_officer,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/shoes/color/brown,
		/obj/item/radio/headset/heads/cmo,
		/obj/item/flash,
		/obj/item/chems/hypospray/vial,
		RANDOM_SCRUBS
	)

/obj/structure/closet/secure_closet/chemical
	name = "chemical closet"
	desc = "Store dangerous chemicals in here."
	closet_appearance = /decl/closet_appearance/secure_closet/medical
	req_access = list(access_chemistry)

/obj/structure/closet/secure_closet/chemical/WillContain()
	return list(
		/obj/item/storage/box/pillbottles = 2,
		/obj/random/medical = 12
	)

/obj/structure/closet/secure_closet/medical_wall
	name = "first aid closet"
	desc = "It's a secure wall-mounted storage unit for first aid supplies."
	closet_appearance = /decl/closet_appearance/wall/medical
	anchored = 1
	density = 0
	wall_mounted = 1
	storage_types = CLOSET_STORAGE_ITEMS
	req_access = list(access_medical_equip)

/obj/structure/closet/secure_closet/counselor
	name = "counselor's locker"
	closet_appearance = /decl/closet_appearance/secure_closet/medical
	req_access = list(access_psychiatrist)

/obj/structure/closet/secure_closet/counselor/WillContain()
	return list(
		/obj/item/clothing/under/psych,
		/obj/item/clothing/under/psych/turtleneck,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/shoes/color/white,
		/obj/item/chems/glass/bottle/sedatives,
		/obj/item/chems/syringe,
		/obj/item/storage/pill_bottle/antidepressants,
		/obj/item/chems/pill/stimulants,
		/obj/item/clipboard,
		/obj/item/folder/cyan,
		/obj/item/taperecorder,
		/obj/item/tape/random = 3,
		/obj/item/camera,
		/obj/item/toy/therapy_blue,
		/obj/item/storage/belt/general
	)

/obj/structure/closet/secure_closet/virology
	name = "virologist's locker"
	closet_appearance = /decl/closet_appearance/secure_closet/medical/virology

	req_access = list(access_virology)

/obj/structure/closet/secure_closet/virology/WillContain()
	return list(
		/obj/item/storage/box/autoinjectors,
		/obj/item/storage/box/syringes,
		/obj/item/chems/dropper = 2,
		/obj/item/chems/glass/beaker = 2,
		/obj/item/chems/glass/bottle/stabilizer,
		/obj/item/storage/pill_bottle/antibiotics,
		/obj/item/chems/syringe/antibiotic,
		/obj/item/chems/glass/bottle/antitoxin,
		/obj/item/storage/box/masks,
		/obj/item/storage/box/gloves,
		/obj/item/clothing/under/virologist,
		/obj/item/clothing/shoes/color/white,
		/obj/item/clothing/suit/storage/toggle/labcoat/virologist,
		/obj/item/clothing/mask/surgical,
		/obj/item/scanner/health,
		/obj/item/clothing/glasses/hud/health
	)

/obj/structure/closet/secure_closet/psychiatry
	name = "Psychiatrist's locker"
	desc = "Everything you need to keep the lunatics at bay."
	closet_appearance = /decl/closet_appearance/secure_closet/medical/alt
	req_access = list(access_psychiatrist)

/obj/structure/closet/secure_closet/psychiatry/WillContain()
	return list(
		/obj/item/clothing/suit/straight_jacket,
		/obj/item/chems/glass/bottle/sedatives,
		/obj/item/chems/syringe,
		/obj/item/storage/pill_bottle/antidepressants,
		/obj/item/storage/pill_bottle/stimulants,
		/obj/item/clothing/under/psych/turtleneck,
		/obj/item/clothing/under/psych
	)
