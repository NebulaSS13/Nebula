/proc/fill_cigarre_package(var/obj/item/storage/fancy/cigarettes/C, var/list/reagents)
	for(var/reagent in reagents)
		C.reagents.add_reagent(reagent, reagents[reagent] * C.max_storage_space)

/obj/item/storage/box/syndie_kit
	name = "box"
	desc = "A sleek, sturdy box."
	icon_state = "box_of_doom"

//For uplink kits that provide bulkier items
/obj/item/storage/backpack/satchel/syndie_kit
	desc = "A sleek, sturdy satchel."
	icon = 'icons/obj/items/storage/backpack/satchel_grey.dmi'

//In case an uplink kit provides a lot of gear
/obj/item/storage/backpack/dufflebag/syndie_kit
	name = "black dufflebag"
	desc = "A sleek, sturdy dufflebag."
	icon = 'icons/obj/items/storage/backpack/dufflebag_syndie.dmi'

/obj/item/storage/box/syndie_kit/imp_freedom/WillContain()
	return list(/obj/item/implanter/freedom)

/obj/item/storage/box/syndie_kit/imp_uplink/WillContain()
	return list(/obj/item/implanter/uplink)

/obj/item/storage/box/syndie_kit/imp_compress/WillContain()
	return list(/obj/item/implanter/compressed)

/obj/item/storage/box/syndie_kit/imp_explosive/WillContain()
	return list(
			/obj/item/implanter/explosive,
			/obj/item/implantpad
		)

/obj/item/storage/box/syndie_kit/imp_imprinting/WillContain()
	return list(
			/obj/item/implanter/imprinting,
			/obj/item/implantpad,
			/obj/item/chems/hypospray/autoinjector/hallucinogenics
		)

// Space suit uplink kit
/obj/item/storage/backpack/satchel/syndie_kit/space/WillContain()
	return list(
			/obj/item/clothing/suit/space/void/merc,
			/obj/item/clothing/head/helmet/space/void/merc,
			/obj/item/clothing/mask/gas/syndicate,
			/obj/item/tank/emergency/oxygen/double,
		)

// Chameleon uplink kit
/obj/item/storage/backpack/chameleon/sydie_kit
	material = /decl/material/solid/metal/gold
	matter = list(
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/fiberglass = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_TRACE
	)

/obj/item/storage/backpack/chameleon/sydie_kit/WillContain()
	return list(
			/obj/item/clothing/under/chameleon,
			/obj/item/clothing/suit/chameleon,
			/obj/item/clothing/shoes/chameleon,
			/obj/item/clothing/head/chameleon,
			/obj/item/clothing/mask/chameleon,
			/obj/item/storage/box/syndie_kit/chameleon,
			/obj/item/gun/energy/chameleon,
		)

/obj/item/storage/box/syndie_kit/chameleon/WillContain()
	return list(
			/obj/item/clothing/gloves/chameleon,
			/obj/item/clothing/glasses/chameleon,
			/obj/item/radio/headset/chameleon,
			/obj/item/clothing/accessory/chameleon,
			/obj/item/clothing/accessory/chameleon,
			/obj/item/clothing/accessory/chameleon
		)

// Clerical uplink kit
/obj/item/storage/backpack/satchel/syndie_kit/clerical/WillContain()
	return list(
			/obj/item/stack/package_wrap/twenty_five,
			/obj/item/hand_labeler,
			/obj/item/stamp/multi/chameleon,
			/obj/item/pen/chameleon,
			/obj/item/destTagger,
		)

/obj/item/storage/box/syndie_kit/spy/WillContain()
	return list(
		/obj/item/spy_bug = 6,
		/obj/item/spy_monitor
	)

/obj/item/storage/box/syndie_kit/silenced/WillContain()
	return list(
		/obj/item/gun/projectile/pistol/holdout,
		/obj/item/silencer,
		/obj/item/ammo_magazine/pistol/small
	)

/obj/item/storage/backpack/satchel/syndie_kit/revolver/WillContain()
	return list(
		/obj/item/gun/projectile/revolver,
		/obj/item/ammo_magazine/speedloader
	)

/obj/item/storage/box/syndie_kit/toxin/WillContain()
	return list(
		/obj/item/chems/glass/beaker/vial/random/toxin,
		/obj/item/chems/syringe
	)

/obj/item/storage/box/syndie_kit/syringegun/WillContain()
	return list(
		/obj/item/gun/launcher/syringe/disguised,
		/obj/item/syringe_cartridge = 4,
		/obj/item/chems/syringe = 4
	)

/obj/item/storage/box/syndie_kit/cigarette
	name = "\improper Tricky smokes"
	desc = "Smokes so good, you'd think it was a trick!"

/obj/item/storage/box/syndie_kit/cigarette/WillContain()
	return list(
		/obj/item/storage/fancy/cigarettes/flash_powder = 2,
		/obj/item/storage/fancy/cigarettes/chemsmoke = 2,
		/obj/item/storage/fancy/cigarettes/mindbreak,
		/obj/item/storage/fancy/cigarettes/tricord,
		/obj/item/flame/lighter/zippo/random,
		)

//Rig Electrowarfare and Voice Synthesiser kit
/obj/item/storage/backpack/satchel/syndie_kit/ewar_voice/WillContain()
	return list(
			/obj/item/rig_module/electrowarfare_suite,
			/obj/item/rig_module/voice,
		)

/obj/item/storage/secure/briefcase/heavysniper/WillContain()
	return list(
		/obj/item/gun/projectile/bolt_action/sniper,
		/obj/item/storage/box/ammo/sniperammo
	)

/obj/item/storage/secure/briefcase/heavysniper/Initialize(ml, material_key)
	. = ..()
	if(length(contents))
		make_exact_fit()

/obj/item/storage/secure/briefcase/money/WillContain()
	return list(/obj/item/cash/c1000 = 10)

/obj/item/storage/backpack/satchel/syndie_kit/armor/WillContain()
	return list(
		/obj/item/clothing/suit/armor/pcarrier/merc,
		/obj/item/clothing/head/helmet/merc
	)
